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

  Session nextSessionScheme(Name name) {
    return sentence.program.sessions.firstWhere((session) => session.name.value == name.value);
  }

  Workload prescribeWorkload(Exercise scheme) {
    final Name newType = nextSessionType();

    final TrainingSession pastSession = sessionOfTypeExists(newType)
        ? lastSessionOfType(newType)
        : lastSession();
    
    return Workload(
          scheme.workload.sets,
          scheme.workload.reps,
          Load(Amount(pastSession.exercises[0].workload.load.amount.value + 1),
              scheme.workload.load.unit),
        );
  }

  Exercise prescribe(Exercise scheme) {
    return Exercise(
      scheme.name,
      prescribeWorkload(scheme));
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
