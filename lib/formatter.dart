import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  Iterable<List<String>> get table =>
      session.exercises.map((exercise) => exercise.toRow());

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv =>
      [rowLabels, ...table].map((row) => row.join(",")).join("\n");

  List<int> get columnLengths => [8, 4, 4, 4];

  String markdownRow(List<String> row) {
    String res = '|';

    for (int i = 0; i < 4; i++) {
      var filler = columnLengths[i] - row[i].length;

      res += ' ${row[i]}${' ' * filler} |';
    }

    return res;
  }

  String get markdown {
    List<String> rows = [
      '| Exercise | sets | reps | load |',
      '| -------- | ---- | ---- | ---- |',
    ];

    return rows.followedBy(table.map(markdownRow)).join('\n');
  }
}
