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

  Token consumeAny(List<TokenType> expectedTypes) {
    if (expectedTypes.contains(lookahead.type)) {
      return consume(lookahead.type);
    }

    throw FormatException('expected \'kg\' or \'percentage\', got \'name\'');
  }

  name() {
    List<String> names = [];

    do {
      names.add(consume(TokenType.name).value);
    } while (lookaheadIs(TokenType.name));

    return Name(names);
  }

  amount() {
    final String str = consume(TokenType.number).value;
    final num value = int.tryParse(str) ?? double.parse(str);

    return Amount(value);
  }

  unit() {
    final TokenType type =
        consumeAny([TokenType.kg, TokenType.percentage]).type;
    if (type == TokenType.kg) {
      return Unit.kg;
    }

    return Unit.percentage;
  }

  load() => Load(amount(), unit());

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

  workload() {
    final Amount sets = amount();
    separator();
    final Amount reps = amount();

    if (lookaheadIs(TokenType.separator)) {
      separator();
      return Workload(sets, reps, load());
    }

    return Workload(sets, reps, UnknownLoad());
  }

  exercise() => Exercise(name(), workload());

  exercises() {
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

  session() {
    consume(TokenType.session);
    Name sessionName = name();
    colon();
    lineBreaks();

    return Session(sessionName, exercises());
  }

  period() {
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

  ruleType() {
    consume(TokenType.up);
    return RuleType.up;
  }

  rule() {
    final exerciseName = name();
    consume(TokenType.goes);

    return Rule(exerciseName, ruleType(), load(), period());
  }

  trainingSession() {
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

  trainingSessions() {
    List<TrainingSession> res = [];

    do {
      res.add(trainingSession());
    } while (lookaheadIs(TokenType.training));

    return res;
  }

  rules() {
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

  progression() {
    consume(TokenType.progression);
    consume(TokenType.colon);
    lineBreaks();
    return Progression(rules());
  }

  sessions() {
    List<Session> res = [];

    do {
      res.add(session());
    } while (lookaheadIs(TokenType.session));

    return res;
  }

  program() => Program(sessions(), progression());

  sentence() => Sentence(program(), trainingSessions());
}
