import 'package:denezhno/core/money/command_id.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kopecks, additions and reversals remain exact', () {
    final amount = Money(125075);
    expect(amount.toDecimalString(), '1250.75');
    expect(amount + Money(25), Money(125100));
    expect(amount + -amount, Money(0));
    expect(amount - Money(75), Money(125000));
    expect(Money(-1).toDecimalString(), '-0.01');
  });
  test('int64 endpoints and wire strings above 2^53', () {
    expect(
      Money.fromBigInt(Money.maxMinorUnits).minorUnitsString,
      '9223372036854775807',
    );
    expect(
      Money.fromBigInt(Money.minMinorUnits).toDecimalString(),
      '-92233720368547758.08',
    );
    expect(Money(9007199254740993).minorUnitsString, '9007199254740993');
  });
  test('overflow is rejected before narrowing to int64', () {
    final max = Money.fromBigInt(Money.maxMinorUnits);
    final min = Money.fromBigInt(Money.minMinorUnits);
    expect(() => max + Money(1), throwsRangeError);
    expect(() => min - Money(1), throwsRangeError);
    expect(() => -min, throwsRangeError);
    expect(() => max.multiply(2), throwsRangeError);
    expect(
      () => Money.fromBigInt(Money.maxMinorUnits + BigInt.one),
      throwsRangeError,
    );
    expect(
      () => Money.fromBigInt(Money.minMinorUnits - BigInt.one),
      throwsRangeError,
    );
    expect(min.multiply(0), Money(0));
  });
  test('different currencies cannot be added or subtracted', () {
    final usd = Money(100, currency: Currency('USD', 2));
    expect(() => Money(100) + usd, throwsArgumentError);
    expect(() => Money(100) - usd, throwsArgumentError);
    expect(Money(100), isNot(usd));
  });
  test('currency metadata and money equality', () {
    expect(Currency('RUB', 2), Currency.rub);
    expect(() => Currency('rub', 2), throwsArgumentError);
    expect(() => Currency('RUB', -1), throwsArgumentError);
    expect({Money(1), Money(1)}.length, 1);
    expect(Money(123456).toString(), isNot(contains('123456')));
  });
  test(
    'command identity survives reconstruction and rejects non UUID values',
    () {
      const id = '45c4ea50-6a4f-4a80-8c31-1d0a46d0caf1';
      expect(CommandId(id), CommandId(id));
      expect(CommandId(id).value, id);
      expect(() => CommandId('1000-2026-11-02'), throwsArgumentError);
      expect(() => CommandId(id.toUpperCase()), throwsArgumentError);
    },
  );
}
