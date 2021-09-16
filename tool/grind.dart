import 'dart:async';

import 'package:grinder/grinder.dart';
import 'package:logging/logging.dart';
// TODO: grind_publish does not support nul safety
// import 'package:grind_publish/grind_publish.dart' as grind_publish;

const _lineLength = 80;

void main(List<String> args) {
  Logger.root.onRecord.listen((record) => log(record.message));
  grind(args);
}

@Task('Runs all tests required to pass')
@Depends(analyze, unitTest, checkFormat)
bool test() => true;

@Task('Runs the unit tests for this library')
Future unitTest() => new TestRunner().testAsync(concurrency: 4);

@Task('Runs dartanalyzer and makes sure there are no warnings or lint proplems')
Future<Null> analyze() async {
  await runAsync(
    'dart',
    arguments: [
      'analyze',
      '.',
      '--fatal-warnings',
      '--fatal-infos',
    ],
  );
}

@Task()
void checkFormat() {
  try {
    Dart.run('format', arguments: <String>[
      '--line-length',
      _lineLength.toString(),
      '--output=none',
      '--set-exit-if-changed',
      '.',
    ]);
  } on ProcessException {
    fail('Code is not properly formatted. Run `grind format`');
  }
}

@Task()
void format() => Dart.run('format', arguments: <String>[
      '--line-length',
      _lineLength.toString(),
      '.',
    ]);

@Task()
Future autoPublish() =>
    // TODO: grind_publish does not support nul safety
    // grind_publish.autoPublish(
    //     'gitlab', grind_publish.Credentials.fromEnvironment());
    Future<bool>.value(true);
