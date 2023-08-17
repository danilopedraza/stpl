import 'package:stpl/evaluator.dart';
import 'package:stpl/formatter.dart';
import 'package:test/test.dart';

void main() {
  test('the formatter should transform a prescription into a row', () {
    const String input = '''session a:
                            squat 3x5
                            progression:
                            squat goes up 5kg every time
                            training session 1 (a):
                            squat 3x5x55kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(
        Formatter(evaluator.nextSession()).table.toList(),
        equals([
          ['squat', '3', '5', '60kg']
        ]));
  });

  test('the formatter should transform several prescriptions into several rows',
      () {
    const String input = '''SESSION a:
                            squat 3x5
                            press 3x10

                            PROGRESSION:
                            squat goes up 5kg EVERY TIME
                            press goes up 1kg EVERY TIME

                            TRAINING SESSION 1 (a):
                            squat 3x5x55kg
                            press 3x10x20kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(
        Formatter(evaluator.nextSession()).table.toList(),
        equals([
          ['squat', '3', '5', '60kg'],
          ['press', '3', '10', '21kg']
        ]));
  });

  test(
      'the formatter should transform a prescription into a CSV-style row with correct column names',
      () {
    const String input = '''SESSION a:
                            squat 3x5

                            PROGRESSION:
                            squat goes up 5kg eVeRy TiMe

                            TRAINING SESSION 1 (a):
                            squat 3x5x55kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(Formatter(evaluator.nextSession()).csv,
        equals('Exercise,sets,reps,load\nsquat,3,5,60kg'));
  });

  test(
      'the formatter should transform several prescriptions into a CSV-style row with correct column names',
      () {
    const String input = '''SESSION a:
                            squat 3x5
                            press 3x10

                            PROGRESSION:
                            squat goes up 5kg EVERY TIME
                            press goes up 1kg EVERY TIME

                            TRAINING SESSION 1 (a):
                            squat 3x5x55kg
                            press 3x10x20kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(Formatter(evaluator.nextSession()).csv,
        equals('Exercise,sets,reps,load\nsquat,3,5,60kg\npress,3,10,21kg'));
  });

  test(
      'the formatter should transform a prescription into a Markdown-style row with correct column names',
      () {
    const String input = '''SESSION a:
                            squat 3x5

                            PROGRESSION:
                            squat goes up 5kg eVeRy TiMe

                            TRAINING SESSION 1 (a):
                            squat 3x5x55kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(
        Formatter(evaluator.nextSession()).markdown,
        equals([
          '| Exercise | sets | reps | load |',
          '| -------- | ---- | ---- | ---- |',
          '| squat    | 3    | 5    | 60kg |',
        ].join('\n')));
  });

  test(
      'the formatter should transform several prescriptions into a Markdown-style row with correct column names',
      () {
    const String input = '''SESSION a:
                            squat 3x5
                            press 3x10

                            PROGRESSION:
                            squat goes up 5kg EVERY TIME
                            press goes up 1kg EVERY TIME

                            TRAINING SESSION 1 (a):
                            squat 3x5x55kg
                            press 3x10x20kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(
        Formatter(evaluator.nextSession()).markdown,
        equals([
          '| Exercise | sets | reps | load |',
          '| -------- | ---- | ---- | ---- |',
          '| squat    | 3    | 5    | 60kg |',
          '| press    | 3    | 10   | 21kg |',
        ].join('\n')));
  });

  test(
      'the formatter should create the Markdown table correctly even with large names',
      () {
    const String input = '''SESSION a:
                            Frontinflons 10x10

                            PROGRESSION:
                            Frontinflons goes up 10kg EVERY TIME

                            TRAINING SESSION 1 (a):
                            Frontinflons 10x10x95kg
''';
    Evaluator evaluator = Evaluator.from(input);
    expect(
        Formatter(evaluator.nextSession()).markdown,
        equals([
          '| Exercise     | sets | reps | load  |',
          '| ------------ | ---- | ---- | ----- |',
          '| Frontinflons | 10   | 10   | 105kg |',
        ].join('\n')));
  });
}
