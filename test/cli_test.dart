import 'package:stpl/cli.dart';
import 'package:test/test.dart';

void main() {
  test(
      'The controller should give a help message when there are no CLI arguments',
      () {
    String expected =
        'A command-line utility for STPL.\nUsage: stpl <file> <command>';
    expect(Controller([]).response, equals(expected));
  });
}
