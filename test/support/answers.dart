import 'package:denezhno/core/database/obligation_repo.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/operations/operations.dart';

/// The same answer to every confirmation question of [preview] (each about
/// its current confirmation) — for tests that are not about the question.
Map<String, ConfirmationAnswer> answerAll(
  OperationPreview preview, {
  required bool included,
}) => {
  for (final q in preview.questions)
    q.accountId: ConfirmationAnswer(q.assertionId, included: included),
};

extension Reconcile on ObligationRepo {
  /// «Обновить остатки» answering every pending side on [amounts]' accounts:
  /// sides of the payments in [notYet] have not reached the bank yet, all
  /// others have (the store itself has no default).
  Future<BalanceUpdateResult> reconcile(
    Map<String, Money> amounts,
    Set<String> notYet,
    DateTime now,
  ) async => updateBalances(amounts, {
    for (final s in await pending())
      if (amounts.containsKey(s.accountId))
        s.key: !notYet.contains(s.paymentId),
  }, now);
}
