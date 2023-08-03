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
    return sentence.trainingSessions
        .any((session) => session.type.value == type.value);
  }

  TrainingSession lastSession() => sentence.trainingSessions.last;

  TrainingSession lastSessionOfType(Name type) {
    return sentence.trainingSessions
        .lastWhere((session) => session.type.value == type.value);
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

  TrainingSession nextSession() {
    final Name newType = nextSessionType();
    final TrainingSession pastSession = sessionOfTypeExists(newType)
        ? lastSessionOfType(newType)
        : lastSession();

    final List<Exercise> newExercises = [
      updateExercise(pastSession.exercises[0]),
    ];

    return TrainingSession(newType, newExercises);
  }
}
