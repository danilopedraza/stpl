class Name {
  final String value;

  Name(this.value);

  @override
  bool operator ==(Object other) => other is Name && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class Amount {
  final num value;

  Amount(this.value);

  @override
  String toString() => value.toInt().toString();
}

enum Unit {
  kg('kg'),
  none('');

  final String str;
  const Unit(this.str);

  @override
  String toString() => str;
}

class Load {
  final Amount amount;
  final Unit unit;

  Load(this.amount, this.unit);

  @override
  String toString() => amount.toString() + unit.toString();
}

class UnknownLoad extends Load {
  UnknownLoad() : super(Amount(0), Unit.none);
}

class Workload {
  final Amount sets;
  final Amount reps;
  final Load load;

  Workload(this.sets, this.reps, this.load);

  List<String> toRow() => [sets.toString(), reps.toString(), load.toString()];
}

class Exercise {
  final Name name;
  final Workload workload;

  Exercise(this.name, this.workload);

  List<String> toRow() => [name.value] + workload.toRow();
}

class Session {
  final Name name;
  final List<Exercise> exercises;

  Session(this.name, this.exercises);
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

class TrainingSession {
  final Name type;
  final List<Exercise> exercises;

  TrainingSession(this.type, this.exercises);
}

class Progression {
  final List<Rule> rules;

  Progression(this.rules);
}

class Program {
  final List<Session> sessions;
  final Progression progression;

  Program(this.sessions, this.progression);
}

class Sentence {
  final Program program;
  final List<TrainingSession> trainingSessions;

  Sentence(this.program, this.trainingSessions);
}
