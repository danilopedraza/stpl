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

class Prescription {
  final Name exercise;
  final Workload workload;

  Prescription(this.exercise, this.workload);
}

class Session {
  final Name name;
  final List<Prescription> prescriptions;

  Session(this.name, this.prescriptions);
}

class Parser {
  final Lexer lexer;
  Token lookahead;

  Parser(this.lexer) : lookahead = lexer.nextToken();

  void match(TokenType expected, TokenType actual) {
    if (expected != actual) {
      throw FormatException(
          'expected \'${expected.name}\', got \'${actual.name}\'');
    }
  }

  Token consume(TokenType expectedType) {
    match(expectedType, lookahead.type);
    final Token oldLookahead = lookahead;
    lookahead = lexer.nextToken();

    return oldLookahead;
  }

  Name name() => Name(consume(TokenType.name));

  Amount amount() => Amount(consume(TokenType.number));

  Unit unit() {
    consume(TokenType.kg);
    return Unit.kg;
  }

  Load load() => Load(amount(), unit());

  void separator() {
    consume(TokenType.separator);
  }

  Workload workload() {
    final Amount sets = amount();
    separator();
    final Amount reps = amount();

    return Workload(sets, reps);
  }

  Prescription prescription() => Prescription(name(), workload());

  Session session() {
    consume(TokenType.session);
    Name sessionName = name();
    consume(TokenType.colon);
    consume(TokenType.lineBreak);

    List<Prescription> prescriptions = [];

    do {
      prescriptions.add(prescription());
      if (lookahead.type == TokenType.lineBreak) {
        consume(TokenType.lineBreak);
      }
    } while (lookahead.type == TokenType.name);

    return Session(sessionName, prescriptions);
  }
}
