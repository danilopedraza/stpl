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
}
