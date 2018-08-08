part of '../grind.dart';

const _credentialsTemplate = '''
{
  "accessToken": "{{ACCESS_TOKEN}}",
  "refreshToken": "{{REFRESH_TOKEN}}",
  "tokenEndpoint": "{{TOKEN_ENDPOINT}}",
  "scopes": ["{{SCOPES}}"],
  "expiration": {{EXPIRATION}}
}
''';

@Task(
    'Used on the CI server to automatically publish the package when appropriate')
Future<Null> ciPublish() async {
  if (!await _shouldPublish()) {
    log('Not publishing.');
    return;
  }

  final pubCacheDir =
      new Directory(path.join(Platform.environment['HOME'], '.pub-cache'));

  log("Writing the credentials file...");

  var credentials = _credentialsTemplate;

  // Replace all placeholders in the template with the actual values in the ENV vars.
  const [
    'ACCESS_TOKEN',
    'REFRESH_TOKEN',
    'TOKEN_ENDPOINT',
    'SCOPES',
    'EXPIRATION'
  ].forEach((String envVar) {
    credentials =
        credentials.replaceFirst('{{$envVar}}', Platform.environment[envVar]);
  });

  // Create the pub-cache directory for the key.
  await pubCacheDir.create(recursive: true);

  // Write the credentials file.
  await new File(path.join(pubCacheDir.path, 'credentials.json'))
      .writeAsString(credentials);

  // Publish the package.
  run('pub', arguments: ['publish', '-f']);
}

Future<bool> _shouldPublish() async {
  log('Comparing versions with pub now, to see if we should publish...');
  final package = await PubClient().getPackage('gitlab');
  final pubspec = await new File('pubspec.yaml').readAsString();
  final version =
      new RegExp(r'^version:\s*(.*)$', multiLine: true, caseSensitive: false)
          .firstMatch(pubspec)
          .group(1);
  if (version != package.latest.version) {
    log('Publish the package! This version is $version and pub has ${package.latest.version}');
    return true;
  } else {
    log('Do not publish. Both versions are $version.');
    return false;
  }
}
