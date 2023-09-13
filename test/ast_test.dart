import 'package:stpl/ast.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Amount.toString() should return precise decimal representations of non-whole numbers',
      () {
    expect(Amount(2.5).toString(), equals('2.5'));
  });

  test('a sum of amounts should return the correct result', () {
    expect((Amount(2.5) + Amount(2.5)).toString(), equals('5.0'));
  });
}
