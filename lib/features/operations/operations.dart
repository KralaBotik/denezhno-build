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

/// «Was the money already in this confirmed balance?» — asked separately
/// for every affected account that has a balance confirmed on or after the
/// operation's date (a bank may post days later; the two sides of a
/// transfer may be posted at different times).
final class ConfirmationQuestion {
  const ConfirmationQuestion({
    required this.accountId,
    required this.assertionId,
    required this.confirmedAt,
    required this.delta,
  });
  final String accountId;

  /// The confirmation the answer is about. If a newer one appears, the
  /// answer no longer applies and the question is asked again.
  final String assertionId;
  final DateTime confirmedAt;

  /// The operation's effect on this account (stored sign: assets +,
  /// liabilities −; positive = money in / debt down).
  final int delta;
}

/// The person's answer to a [ConfirmationQuestion].
final class ConfirmationAnswer {
  const ConfirmationAnswer(this.assertionId, {required this.included});
  final String assertionId;

  /// The money was already in that confirmed balance.
  final bool included;
}

/// What recording an operation will do, shown BEFORE it is written.
final class OperationPreview {
  const OperationPreview({
    required this.balances,
    required this.inConfirmedBalance,
    required this.confirmedAt,
    required this.placement,
    required this.unexplainedChange,
    this.questions = const [],
  });

  /// Affected own accounts: user-facing amount now → after.
  final Map<String, (Money before, Money after)> balances;

  /// Every affected account was answered «already in the confirmed
  /// balance»: balances do not change, the unexplained difference shrinks.
  final bool inConfirmedBalance;

  /// When that balance was confirmed (single account, [inConfirmedBalance]).
  final DateTime? confirmedAt;

  /// One question per affected account with a confirmation on or after the
  /// operation's date. The screens ask each; the stores refuse to write
  /// while any is unanswered or answered about an older confirmation.
  final List<ConfirmationQuestion> questions;

  /// Uniform summary of the answers (all «in» → in, otherwise after).
  final SameDayPlacement placement;

  /// Change of «Невыясненное» (positive = the unexplained gap shrinks for
  /// money that came in, see docs/r3-plan.md §4).
  final Money unexplainedChange;

  bool get askIncluded => questions.isNotEmpty;

  DateTime? get latestConfirmation => questions.isEmpty
      ? null
      : questions
            .map((q) => q.confirmedAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

  /// Questions without an answer about the same confirmation.
  List<ConfirmationQuestion> unanswered(
    Map<String, ConfirmationAnswer> answers,
  ) => [
    for (final q in questions)
      if (answers[q.accountId]?.assertionId != q.assertionId) q,
  ];
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
