enum TokenType {
  eof(''),
  colon(':'),
  lineBreak('\n'),
  down('down'),
  every('every'),
  goes('goes'),
  kg('kg'),
  separator('x'),
  session('session'),
  time('time'),
  times('times'),
  up('up'),
  name('[a-zA-Z]+'),
  number(r'\d+\.?\d*');

  final String _exp;
  const TokenType(this._exp);

  RegExp get exp => RegExp('^$_exp\$', caseSensitive: false);
  bool matches(String str) => exp.hasMatch(str);
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);
}

class Lexer {
  final String input;
  int lookaheadIndex = 0;

  String get lookahead =>
      lookaheadIndex < input.length ? input[lookaheadIndex] : '';

  Lexer(this.input);

  void consume() {
    lookaheadIndex++;
  }

  bool isSeparator(String char) {
    return char == ' ' || char == '\t' || char == '\r';
  }

  void consumeSeparators() {
    while (lookaheadIndex < input.length && isSeparator(lookahead)) {
      consume();
    }
  }

  Token nextToken() {
    consumeSeparators();
    String substring = '';

    while (lookaheadIndex < input.length &&
        TokenType.values.any((type) => type.matches(substring + lookahead))) {
      substring += lookahead;
      consume();
    }

    TokenType type =
        TokenType.values.firstWhere((type) => type.matches(substring));

    return Token(type, substring);
  }
}
