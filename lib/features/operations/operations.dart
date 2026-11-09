import '../../core/calendar_date.dart';
import '../../core/money/money.dart';

/// A money operation the person records (or the app records on their behalf,
/// e.g. a received salary). Amounts are always positive; the kind gives the
/// direction. Booked by `Journal` as a balanced entry.
sealed class Operation {
  const Operation({required this.amount, required this.date, this.description});
  final Money amount;

  /// Calendar date of the operation (not when it was entered).
  final CalendarDate date;
  final String? description;
}

/// Money in: [accountId] + / income category −.
final class IncomeOp extends Operation {
  const IncomeOp({
    required this.accountId,
    required this.categoryId,
    required super.amount,
    required super.date,
    super.description,
  });
  final String accountId;
  final String categoryId;
}

/// Money out (a debit card, cash, or a purchase on a credit card — then the
/// debt grows): expense category + / [accountId] −.
final class ExpenseOp extends Operation {
  const ExpenseOp({
    required this.accountId,
    required this.categoryId,
    required super.amount,
    required super.date,
    super.description,
  });
  final String accountId;
  final String categoryId;
}

/// Between own accounts, including repaying a credit card or a loan (then
/// [toAccountId] is the debt and it decreases). Never an expense.
final class TransferOp extends Operation {
  const TransferOp({
    required this.fromAccountId,
    required this.toAccountId,
    required super.amount,
    required super.date,
    super.description,
  });
  final String fromAccountId;
  final String toAccountId;
}

/// A purchase returned: [accountId] + / expense category − (reduces the
/// category's spending).
final class RefundOp extends Operation {
  const RefundOp({
    required this.accountId,
    required this.categoryId,
    required super.amount,
    required super.date,
    super.description,
  });
  final String accountId;
  final String categoryId;
}

/// Where an operation dated on the same day as a balance update stands
/// relative to it. Dates before an update are always «already in the
/// confirmed balance»; dates after any update never are.
enum SameDayPlacement {
  /// Let the app decide from the unexplained difference of that update.
  auto,

  /// The money is already in the balance confirmed that day.
  inConfirmedBalance,

  /// The money moved after that balance was confirmed.
  afterConfirmedBalance,
}

/// What recording an operation will do, shown BEFORE it is written.
final class OperationPreview {
  const OperationPreview({
    required this.balances,
    required this.inConfirmedBalance,
    required this.confirmedAt,
    required this.askIncluded,
    this.latestConfirmation,
    required this.placement,
    required this.unexplainedChange,
  });

  /// Affected own accounts: user-facing amount now → after.
  final Map<String, (Money before, Money after)> balances;

  /// The operation is already reflected in a balance the person confirmed:
  /// balances do not change, the unexplained difference shrinks.
  final bool inConfirmedBalance;

  /// When that balance was confirmed (null if [inConfirmedBalance] is false).
  final DateTime? confirmedAt;

  /// A balance of an affected account was confirmed on or after the
  /// operation's date: the person must say whether the money was already in
  /// it (a bank may post days later). The app never assumes.
  final bool askIncluded;

  /// The latest such confirmation (for the question).
  final DateTime? latestConfirmation;

  /// The resolved placement; pass it back to record exactly what was shown.
  final SameDayPlacement placement;

  /// Change of «Невыясненное» (positive = the unexplained gap shrinks for
  /// money that came in, see docs/r3-plan.md §4).
  final Money unexplainedChange;
}

/// A recorded entry as returned to callers.
final class RecordedOperation {
  const RecordedOperation(this.entryId, this.preview);
  final String entryId;
  final OperationPreview preview;
}

/// Thrown for an operation that cannot be booked (unknown or archived
/// account or category, wrong direction, amount ≤ 0, date in the future).
base class InvalidOperation implements Exception {
  const InvalidOperation(this.reason);
  final String reason;
  @override
  String toString() => 'InvalidOperation($reason)';
}
