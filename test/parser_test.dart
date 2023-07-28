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

  test('exercise() should transform \'Squat 3x5\' in a squat exercise', () {
    Parser parser = Parser(Lexer('Squat 3x5'));
    expect(parser.exercise().name.value, 'Squat');
  });

  test(
      'session() should transform \'Session A...\' in a session node named \'A\'',
      () {
    Parser parser = Parser(Lexer('Session A:\nSquat 3x5'));
    expect(parser.session().name.value, 'A');
  });

  test(
      'session() should transform \'Session A...\' in a session with the first exercise',
      () {
    Parser parser = Parser(Lexer('Session A:\nSquat 3x5'));
    expect(parser.session().exercises[0].name.value, 'Squat');
  });

  test(
      'session() should transform \'Session A...\' in a session with the second exercise',
      () {
    Parser parser = Parser(Lexer('Session A:\nSquat 3x5\nPress 3x5'));
    expect(parser.session().exercises[1].name.value, 'Press');
  });

  test(
      'session() should transform \'Session A...\' in a session with the third exercise',
      () {
    Parser parser =
        Parser(Lexer('Session A:\nSquat 3x5\nPress 3x5\n\nDeadlift 1x5'));
    expect(parser.session().exercises[2].name.value, 'Deadlift');
  });

  test(
      'rule() should transform \'Squat goes up 2.5kg every time\' in a rule for the squat',
      () {
    Parser parser = Parser(Lexer('Squat goes up 2.5kg every time'));
    expect(parser.rule().exerciseName.value, 'Squat');
  });

  test(
      'rule() should transform \'Squat goes up 2.5kg every time\' in a rule for adding load',
      () {
    Parser parser = Parser(Lexer('Squat goes up 2.5kg every time'));
    expect(parser.rule().type, RuleType.up);
  });

  test(
      'rule() should transform \'Squat goes up 2.5kg every time\' in a rule with a load in kg',
      () {
    Parser parser = Parser(Lexer('Squat goes up 2.5kg every time'));
    expect(parser.rule().load.unit, Unit.kg);
  });

  test(
      'rule() should transform \'Squat goes up 2.5kg every time\' in a rule of period 1',
      () {
    Parser parser = Parser(Lexer('Squat goes up 2.5kg every time'));
    expect(parser.rule().period.value, 1);
  });

  test(
      'rule() should transform \'Row goes up 2.5kg every 2 times\' in a rule of period 2',
      () {
    Parser parser = Parser(Lexer('Row goes up 2.5kg every 2 times'));
    expect(parser.rule().period.value, 2);
  });

  test('workload() should transform \'3x5x60kg\' in a workload in kg', () {
    Parser parser = Parser(Lexer('3x5x60kg'));
    expect(parser.workload().load.unit, Unit.kg);
  });

  test(
      'trainingSession() should transform \'Training session 1 (A)...\' in a log for an A training session',
      () {
    Parser parser = Parser(Lexer('Training session 1 (A):\nSquat 3x5x60kg'));
    expect(parser.trainingSession().type.value, 'A');
  });

  test(
      'trainingSession() should transform \'Training session 1 (A)...\' in a log with the first exercise',
      () {
    Parser parser = Parser(Lexer('Training session 1 (A):\nSquat 3x5x60kg'));
    expect(parser.trainingSession().exercises[0].name.value, 'Squat');
  });

  test(
      'trainingSession() should transform \'Training session 1 (A)...\' in a log with the second exercise',
      () {
    Parser parser = Parser(
        Lexer('Training session 1 (A):\nSquat 3x5x60kg\nPress 3x5x30kg'));
    expect(parser.trainingSession().exercises[1].name.value, 'Press');
  });

  test('A list of rules should start with \'Progression:...\'', () {
    Parser parser = Parser(
        Lexer('Progression:\nSquat goes up 2.5kg every time'));
    expect(parser.progression().rules[0].exerciseName.value, 'Squat');
  });

  test('A list of rules can have more than one rule', () {
    Parser parser = Parser(
        Lexer('Progression:\nSquat goes up 2.5kg every time\nDeadlift goes up 2.5kg every time'));
    expect(parser.progression().rules[1].exerciseName.value, 'Deadlift');
  });

  test('A training program has the sessions of the program', () {
    Parser parser = Parser(
        Lexer('Session A:\nSquat 3x5\nProgression:\nSquat goes up 2.5kg every time'));
    expect(parser.program().sessions[0].name.value, 'A');
  });

  test('A training program has the rules for progression', () {
    Parser parser = Parser(
        Lexer('Session A:\nSquat 3x5\nProgression:\nSquat goes up 2.5kg every time'));
    expect(parser.program().progression.rules[0].exerciseName.value, 'Squat');
  });

  test('A training program can have several sessions', () {
    Parser parser = Parser(
        Lexer('Session A:\nSquat 3x5\nSession B:\nSquat 3x5\nProgression:\nSquat goes up 2.5kg every time'));
    expect(parser.program().sessions[1].name.value, 'B');
  });

  test('A training program can have several rules', () {
    Parser parser = Parser(
        Lexer('Session A:\nSquat 3x5\nSession B:\nDeadlift 1x5\nProgression:\nSquat goes up 2.5kg every time\nDeadlift goes up 5kg every time'));
    expect(parser.program().progression.rules[1].exerciseName.value, 'Deadlift');
  });
}
