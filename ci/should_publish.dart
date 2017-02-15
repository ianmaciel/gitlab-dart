import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import "package:pub_client/pub_client.dart";

Future<Null> main() async {
  Logger.root.onRecord.listen((record) => print(record.message));

  final log = new Logger('ShouldPublish');

  log.info('Comparing versions with pub now, to see if we should publish...');
  final client = new PubClient();
  final package = await client.getPackage("gitlab");
  final pubspec = await new File('pubspec.yaml').readAsString();
  final version = new RegExp(r'^version:\s*(.*)$', multiLine: true, caseSensitive: false).firstMatch(pubspec).group(1);
  if (version != package.latest.version) {
    log.info('Publish the package! This version is $version and pub has ${package.latest.version}');
    exit(0);
  } else {
    log.info('Do not publish. Both versions are $version.');
    exit(1);
  }
}
