/// Currency metadata, independent of UI. Only RUB is exposed by the MVP.
final class Currency {
  factory Currency(String code, int fractionDigits) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(code) ||
        fractionDigits < 0 ||
        fractionDigits > 4) {
      throw ArgumentError('Invalid currency metadata');
    }
    return Currency._(code, fractionDigits);
  }
  const Currency._(this.code, this.fractionDigits);
  static const rub = Currency._('RUB', 2);
  final String code;
  final int fractionDigits;
  @override
  bool operator ==(Object other) =>
      other is Currency &&
      code == other.code &&
      fractionDigits == other.fractionDigits;
  @override
  int get hashCode => Object.hash(code, fractionDigits);
}

/// Exact signed int64 amount. Intermediate arithmetic never wraps at int64.
final class Money {
  factory Money(int minorUnits, {Currency currency = Currency.rub}) =>
      Money.fromBigInt(BigInt.from(minorUnits), currency: currency);
  factory Money.fromBigInt(BigInt value, {Currency currency = Currency.rub}) {
    if (value < minMinorUnits || value > maxMinorUnits) {
      throw RangeError('Money is outside signed int64');
    }
    return Money._(value.toInt(), currency);
  }
  const Money._(this.minorUnits, this.currency);
  static final minMinorUnits = -(BigInt.one << 63);
  static final maxMinorUnits = (BigInt.one << 63) - BigInt.one;
  final int minorUnits;
  final Currency currency;
  Money operator +(Money other) {
    _requireSameCurrency(other);
    return Money.fromBigInt(
      BigInt.from(minorUnits) + BigInt.from(other.minorUnits),
      currency: currency,
    );
  }

  Money operator -(Money other) {
    _requireSameCurrency(other);
    return Money.fromBigInt(
      BigInt.from(minorUnits) - BigInt.from(other.minorUnits),
      currency: currency,
    );
  }

  Money operator -() =>
      Money.fromBigInt(-BigInt.from(minorUnits), currency: currency);
  Money multiply(int factor) => Money.fromBigInt(
    BigInt.from(minorUnits) * BigInt.from(factor),
    currency: currency,
  );

  /// Canonical wire/storage representation, including values above 2^53.
  String get minorUnitsString => minorUnits.toString();
  String toDecimalString() {
    final sign = minorUnits < 0 ? '-' : '';
    final digits = BigInt.from(minorUnits).abs().toString();
    final scale = currency.fractionDigits;
    if (scale == 0) return '$sign$digits';
    final padded = digits.padLeft(scale + 1, '0');
    final split = padded.length - scale;
    return '$sign${padded.substring(0, split)}.${padded.substring(split)}';
  }

  void _requireSameCurrency(Money other) {
    if (currency != other.currency) throw ArgumentError('Currency mismatch');
  }

  @override
  bool operator ==(Object other) =>
      other is Money &&
      minorUnits == other.minorUnits &&
      currency == other.currency;
  @override
  int get hashCode => Object.hash(minorUnits, currency);
  // Do not include financial values in incidental diagnostic output.
  @override
  String toString() => 'Money(${currency.code})';
}
