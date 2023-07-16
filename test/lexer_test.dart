import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('An empty string should result in an eof token', () {
    expect(Lexer('').nextToken(), Token.eof);
  });

  test('A space should result in an eof token', () {
    expect(Lexer(' ').nextToken(), Token.eof);
  });

  test('Two spaces should result in an eof token', () {
    expect(Lexer('  ').nextToken(), Token.eof);
  });

  test('Every separator once should result in an eof token', () {
    expect(Lexer(' \t\r').nextToken(), Token.eof);
  });

  test('A colon should result in a colon token', () {
    expect(Lexer(':').nextToken(), Token.colon);
  });

  test('A line break should result in a lineBreak token', () {
    expect(Lexer('\n').nextToken(), Token.lineBreak);
  });
}
