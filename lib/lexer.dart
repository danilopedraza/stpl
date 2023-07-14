enum TokenType {
    EOF,
}

enum Token {
    EOF();
}

class Lexer {
    final String _input;
    
    Lexer(this._input);

    Token nextToken() {
        return Token.EOF;
    }
}
