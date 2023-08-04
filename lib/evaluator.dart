import 'package:stpl/parser.dart';

class Evaluator {
  final Parser parser;
  final Sentence sentence;

  Evaluator(this.parser) : sentence = parser.sentence();

  Name nextSessionType() {
    final int index =
        (sentence.trainingSessions.length) % sentence.program.sessions.length;
    return sentence.program.sessions[index].name;
  }

  bool sessionOfTypeExists(Name type) {
    return sentence.trainingSessions.any((session) => session.type == type);
  }

  TrainingSession lastSession() => sentence.trainingSessions.last;

  TrainingSession lastSessionOfType(Name type) {
    return sentence.trainingSessions
        .lastWhere((session) => session.type == type);
  }

  Exercise updateExercise(Exercise exercise) {
    return Exercise(
        exercise.name,
        Workload(
          exercise.workload.sets,
          exercise.workload.reps,
          Load(Amount(exercise.workload.load.amount.value + 1),
              exercise.workload.load.unit),
        ));
  }

  Session nextSessionScheme(Name name) {
    return sentence.program.sessions
        .firstWhere((session) => session.name == name);
  }

  bool ruleAvailable(Exercise scheme) {
    return sentence.program.progression.rules
        .any((rule) => rule.exerciseName == scheme.name);
  }

  Load prescribeLoad(Exercise scheme, TrainingSession pastSession) {
    if (pastSession.exercises[0].name == scheme.name && ruleAvailable(scheme)) {
      Rule rule = sentence.program.progression.rules
          .firstWhere((rule) => rule.exerciseName == scheme.name);

      return Load(
          Amount(pastSession.exercises[0].workload.load.amount.value +
              rule.load.amount.value),
          scheme.workload.load.unit);
    } else {
      return UnknownLoad();
    }
  }

  Workload prescribeWorkload(Exercise scheme) {
    final Name newType = nextSessionType();

    final TrainingSession pastSession = sessionOfTypeExists(newType)
        ? lastSessionOfType(newType)
        : lastSession();

    return Workload(
      scheme.workload.sets,
      scheme.workload.reps,
      prescribeLoad(scheme, pastSession),
    );
  }

  Exercise prescribe(Exercise scheme) {
    return Exercise(scheme.name, prescribeWorkload(scheme));
  }

  TrainingSession nextSession() {
    final Name newType = nextSessionType();
    final Session newSessionScheme = nextSessionScheme(newType);

    final List<Exercise> newExercises = [
      prescribe(newSessionScheme.exercises[0]),
    ];

    return TrainingSession(newType, newExercises);
  }
}
