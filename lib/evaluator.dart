import 'package:stpl/parser.dart';

class Evaluator {
  final Parser parser;

  Evaluator(this.parser);

  TrainingSession nextSession() {
    final Sentence sentence = parser.sentence();
    final TrainingSession lastSession = sentence.trainingSessions[0];
    final int index =
        (sentence.trainingSessions.length) % sentence.program.sessions.length;
    final Name newType = sentence.program.sessions[index].name;
    return TrainingSession(newType, lastSession.exercises);
  }
}
