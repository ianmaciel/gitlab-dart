import 'dart:async';

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
  await runAsync('dartanalyzer', arguments: ['.', '--fatal-hints', '--fatal-warnings', '--fatal-lints']);
}

@Task('Builds the documentation')
Future<Null> doc() async {
  await runAsync('dartdoc', arguments: [
    '--output',
    'public',
    '--hosted-url',
    'http://exitlive.gitlab.io/gitlab-dart/',
  ]);
}
