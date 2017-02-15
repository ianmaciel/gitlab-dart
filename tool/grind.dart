import 'dart:async';
import 'dart:io' hide ProcessException;

import 'package:grinder/grinder.dart';
import 'package:logging/logging.dart';

void main(List<String> args) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) => log(record.message));
  grind(args);
}

@Task('Runs all tests required to pass')
@Depends(analyze)
bool test() => true;

@Task('Runs dartanalyzer and makes sure there are no warnings or lint proplems')
Future<Null> analyze() async {
  final result = Process.runSync('dartanalyzer', ['.', '--fatal-hints', '--fatal-warnings', '--fatal-lints']);
  if (result.exitCode != 0) {
    log(result.stdout);
    log(result.stderr);
    fail('The dartanalyzer found some problems.');
  }
}

@Task('Builds the documentation')
Future<Null> doc() async {
  final result = Process.runSync('dartdoc', [
    '--output',
    'public',
    '--use-categories',
    '--hosted-url',
    'http://exit-live.gitlab.io/gitlab-dart/',
  ]);
  log(result.stdout);
  log(result.stderr);
  if (result.exitCode != 0) fail('Unable to build the docs');
}
