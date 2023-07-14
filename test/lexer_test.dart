import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('The next token from a lexer with an empty string should be of type eof', () {
    
    expect(Lexer('').nextToken(), Token.eof);
  });

  test('The next token from a lexer with a string with just a colon should be of type colon', () {
    
    expect(Lexer(':').nextToken(), Token.colon);
  });
}