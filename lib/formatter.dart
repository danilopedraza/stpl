import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  List<List<String>> get table {
    return session.exercises.map((exercise) => exercise.toRow()).toList();
  }

  Formatter(this.session);
}
