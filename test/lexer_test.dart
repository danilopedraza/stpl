import 'package:stpl/lexer.dart';
import 'package:test/test.dart';

void expectTypes(String str, List<TokenType> types) {
  Lexer lexer = Lexer(str);
  for (final type in types) {
    expect(lexer.nextToken().type, type);
  }
}

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

  test('\'x\' should result in a separator token', () {
    expect(Lexer('x').nextToken().type, TokenType.separator);
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

  test('\'goes\' should result in a goes token', () {
    expect(Lexer('goes').nextToken().type, TokenType.goes);
  });

  test('\'up\' should result in an up token', () {
    expect(Lexer('up').nextToken().type, TokenType.up);
  });

  test('\'down\' should result in a down token', () {
    expect(Lexer('down').nextToken().type, TokenType.down);
  });

  test('\'kg\' should result in a kg token', () {
    expect(Lexer('kg').nextToken().type, TokenType.kg);
  });

  test('\'every\' should result in an every token', () {
    expect(Lexer('every').nextToken().type, TokenType.every);
  });

  test('\'time\' should result in a time token', () {
    expect(Lexer('time').nextToken().type, TokenType.time);
  });

  test('\'times\' should result in a times token', () {
    expect(Lexer('times').nextToken().type, TokenType.times);
  });

  test('\'5\' should result in a number token', () {
    expect(Lexer('5').nextToken().type, TokenType.number);
  });

  test('\'5\' should result in a token with the value \'5\'', () {
    expect(Lexer('5').nextToken().value, '5');
  });

  test('\'10\' should result in a number token', () {
    expect(Lexer('10').nextToken().type, TokenType.number);
  });

  test('\'10\' should result in a token with the value \'10\'', () {
    expect(Lexer('10').nextToken().value, '10');
  });

  test('\'2.5\' should result in a number token', () {
    expect(Lexer('2.5').nextToken().type, TokenType.number);
  });

  test('\'2.5\' should result in a token with the value \'2.5\'', () {
    expect(Lexer('2.5').nextToken().value, '2.5');
  });

  test('\'0.1\' should result in a number token', () {
    expect(Lexer('0.1').nextToken().type, TokenType.number);
  });

  test('\'0.1\' should result in a token with the value \'0.1\'', () {
    expect(Lexer('0.1').nextToken().value, '0.1');
  });

  test('\'0.05\' should result in a number token', () {
    expect(Lexer('0.05').nextToken().type, TokenType.number);
  });

  test('\'0.05\' should result in a token with the value \'0.05\'', () {
    expect(Lexer('0.05').nextToken().value, '0.05');
  });

  test('\'1.\' should result in a number token', () {
    expect(Lexer('1.').nextToken().type, TokenType.number);
  });

  test('\'1.\' should result in a token with the value \'1.\'', () {
    expect(Lexer('1.').nextToken().value, '1.');
  });

  test('\'%\' should result in a percentage token', () {
    expect(Lexer('%').nextToken().type, TokenType.percentage);
  });

  test('\',\' should result in a comma token', () {
    expect(Lexer(',').nextToken().type, TokenType.comma);
  });

  test('\'of\' should result in an of token', () {
    expect(Lexer('of').nextToken().type, TokenType.of);
  });

  test('\'AMAP\' should result in an amap token', () {
    expect(Lexer('AMAP').nextToken().type, TokenType.amap);
  });

  test('\'Session A:\\n\' should result in four specific tokens', () {
    expectTypes('Session A:\n', [
      TokenType.session,
      TokenType.name,
      TokenType.colon,
      TokenType.lineBreak,
    ]);
  });

  test('\'Squat 3x5:\\n\' should result in five specific tokens', () {
    expectTypes('Squat 3x5\n', [
      TokenType.name,
      TokenType.number,
      TokenType.separator,
      TokenType.number,
      TokenType.lineBreak,
    ]);
  });

  test(
      '\'Squat goes up 2.5kg every time\' should result in seven specific tokens',
      () {
    expectTypes('Squat goes up 2.5kg every time', [
      TokenType.name,
      TokenType.goes,
      TokenType.up,
      TokenType.number,
      TokenType.kg,
      TokenType.every,
      TokenType.time,
      TokenType.eof,
    ]);
  });
}
