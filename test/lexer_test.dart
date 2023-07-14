import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('The next token from a lexer with an empty string should be of type EOF', () {
    
    expect(Lexer('').nextToken(), Token.EOF);
  });
}