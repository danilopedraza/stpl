import 'dart:math';

import 'package:stpl/ast.dart';

class Formatter {
  final TrainingSession session;

  Iterable<List<String>> get table =>
      session.exercises.map((exercise) => exercise.toRow());

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv =>
      [rowLabels, ...table].map((row) => row.join(",")).join("\n");

  List<int> get columnLengths => [
        for (int i = 0; i < rowLabels.length; i++)
          [rowLabels].followedBy(table).map((e) => e[i].length).reduce(max)
      ];

  String markdownRow(List<String> row) {
    String res = '|';

    for (int i = 0; i < rowLabels.length; i++) {
      var filler = columnLengths[i] - row[i].length;

      res += ' ${row[i]}${' ' * filler} |';
    }

    return res;
  }

  String get markdown {
    List<List<String>> rows = [
      rowLabels,
      columnLengths.map((len) => '-' * len).toList(),
    ];

    return rows.followedBy(table).map(markdownRow).join('\n');
  }
}
