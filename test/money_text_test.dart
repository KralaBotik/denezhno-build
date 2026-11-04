import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/money/money_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const nb = ' ';
  test('formats rubles with grouping, kopecks only when present', () {
    expect(formatMoney(Money(0)), '0$nb₽');
    expect(formatMoney(Money(1234500)), '12${nb}345$nb₽');
    expect(formatMoney(Money(1234567)), '12${nb}345,67$nb₽');
    expect(formatMoney(Money(5)), '0,05$nb₽');
    expect(formatMoney(Money(-50000)), '−500$nb₽');
    expect(formatMoney(Money(100000000000)), '1${nb}000${nb}000${nb}000$nb₽');
    expect(
      formatMoney(Money.fromBigInt(Money.minMinorUnits)),
      startsWith('−92${nb}233${nb}720'),
    );
  });
  test('parses what people type, exactly', () {
    expect(parseMoneyInput(''), isNull);
    expect(parseMoneyInput('   '), isNull);
    expect(parseMoneyInput('12 345'), Money(1234500));
    expect(parseMoneyInput('12 345,5'), Money(1234550));
    expect(parseMoneyInput('1000.25'), Money(100025));
    expect(parseMoneyInput('0,1'), Money(10));
    expect(parseMoneyInput('300 ₽'), Money(30000));
    expect(parseMoneyInput('−300'), Money(-30000));
    expect(parseMoneyInput('-0,01'), Money(-1));
    expect(parseMoneyInput('15,'), Money(1500));
    expect(parseMoneyInput('92233720368547758,07'), Money(9223372036854775807));
  });
  test('rejects anything that is not an exact amount', () {
    for (final bad in [
      'abc',
      '1,234,5',
      '1.2.3',
      '12,345',
      '1e5',
      '--5',
      '5-',
    ]) {
      expect(() => parseMoneyInput(bad), throwsFormatException, reason: bad);
    }
    expect(() => parseMoneyInput('92233720368547758,08'), throwsRangeError);
  });
  test('input text round-trips', () {
    for (final v in [0, 1, 99, 1234567, -42, 100000000]) {
      expect(parseMoneyInput(moneyInputText(Money(v))), Money(v));
    }
  });
}
