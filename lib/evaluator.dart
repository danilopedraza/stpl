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

  Session nextSessionScheme(Name name) {
    return sentence.program.sessions
        .firstWhere((session) => session.name == name);
  }

  bool ruleAvailable(Exercise scheme) {
    return sentence.program.progression.rules
        .any((rule) => rule.exerciseName == scheme.name);
  }

  Load prescribeLoad(Exercise scheme, TrainingSession pastSession) {
    final bool exerciseInSession = pastSession.exercises.any((exercise) => exercise.name == scheme.name);

    if (exerciseInSession && ruleAvailable(scheme)) {
      final Exercise pastWork = pastSession.exercises.firstWhere((exercise) => exercise.name == scheme.name);

      Rule rule = sentence.program.progression.rules
          .firstWhere((rule) => rule.exerciseName == scheme.name);

      return Load(
          Amount(pastWork.workload.load.amount.value +
              rule.load.amount.value),
          pastWork.workload.load.unit);
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

    final List<Exercise> newExercises =
        newSessionScheme.exercises.map(prescribe).toList();

    return TrainingSession(newType, newExercises);
  }
}
