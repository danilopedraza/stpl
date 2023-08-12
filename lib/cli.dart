class CLIManager {
  final List<String> arguments;
  CLIManager(this.arguments);

  String get response =>
      'A command-line utility for STPL.\nUsage: stpl <file> <command>';
}
