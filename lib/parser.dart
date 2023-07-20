import 'package:stpl/lexer.dart';

enum NodeType {
  name,
}

class Name {
  final String value;

  Name(this.value);
}

class Parser {
  final Lexer lexer;

  Parser(this.lexer);

  name() {
    return Name(lexer.nextToken().value);
  }
}
