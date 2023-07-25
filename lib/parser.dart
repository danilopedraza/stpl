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
  final Name exerciseName;
  final Workload workload;

  Prescription(this.exerciseName, this.workload);
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

  bool lookaheadIs(TokenType type) => lookahead.type == type;

  void match(TokenType expected) {
    if (!lookaheadIs(expected)) {
      throw FormatException(
          'expected \'${expected.name}\', got \'${lookahead.type.name}\'');
    }
  }

  Token consume(TokenType expectedType) {
    match(expectedType);
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

  void colon() {
    consume(TokenType.colon);
  }

  void lineBreak() {
    consume(TokenType.lineBreak);
  }

  void lineBreaks() {
    do {
      lineBreak();
    } while (lookaheadIs(TokenType.lineBreak));
  }

  Workload workload() {
    final Amount sets = amount();
    separator();
    final Amount reps = amount();

    return Workload(sets, reps);
  }

  Prescription prescription() => Prescription(name(), workload());

  List<Prescription> prescriptions() {
    List<Prescription> res = [];

    do {
      res.add(prescription());

      if (lookaheadIs(TokenType.eof)) {
        break;
      } else {
        lineBreaks();
      }
    } while (lookaheadIs(TokenType.name));

    return res;
  }

  Session session() {
    consume(TokenType.session);
    Name sessionName = name();
    colon();
    lineBreaks();

    return Session(sessionName, prescriptions());
  }
}
