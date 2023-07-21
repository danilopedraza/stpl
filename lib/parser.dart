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

  Parser(this.lexer);

  Name name() {
    return Name(lexer.nextToken().value);
  }

  Amount amount() {
    return Amount(double.parse(lexer.nextToken().value));
  }

  Unit unit() {
    return Unit.kg;
  }

  Load load() {
    return Load(amount(), unit());
  }

  Prescription prescription() {
    final Amount sets = amount();
    lexer.nextToken();
    final Amount reps = amount();
    return Prescription(sets, reps);
  }
}
