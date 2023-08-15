import 'package:stpl/cli.dart';

void main(List<String> arguments) {
  print(CLIManager.fromArgs(arguments).response);
}
