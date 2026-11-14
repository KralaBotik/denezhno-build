import '../../core/money/money.dart';
import '../payments/payments.dart' show PendingKey;

/// Kinds a person can create. System accounts (opening equity, «Невыясненное»)
/// are never shown or created here.
enum AccountKind {
  debit('debit'),
  cash('cash'),
  savings('savings'),
  deposit('deposit'),
  creditCard('credit_card'),
  loan('loan');

  const AccountKind(this.dbValue);
  final String dbValue;

  static AccountKind? fromDb(String value) {
    for (final kind in values) {
      if (kind.dbValue == value) return kind;
    }
    return null;
  }

  /// Debts are stored as negative balances and shown as positive «долг».
  bool get isLiability => this == creditCard || this == loan;

  /// Savings are protected from «можно потратить» by default.
  bool get protectedByDefault => this == savings || this == deposit;
}

/// One account as the UI sees it. [amount] is user-facing: money for assets,
/// the debt (positive) for credit cards and loans.
final class AccountSummary {
  const AccountSummary({
    required this.id,
    required this.name,
    required this.kind,
    required this.amount,
    required this.isProtected,
    this.creditLimit,
    this.lastUpdatedAt,
  });
  final String id;
  final String name;
  final AccountKind kind;
  final Money amount;
  final bool isProtected;
  final Money? creditLimit;
  final DateTime? lastUpdatedAt;
}

final class NewAccount {
  const NewAccount({
    required this.kind,
    required this.name,
    required this.amount,
    this.isProtected = false,
    this.creditLimit,
  });
  final AccountKind kind;
  final String name;

  /// User-facing: current money, or the current debt for liabilities.
  final Money amount;
  final bool isProtected;
  final Money? creditLimit;
}

/// Result of «Обновить остатки». [unexplained] is the net change of own money
/// minus debts that nobody recorded: negative = неучтённые расходы,
/// positive = неучтённые поступления. Transfers between own accounts made in
/// the same update cancel out and do not appear here.
final class BalanceUpdateResult {
  const BalanceUpdateResult({required this.changed, required this.unexplained});
  final int changed;
  final Money unexplained;
}

abstract interface class AccountsStore {
  Future<List<AccountSummary>> accounts();
  Future<void> createAccount(NewAccount account);

  /// [amounts]: account id → user-facing amount now (the same value means
  /// «не изменилось» and is recorded as a confirmation).
  ///
  /// [pending]: for every not yet confirmed side of a recorded payment on
  /// an account in [amounts], the person's answer — the bank already shows
  /// it (true) or not yet (false). Required, no default; a side on an
  /// account not confirmed now keeps its state (R3 review 3).
  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> amounts, {
    Map<PendingKey, bool> pending = const {},
  });

  /// Whether a money account counts in «можно потратить» (the opposite of
  /// «не трогать»). Only for non-debt accounts.
  Future<void> setIncludedInForecast(String accountId, bool included);

  /// Renames an account and/or changes a credit card's limit. Metadata only:
  /// balances and history are not touched.
  Future<void> updateAccountDetails(
    String accountId, {
    required String name,
    Money? creditLimit,
  });
}

/// Household-wide settings that affect the forecast.
abstract interface class HouseholdStore {
  /// «Неприкосновенный» reserve kept out of «можно потратить».
  Future<Money> reserve();
  Future<void> setReserve(Money reserve);
}
