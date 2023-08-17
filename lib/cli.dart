import 'dart:io';
import 'package:stpl/evaluator.dart';
import 'package:stpl/formatter.dart';

class CLIManager {
  final List<String> arguments;
  final File file;
  CLIManager(this.arguments, this.file);
  CLIManager.fromArgs(List<String> arguments)
      : this(arguments, File(arguments.isEmpty ? '' : arguments.first));

  String get response {
    if (arguments.length < 2) {
      return 'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    }

    if (!file.existsSync()) {
      return 'Error when reading "${arguments[0]}": no such file or directory.';
    }

    return switch (arguments[1]) {
      'next-session' => nextSession,
      _ => 'Could not find a command named "${arguments[1]}".',
    };
  }

  String get nextSession =>
      Formatter(Evaluator.from(file.readAsStringSync()).nextSession()).markdown;
}
