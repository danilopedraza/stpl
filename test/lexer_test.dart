import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('The next token from a lexer with an empty string should be of type eof', () {
    expect(Lexer('').nextToken(), Token.eof);
  });

  test('The next token from a lexer with a space should be of type eof', () {
    expect(Lexer(' ').nextToken(), Token.eof);
  });

  test('The next token from a lexer with two spaces should be of type eof', () {
    expect(Lexer('  ').nextToken(), Token.eof);
  });

  test('The next token from a lexer with separators only should be of type eof', () {
    expect(Lexer(' \t\r').nextToken(), Token.eof);
  });

  test('The next token from a lexer with a string with just a colon should be of type colon', () {
    expect(Lexer(':').nextToken(), Token.colon);
  });

  test('The next token from a lexer with a line break should be of type lineBreak', () {
    expect(Lexer('\n').nextToken(), Token.lineBreak);
  });
}
