import 'package:stpl/lexer.dart';
import 'package:stpl/parser.dart';
import 'package:test/test.dart';

void main() {
  test('name() should transform \'Squat\' in a name node', () {
    Parser parser = Parser(Lexer('Squat'));
    expect(parser.name() is Name, true);
  });

  test('name() should transform \'Squat\' in a node with value \'Squat\'', () {
    Parser parser = Parser(Lexer('Squat'));
    expect(parser.name().value, 'Squat');
  });

  test('amount() should transform \'5\' in an amount node', () {
    Parser parser = Parser(Lexer('5'));
    expect(parser.amount() is Amount, true);
  });

  test('amount() should transform \'5\' in a node with the amount 5', () {
    Parser parser = Parser(Lexer('5'));
    expect(parser.amount().value, 5.0);
  });

  test('unit() should transform \'kg\' in the Unit.kg node', () {
    Parser parser = Parser(Lexer('kg'));
    expect(parser.unit(), Unit.kg);
  });

  test('load() should transform \'5kg\' in a load node', () {
    Parser parser = Parser(Lexer('5kg'));
    expect(parser.load() is Load, true);
  });

  test('load() should transform \'5kg\' in a load of 5', () {
    Parser parser = Parser(Lexer('5kg'));
    expect(parser.load().amount.value, 5.0);
  });

  test('load() should transform \'5kg\' in a load in kilos', () {
    Parser parser = Parser(Lexer('5kg'));
    expect(parser.load().unit, Unit.kg);
  });

  test('prescription() should transform \'3x5\' in a prescription node', () {
    Parser parser = Parser(Lexer('3x5'));
    expect(parser.prescription() is Prescription, true);
  });

  test('prescription() should transform \'3x5\' in a prescription of 3 sets',
      () {
    Parser parser = Parser(Lexer('3x5'));
    expect(parser.prescription().sets.value, 3);
  });

  test(
      'prescription() should transform \'3x5\' in a prescription of sets of 5 reps',
      () {
    Parser parser = Parser(Lexer('3x5'));
    expect(parser.prescription().reps.value, 5);
  });
}
