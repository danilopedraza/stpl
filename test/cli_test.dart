import 'package:stpl/cli.dart';
import 'package:test/test.dart';

void main() {
  test(
      'The CLI manager should give a help message when there are no CLI arguments',
      () {
    String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager([]).response, equals(expected));
  });

  test(
      'The CLI manager should give a specific help message when an unknown command is passed',
      () {
    String command = 'foo';
    String expected = 'Could not find a command named "$command"';
    expect(CLIManager(['program.stpl', command]).response, equals(expected));
  });

  test(
      'The CLI manager should give the generic help message when a file is passed but not a command',
      () {
    String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager(['program.stpl']).response, equals(expected));
  });
}
