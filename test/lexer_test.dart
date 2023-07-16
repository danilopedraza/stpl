import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('An empty string should result in an eof token', () {
    expect(Lexer('').nextToken().type, TokenType.eof);
  });

  test('A space should result in an eof token', () {
    expect(Lexer(' ').nextToken().type, TokenType.eof);
  });

  test('Two spaces should result in an eof token', () {
    expect(Lexer('  ').nextToken().type, TokenType.eof);
  });

  test('Every separator once should result in an eof token', () {
    expect(Lexer(' \t\r').nextToken().type, TokenType.eof);
  });

  test('A colon should result in a colon token', () {
    expect(Lexer(':').nextToken().type, TokenType.colon);
  });

  test('A line break should result in a lineBreak token', () {
    expect(Lexer('\n').nextToken().type, TokenType.lineBreak);
  });

  test('\'session\' should result in a session token', () {
    expect(Lexer('session').nextToken().type, TokenType.session);
  });

  test('\'Session\' should result in a session token', () {
    expect(Lexer('Session').nextToken().type, TokenType.session);
  });

  test('\'SESSION\' should result in a session token', () {
    expect(Lexer('SESSION').nextToken().type, TokenType.session);
  });

  test('\'x\' should result in a times token', () {
    expect(Lexer('x').nextToken().type, TokenType.times);
  });

  test('\'squat\' should result in a name token', () {
    expect(Lexer('squat').nextToken().type, TokenType.name);
  });

  test('\'squat\' should result in a token with the value \'squat\'', () {
    expect(Lexer('squat').nextToken().value, 'squat');
  });

  test('\'Press\' should result in a name token', () {
    expect(Lexer('Press').nextToken().type, TokenType.name);
  });

  test('\'Press\' should result in a token with the value \'Press\'', () {
    expect(Lexer('Press').nextToken().value, 'Press');
  });

  test('\'Session:\' should result in the first token being session', () {
    expect(Lexer('Session:').nextToken().type, TokenType.session);
  });

  test('\'Session:\' should result in the second token being colon', () {
    Lexer lexer = Lexer('Session:');
    lexer.nextToken();
    expect(lexer.nextToken().type, TokenType.colon);
  });
}
