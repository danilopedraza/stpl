enum Token {
    eof(''),
    colon(':'),
    lineBreak('\n'),
    session('session');

    final String _exp;
    const Token(this._exp);

    RegExp get exp => RegExp('^$_exp\$', caseSensitive: false);
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
        return Token.values.firstWhere((token) => token.exp.hasMatch(substring));
    }
}
