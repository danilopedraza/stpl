import 'dart:math';

import 'package:stpl/ast.dart';

import 'package:collection/collection.dart';

class Formatter {
  final TrainingSession session;

  Iterable<List<String>> get table =>
      session.exercises.map((exercise) => exercise.toRow());

  Formatter(this.session);

  List<String> get rowLabels => ['Exercise', 'sets', 'reps', 'load'];

  String get csv =>
      [rowLabels].followedBy(table).map((row) => row.join(",")).join("\n");

  List<int> get columnLengths => [
        for (int i = 0; i < rowLabels.length; i++)
          [rowLabels].followedBy(table).map((e) => e[i].length).reduce(max)
      ];

  String markdownRow(List<String> row) {
    final Iterable<String> columns =
        IterableZip([columnLengths, row]).map((List<dynamic> pair) {
      final [maxLength, column] = pair;
      final int padding = maxLength - column.length;
      
      return '$column${' ' * padding}';
    });

    return '| ${columns.join(' | ')} |';
  }

  String get markdown {
    List<List<String>> rows = [
      rowLabels,
      columnLengths.map((len) => '-' * len).toList(),
    ];

    return rows.followedBy(table).map(markdownRow).join('\n');
  }
}
