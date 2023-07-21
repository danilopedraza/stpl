import 'package:stpl/lexer.dart';

class Name {
  final String value;

  Name(Token nameToken) : value = nameToken.value;
}

class Amount {
  final num value;

  Amount(Token numberToken) : value = double.parse(numberToken.value);
}

enum Unit {
  kg,
}

class Load {
  final Amount amount;
  final Unit unit;

  Load(this.amount, this.unit);
}

class Workload {
  final Amount sets;
  final Amount reps;

  Workload(this.sets, this.reps);
}

class Parser {
  final Lexer lexer;

  void match(TokenType expected, TokenType actual) {
    if (expected != actual) {
      throw FormatException(
          'expected \'${expected.name}\', got \'${actual.name}\'');
    }
  }

  Token consume(TokenType expectedType) {
    final Token lookahead = lexer.nextToken();
    match(expectedType, lookahead.type);

    return lookahead;
  }

  Parser(this.lexer);

  Name name() {
    return Name(consume(TokenType.name));
  }

  Amount amount() {
    return Amount(consume(TokenType.number));
  }

  Unit unit() {
    consume(TokenType.kg);
    return Unit.kg;
  }

  Load load() {
    return Load(amount(), unit());
  }

  Workload workload() {
    final Amount sets = amount();
    consume(TokenType.separator);
    final Amount reps = amount();

    return Workload(sets, reps);
  }
}
