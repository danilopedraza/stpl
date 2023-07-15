enum Token {
    eof(''),
    colon(':'),
    lineBreak('\n');

    final String _exp;
    const Token(this._exp);

    RegExp get exp => RegExp('^$_exp\$');

    bool matches(String str) => exp.hasMatch(str);
}

class Lexer {
    final String input;
    int lookaheadIndex = 0;
    
    Lexer(this.input);

    void consume() {
        lookaheadIndex++;
    }

    bool isSeparator(String char) {
        return char == ' ' || char == '\t' || char == '\r';
    }

    void consumeSeparators() {
        while (lookaheadIndex < input.length && isSeparator(input[lookaheadIndex])) {
            consume();
        }
    }

    void consumeNonSeparators() {
        while (lookaheadIndex < input.length && !isSeparator(input[lookaheadIndex])) {
            consume();
        }
    }

    Token nextToken() {
        consumeSeparators();
        final int start = lookaheadIndex;

        consumeNonSeparators();
        final int end = lookaheadIndex;

        final String substring = input.substring(start, end);
        return Token.values.firstWhere((token) => token.matches(substring));
    }
}
