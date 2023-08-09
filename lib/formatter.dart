import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  Iterable<List<String>> get table {
    return session.exercises.map((exercise) => exercise.toRow());
  }

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv =>
      [rowLabels, ...table].map((row) => row.join(",")).join("\n");
}
