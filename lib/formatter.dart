import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  List<List<String>> get table {
    return session.exercises.map((exercise) => exercise.toRow()).toList();
  }

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv {
    String commaSeparated(List<String> row) =>
        row.reduce((value, element) => '$value,$element');
    String linebreakSeparated(Iterable<String> lines) =>
        lines.reduce((value, element) => '$value\n$element');

    return linebreakSeparated(([rowLabels] + table).map(commaSeparated));
  }
}
