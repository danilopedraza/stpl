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
    TokenType type = switch (lookahead) {
      '' => TokenType.eof,
      ':' => TokenType.colon,
      '\n' => TokenType.lineBreak,
      'x' => TokenType.times,
      _ => (() {
          if (TokenType.name.exp.hasMatch(lookahead)) {
            return TokenType.name;
          } else {
            return TokenType.none;
          }
        })(),
    };

    String substring = '';
    while (lookaheadIndex < input.length &&
        type.exp.hasMatch(substring + lookahead)) {
      substring += lookahead;
      consume();
    }

    if (TokenType.session.exp.hasMatch(substring)) {
      type = TokenType.session;
    }

    return Token(type, substring);
  }
}
