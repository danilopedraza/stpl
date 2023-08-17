import 'dart:io';
import 'package:mockito/annotations.dart';
import 'package:stpl/cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFile extends Mock implements File {
  @override
  final String path;

  MockFile(this.path);
}

@GenerateMocks([File])
void main() {
  test(
      'The CLI manager should give a help message when there are no CLI arguments',
      () {
    final String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager.fromArgs([]).response, equals(expected));
  });

  test(
      'The CLI manager should give the generic help message when a file is passed but not a command',
      () {
    final String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(CLIManager.fromArgs(['program.stpl']).response, equals(expected));
  });

  test(
      'The CLI manager should give a specific help message when an unknown command is passed',
      () {
    final String filename = 'program.stpl';
    final String command = 'foo';
    final file = MockFile(filename);
    final String expected = 'Could not find a command named "$command"';
    expect(CLIManager([filename, command], file).response, equals(expected));
  });
}
