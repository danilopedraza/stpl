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
  none,
}

class Load {
  final Amount amount;
  final Unit unit;

  Load(this.amount, this.unit);
}

class UnknownLoad extends Load {
  UnknownLoad() : super(Amount(Token(TokenType.number, '0')), Unit.none);
}

class Workload {
  final Amount sets;
  final Amount reps;
  final Load load;

  Workload(this.sets, this.reps, this.load);
}

class Exercise {
  final Name name;
  final Workload workload;

  Exercise(this.name, this.workload);
}

class Session {
  final Name name;
  final List<Exercise> prescriptions;

  Session(this.name, this.prescriptions);
}

enum RuleType {
  up,
}

class Rule {
  final Name exerciseName;
  final RuleType type;
  final Load load;
  final Period period;

  Rule(this.exerciseName, this.type, this.load, this.period);
}

class Period {
  final int value;

  Period(this.value);
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

    if (lookaheadIs(TokenType.separator)) {
      separator();
      return Workload(sets, reps, load());
    }

    return Workload(sets, reps, UnknownLoad());
  }

  Exercise exercise() => Exercise(name(), workload());

  List<Exercise> prescriptions() {
    List<Exercise> res = [];

    do {
      res.add(exercise());

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

  Period period() {
    consume(TokenType.every);

    if (lookaheadIs(TokenType.time)) {
      consume(TokenType.time);
      return Period(1);
    } else {
      final int period = amount().value.toInt();
      consume(TokenType.times);
      return Period(period);
    }
  }

  RuleType ruleType() {
    consume(TokenType.up);
    return RuleType.up;
  }

  Rule rule() {
    final exerciseName = name();
    consume(TokenType.goes);

    return Rule(exerciseName, ruleType(), load(), period());
  }
}
