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

  List<int> get columnLengths {
    int maxColLength(List<String> column) =>
        column.map((cell) => cell.length).reduce(max);

    return IterableZip([rowLabels].followedBy(table))
        .map(maxColLength)
        .toList();
  }

  String markdownRow(List<String> row) {
    String padRight(str, maxLength) {
      final int padding = maxLength - str.length;

      return '$str${' ' * padding}';
    }

    final Iterable<String> columns =
        IterableZip([columnLengths, row]).map((List<dynamic> pair) {
      final [maxLength, cell] = pair;

      return padRight(cell, maxLength);
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
