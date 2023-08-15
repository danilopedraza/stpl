import 'dart:io';
import 'package:stpl/cli.dart';
import 'package:test/test.dart';

void main() {
  test(
      'The CLI manager should give a help message when there are no CLI arguments',
      () {
    final String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager.fromArgs([]).response, equals(expected));
  });

  test(
      'The CLI manager should give a specific help message when an unknown command is passed',
      () {
    final String command = 'foo';
    final String expected = 'Could not find a command named "$command"';
    expect(CLIManager(['program.stpl', command], File('program.stpl')).response,
        equals(expected));
  });

  test(
      'The CLI manager should give the generic help message when a file is passed but not a command',
      () {
    final String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager.fromArgs(['program.stpl']).response, equals(expected));
  });
}
