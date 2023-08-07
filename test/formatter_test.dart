import 'package:stpl/evaluator.dart';
import 'package:stpl/formatter.dart';
import 'package:stpl/lexer.dart';
import 'package:stpl/parser.dart';
import 'package:test/test.dart';

void main() {
  test('the formatter should take transform a prescription into a row', () {
    const String input = '''session a:
                            squat 3x5
                            progression:
                            squat goes up 5kg every time
                            training session 1 (a):
                            squat 3x5x55kg
''';
    Evaluator evaluator = Evaluator(Parser(Lexer(input)));
    expect(
        Formatter(evaluator.nextSession()).table,
        equals([
          ['squat', '3', '5', '60kg']
        ]));
  });

  test('the formatter should transform several prescription into several rows',
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
    Evaluator evaluator = Evaluator(Parser(Lexer(input)));
    expect(
        Formatter(evaluator.nextSession()).table,
        equals([
          ['squat', '3', '5', '60kg'],
          ['press', '3', '10', '21kg']
        ]));
  });
}
