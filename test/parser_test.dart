import 'package:stpl/lexer.dart';
import 'package:stpl/parser.dart';
import 'package:test/test.dart';

void main() {
  test('name() should transform \'Squat\' in a node with value \'Squat\'', () {
    Parser parser = Parser(Lexer('Squat'));
    expect(parser.name().value, 'Squat');
  });

  test('amount() should transform \'5\' in a node with the amount 5', () {
    Parser parser = Parser(Lexer('5'));
    expect(parser.amount().value, 5.0);
  });

  test('unit() should transform \'kg\' in the Unit.kg node', () {
    Parser parser = Parser(Lexer('kg'));
    expect(parser.unit(), Unit.kg);
  });

  test('load() should transform \'5kg\' in a load of 5', () {
    Parser parser = Parser(Lexer('5kg'));
    expect(parser.load().amount.value, 5.0);
  });

  test('load() should transform \'5kg\' in a load in kilos', () {
    Parser parser = Parser(Lexer('5kg'));
    expect(parser.load().unit, Unit.kg);
  });

  test('workload() should transform \'3x5\' in a workload of 3 sets', () {
    Parser parser = Parser(Lexer('3x5'));
    expect(parser.workload().sets.value, 3);
  });

  test('workload() should transform \'3x5\' in a workload of sets of 5 reps',
      () {
    Parser parser = Parser(Lexer('3x5'));
    expect(parser.workload().reps.value, 5);
  });

  test(
      'workload() should throw a custom FormatException when \'3:5\' is passed',
      () {
    Parser parser = Parser(Lexer('3:5'));
    expect(
        () => parser.workload(),
        throwsA(predicate((FormatException e) =>
            e.message == 'expected \'separator\', got \'colon\'')));
  });

  test(
      'workload() should throw a custom FormatException when \'3kg5\' is passed',
      () {
    Parser parser = Parser(Lexer('3kg5'));
    expect(
        () => parser.workload(),
        throwsA(predicate((FormatException e) =>
            e.message == 'expected \'separator\', got \'kg\'')));
  });

  test('prescription() should transform \'Squat 3x5\' in a squat prescription',
      () {
    Parser parser = Parser(Lexer('Squat 3x5'));
    expect(parser.prescription().exercise.value, 'Squat');
  });
}
