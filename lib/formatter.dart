import 'dart:math';

import 'package:stpl/parser.dart';

class Formatter {
  final TrainingSession session;

  List<List<String>> get table {
    return session.exercises.map((exercise) => exercise.toRow()).toList();
  }

  Formatter(this.session);

  String get csv {
    String commaSeparated(List<String> row) => row.reduce((value, element) => '$value,$element');

    String res = 'Exercise,sets,reps,load\n';
    // table.forEach((row) => res += '${commaSeparated(row)}\n');

    return res + table.map(commaSeparated).reduce((value, element) => value + '\n' + element);
  }
}
