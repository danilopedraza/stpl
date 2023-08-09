import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  Iterable<List<String>> get table {
    return session.exercises.map((exercise) => exercise.toRow());
  }

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv {
    String commaSeparated(List<String> row) => row.join(",");
    String linebreakSeparated(Iterable<String> lines) =>
        lines.reduce((value, element) => '$value\n$element');

    return linebreakSeparated([rowLabels, ...table].map(commaSeparated));
  }
}
