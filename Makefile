test-ci:
	dart pub get
	dart format --output=none --set-exit-if-changed .
	dart analyze --fatal-infos
	dart test

report-coverage:
	dart run test --coverage=./coverage
	dart pub global activate coverage
	dart pub global run coverage:format_coverage --packages=.dart_tool/package_config.json --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage
	genhtml -o ./coverage/report ./coverage/lcov.info

coverage: report-coverage
	open ./coverage/report/index.html
