import 'dart:io';

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

    return 'Could not find a command named "${arguments[1]}"';
  }
}
