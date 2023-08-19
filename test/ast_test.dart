import 'package:stpl/ast.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Amount.toString() should return precise decimal representations of non-whole numbers',
      () {
    expect(Amount(2.5).toString(), equals('2.5'));
  });
}
