import 'dart:convert';
import 'dart:io';
import 'package:mockito/annotations.dart';
import 'package:stpl/cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFile extends Mock implements File {
  @override
  final String path;
  final bool shouldExist;
  final String contents;

  MockFile(this.path, {this.shouldExist = true, this.contents = ''});

  @override
  bool existsSync() => shouldExist;

  @override
  String readAsStringSync({Encoding encoding = utf8}) => contents;
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
    final String expected = 'Could not find a command named "$command".';
    expect(CLIManager([filename, command], file).response, equals(expected));
  });

  test(
      'The CLI manager should give a specific help message when the file passed does not exist',
      () {
    final String filename = 'program.stpl';
    final String command = 'next-session';
    final file = MockFile(filename, shouldExist: false);
    final String expected =
        'Error when reading "$filename": no such file or directory.';
    expect(CLIManager([filename, command], file).response, equals(expected));
  });

  test(
      'The CLI manager should give the next session (in Markdown format) when called with "next-session"',
      () {
    final String program = '''Session A:
                              Squat 1x20
                              Progression:
                              Squat goes up 5kg every time
                              Training session 1 (A):
                              Squat 1x20x20kg
    ''';
    final String filename = 'program.stpl';
    final String command = 'next-session';

    final file = MockFile(filename, contents: program);
    final String expected = [
      '| Exercise | sets | reps | load |',
      '| -------- | ---- | ---- | ---- |',
      '| Squat    | 1    | 20   | 25kg |',
    ].join('\n');
    expect(CLIManager([filename, command], file).response, equals(expected));
  });
}
