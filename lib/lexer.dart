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

    Token nextToken() {
        if (lookaheadIndex >= input.length) {
            return Token.eof;
        }

        while (lookaheadIndex < input.length && isSeparator(input[lookaheadIndex])) {
            consume();
        }

        final int start = lookaheadIndex;

        while (lookaheadIndex < input.length && !isSeparator(input[lookaheadIndex])) {
            consume();
        }

        final int end = lookaheadIndex;

        final String substring = input.substring(start, end);

        return Token.values.firstWhere((token) => token.matches(substring));
    }
}
