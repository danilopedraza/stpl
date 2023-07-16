enum TokenType {
  eof(''),
  colon(':'),
  lineBreak('\n'),
  session('session'),
  times('x'),
  name('[a-zA-Z]+'),
  none('');

  final String _exp;
  const TokenType(this._exp);

  RegExp get exp => RegExp('^$_exp\$', caseSensitive: false);
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
        TokenType.values
            .any((type) => type.exp.hasMatch(substring + lookahead))) {
      substring += lookahead;
      consume();
    }

    TokenType type =
        TokenType.values.firstWhere((type) => type.exp.hasMatch(substring));

    return Token(type, substring);
  }
}
