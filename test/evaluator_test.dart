import 'package:stpl/evaluator.dart';
import 'package:stpl/lexer.dart';
import 'package:stpl/parser.dart';
import 'package:test/test.dart';

void main() {
  test('nextSession() should give the expected exercise for the next session',
      () {
    const String input = '''Session A:
                              Squat 3x5
                            Progression:
                              Squat goes up 1kg every time
                            Training session 1 (A):
                              Squat 3x5x20kg
''';
    Evaluator evaluator = Evaluator(Parser(Lexer(input)));
    expect(evaluator.nextSession().exercises[0].name.value, 'Squat');
  });

  test('nextSession() should give the expected session type', () {
    const String input = '''Session A:
                              Squat 3x5
                            Session B:
                              Squat 3x5
                            Progression:
                              Squat goes up 1kg every time
                            Training session 1 (A):
                              Squat 3x5x20kg
''';
    Evaluator evaluator = Evaluator(Parser(Lexer(input)));
    expect(evaluator.nextSession().type.value, 'B');
  });
}
