class Controller {
  final List<String> arguments;
  Controller(this.arguments);

  String get response =>
      'A command-line utility for STPL.\nUsage: stpl <file> <command>';
}
