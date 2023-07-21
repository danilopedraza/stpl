import 'package:stpl/lexer.dart';

enum NodeType {
  name,
}

class Name {
  final String value;

  Name(this.value);
}

class Number {
  final num value;

  Number(this.value);
}

enum Unit {
  kg,
}

class Load {
  final Number amount;
  final Unit unit;

  Load(this.amount, this.unit);
}

class Parser {
  final Lexer lexer;

  Parser(this.lexer);

  name() {
    return Name(lexer.nextToken().value);
  }

  amount() {
    return Number(double.parse(lexer.nextToken().value));
  }

  unit() {
    return Unit.kg;
  }

  load() {
    return Load(amount(), unit());
  }
}
