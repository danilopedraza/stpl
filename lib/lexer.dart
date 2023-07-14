enum TokenType {
    EOF,
}

enum Token {
    EOF();
}

class Lexer {
    final String _input;
    int _lookaheadIndex = 0;
    
    Lexer(this._input);

    Token nextToken() {
        return Token.EOF;
    }
}
