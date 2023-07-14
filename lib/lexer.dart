enum Token {
    eof(),
    colon();
}

class Lexer {
    final String _input;
    
    Lexer(this._input);

    Token nextToken() {
        if (_input == '') {
            return Token.eof;
        }
        return Token.colon;
    }
}
