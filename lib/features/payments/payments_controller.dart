import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../operations/operations.dart' show ConfirmationAnswer;
import '../accounts/accounts_controller.dart';
import 'payments.dart';

/// Plans, marks and card figures for the UI. Reloads when storage opens and
/// when accounts change (a new credit card appears in «Кредитки»).
final paymentsProvider =
    AsyncNotifierProvider<PaymentsController, PaymentsSnapshot>(
      PaymentsController.new,
    );

const _empty = PaymentsSnapshot(
  flows: [],
  doneMarks: {},
  cardFigures: {},
  creditCards: {},
);

class PaymentsController extends AsyncNotifier<PaymentsSnapshot> {
  @override
  Future<PaymentsSnapshot> build() async {
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    ref.watch(accountsProvider);
    if (!ready) return _empty;
    return ref.read(paymentsStoreProvider).payments();
  }

  PaymentsStore get _store => ref.read(paymentsStoreProvider);

  Future<void> _then(Future<void> action) async {
    await action;
    if (ref.mounted) ref.invalidateSelf();
  }

  Future<void> saveFlow(PlannedFlow flow) => _then(_store.saveFlow(flow));
  Future<void> archiveFlow(String id) => _then(_store.archiveFlow(id));
  Future<void> setSkipped(String id, CalendarDate due, bool skipped) =>
      _then(_store.setFlowSkipped(id, due, skipped));
  Future<void> saveCardFigures(CardFigures f) =>
      _then(_store.saveCardFigures(f));

  Future<PaymentCheck> preview(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    Map<String, ConfirmationAnswer> answers = const {},
  }) => _store.previewPayment(
    target,
    amount: amount,
    accountId: accountId,
    date: date,
    answers: answers,
  );

  /// Books the payment; balances change, so accounts reload too.
  Future<void> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required Map<String, ConfirmationAnswer> answers,
    FiguresAnswer? figuresAnswer,
    bool confirmedNotDuplicate = false,
  }) async {
    await _store.pay(
      target,
      amount: amount,
      accountId: accountId,
      date: date,
      answers: answers,
      figuresAnswer: figuresAnswer,
      confirmedNotDuplicate: confirmedNotDuplicate,
    );
    if (ref.mounted) ref.invalidate(accountsProvider);
  }

  Future<void> cancel(String paymentId) async {
    await _store.cancelObligationPayment(paymentId);
    if (ref.mounted) ref.invalidate(accountsProvider);
  }

  Future<List<PendingSide>> pending() => _store.pendingSides();
}

/// «Ближайшие» for the next 30 days starting today.
List<UpcomingItem> upcomingFor(PaymentsSnapshot s, CalendarDate today) =>
    upcoming(
      flows: s.flows,
      doneMarks: s.doneMarks,
      cardFigures: s.cardFigures,
      cardNames: s.creditCards,
      from: today,
      to: today.addDays(30),
      trackedFrom: s.trackedFrom,
      paid: s.paid,
      skipped: s.skipped,
      legacyMarks: s.legacyMarks,
    );
