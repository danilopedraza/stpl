test-ci:
	dart pub get
	dart format --output=none --set-exit-if-changed .
	dart analyze --fatal-infos
	dart test
