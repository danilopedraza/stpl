import 'package:stpl/lexer.dart';
import 'package:stpl/ast.dart';

class Parser {
  final Lexer lexer;
  Token lookahead;

  Parser(this.lexer) : lookahead = lexer.nextToken();
  Parser.from(String str) : this(Lexer(str));

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

  Amount amount() => Amount(double.parse(consume(TokenType.number).value));

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

  List<Exercise> exercises() {
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

    return Session(sessionName, exercises());
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

  TrainingSession trainingSession() {
    consume(TokenType.training);
    consume(TokenType.session);
    amount();
    consume(TokenType.lparen);
    final Name type = name();
    consume(TokenType.rparen);
    colon();
    lineBreaks();

    return TrainingSession(type, exercises());
  }

  List<TrainingSession> trainingSessions() {
    List<TrainingSession> res = [];

    do {
      res.add(trainingSession());
    } while (lookaheadIs(TokenType.training));

    return res;
  }

  List<Rule> rules() {
    List<Rule> res = [];

    do {
      res.add(rule());

      if (lookaheadIs(TokenType.eof)) {
        break;
      } else {
        lineBreaks();
      }
    } while (lookaheadIs(TokenType.name));

    return res;
  }

  Progression progression() {
    consume(TokenType.progression);
    consume(TokenType.colon);
    lineBreaks();
    return Progression(rules());
  }

  List<Session> sessions() {
    List<Session> res = [];

    do {
      res.add(session());
    } while (lookaheadIs(TokenType.session));

    return res;
  }

  Program program() {
    return Program(sessions(), progression());
  }

  Sentence sentence() {
    return Sentence(program(), trainingSessions());
  }
}
