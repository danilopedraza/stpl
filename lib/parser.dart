import 'package:stpl/lexer.dart';

class Name {
  final String value;

  Name(this.value);
}

class Amount {
  final num value;

  Amount(this.value);
}

enum Unit {
  kg,
}

class Load {
  final Amount amount;
  final Unit unit;

  Load(this.amount, this.unit);
}

class Prescription {
  final Amount sets;
  final Amount reps;

  Prescription(this.sets, this.reps);
}

class Parser {
  final Lexer lexer;

  consume(TokenType expectedType) {
    final Token lookahead = lexer.nextToken();

    if (lookahead.type != expectedType) {
      throw FormatException();
    }

    return lookahead;
  }

  Parser(this.lexer);

  Name name() {
    return Name(consume(TokenType.name).value);
  }

  Amount amount() {
    return Amount(double.parse(consume(TokenType.number).value));
  }

  Unit unit() {
    consume(TokenType.kg);
    return Unit.kg;
  }

  Load load() {
    return Load(amount(), unit());
  }

  Prescription prescription() {
    final Amount sets = amount();
    consume(TokenType.separator);
    final Amount reps = amount();

    return Prescription(sets, reps);
  }
}
