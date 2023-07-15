enum Token {
    eof(''),
    colon(':'),
    lineBreak('\n');

    final String _exp;
    const Token(this._exp);

    String get exp => '^$_exp\$';

    bool matches(String str) => RegExp(exp).hasMatch(str);
}

class Lexer {
    final String _input;
    int _lookaheadIndex = 0;
    
    Lexer(this._input);

    void consume() {
        _lookaheadIndex++;
    }

    bool isSeparator(String char) {
        return char == ' ' || char == '\t' || char == '\r';
    }

    Token nextToken() {
        if (_lookaheadIndex >= _input.length) {
            return Token.eof;
        }

        while (_lookaheadIndex < _input.length && isSeparator(_input[_lookaheadIndex])) {
            consume();
        }

        final int start = _lookaheadIndex;

        while (_lookaheadIndex < _input.length && !isSeparator(_input[_lookaheadIndex])) {
            consume();
        }

        final int end = _lookaheadIndex;

        final String substring = _input.substring(start, end);

        return Token.values.firstWhere((token) => token.matches(substring));
    }
}
