import 'money.dart';

const _nbsp = ' ';
const _minus = '−';

/// «12 345 ₽», «12 345,67 ₽», «−500 ₽». Exact: works on minor units, never
/// on double. Kopecks are shown only when non-zero.
String formatMoney(Money money, {bool withSymbol = true}) {
  final scale = money.currency.fractionDigits;
  final negative = money.minorUnits < 0;
  final digits = BigInt.from(money.minorUnits)
      .abs()
      .toString()
      .padLeft(scale + 1, '0');
  final whole = digits.substring(0, digits.length - scale);
  final fraction = digits.substring(digits.length - scale);
  final grouped = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(_nbsp);
    grouped.write(whole[i]);
  }
  final showFraction = scale > 0 && fraction.replaceAll('0', '').isNotEmpty;
  final text =
      '${negative ? _minus : ''}$grouped${showFraction ? ',$fraction' : ''}';
  if (!withSymbol) return text;
  final symbol = money.currency.code == 'RUB' ? '₽' : money.currency.code;
  return '$text$_nbsp$symbol';
}

/// Text for an input field: «12345,67» (no grouping, no symbol).
String moneyInputText(Money money) =>
    formatMoney(money, withSymbol: false).replaceAll(_nbsp, '');

/// Parses what a person types: «12 345», «12345,5», «1 000.25», «−300 ₽».
/// Returns null for empty input; throws [FormatException] for anything that
/// is not an exact amount (letters, more decimals than the currency allows,
/// several separators) and [RangeError] above int64.
Money? parseMoneyInput(String input, {Currency currency = Currency.rub}) {
  var text = input
      .replaceAll(RegExp(r'[\s   ]'), '')
      .replaceAll(RegExp(r'(₽|руб\.?|р\.?)$', caseSensitive: false), '')
      .replaceAll(_minus, '-');
  if (text.isEmpty) return null;
  final match = RegExp(r'^([+-]?)(\d+)(?:[.,](\d*))?$').firstMatch(text);
  if (match == null) throw const FormatException('Not an amount');
  final sign = match[1] == '-' ? -1 : 1;
  final fraction = match[3] ?? '';
  if (fraction.length > currency.fractionDigits) {
    throw const FormatException('Too many decimals');
  }
  final minor =
      BigInt.parse(match[2]!) * BigInt.from(10).pow(currency.fractionDigits) +
      (fraction.isEmpty
          ? BigInt.zero
          : BigInt.parse(fraction.padRight(currency.fractionDigits, '0')));
  return Money.fromBigInt(minor * BigInt.from(sign), currency: currency);
}
