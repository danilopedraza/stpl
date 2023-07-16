enum TokenType {
    eof(''),
    colon(':'),
    lineBreak('\n'),
    session('session'),
    times('x'),
    name('[a-zA-Z]+');

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

    String get lookahead => input[lookaheadIndex];
    
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

    void consumeNonSeparators() {
        while (lookaheadIndex < input.length && !isSeparator(lookahead)) {
            consume();
        }
    }

    Token nextToken() {
        consumeSeparators();
        final int start = lookaheadIndex;

        consumeNonSeparators();
        final int end = lookaheadIndex;

        final String substring = input.substring(start, end);
        final TokenType type = TokenType.values.firstWhere((token) => token.exp.hasMatch(substring));

        return Token(type, substring);
    }
}
