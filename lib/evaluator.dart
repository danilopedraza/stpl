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

  TrainingSession lastTrainingSession() {
    return sentence.trainingSessions[0];
  }

  TrainingSession nextSession() {
    final TrainingSession lastSession = lastTrainingSession();
    final Name newType = nextSessionType();
    final List<Exercise> newExercises = [
      Exercise(
          lastSession.exercises[0].name,
          Workload(
            lastSession.exercises[0].workload.sets,
            lastSession.exercises[0].workload.reps,
            Load(
                Amount(lastSession.exercises[0].workload.load.amount.value + 1),
                lastSession.exercises[0].workload.load.unit),
          ))
    ];

    return TrainingSession(newType, newExercises);
  }
}
