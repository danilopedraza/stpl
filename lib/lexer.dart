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

    Token nextToken() {
        if (_lookaheadIndex >= _input.length) {
            return Token.eof;
        }

        while (_lookaheadIndex < _input.length && (_input[_lookaheadIndex] == ' ' || _input[_lookaheadIndex] == '\t' || _input[_lookaheadIndex] == '\r')) {
            consume();
        }

        final int start = _lookaheadIndex + 0;

        while (_lookaheadIndex < _input.length && (_input[_lookaheadIndex] != ' ' && _input[_lookaheadIndex] != '\t' && _input[_lookaheadIndex] != '\r')) {
            consume();
        }

        final int end = _lookaheadIndex + 0;

        final String substring = _input.substring(start, end);

        return Token.values.firstWhere((token) => token.matches(substring));
    }
}
