class CLIManager {
  final List<String> arguments;
  CLIManager(this.arguments);

  String get response {
    if (arguments.length < 2) {
      return 'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    }

    return 'Could not find a command named "${arguments[1]}"';
  }
}
