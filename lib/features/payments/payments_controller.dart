import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
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
  Future<void> setFlowDone(String id, CalendarDate due, bool done) =>
      _then(_store.setFlowDone(id, due, done));
  Future<void> saveCardFigures(CardFigures f) =>
      _then(_store.saveCardFigures(f));
  Future<void> setCardSettled(String id, bool settled) =>
      _then(_store.setCardSettled(id, settled));
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
    );
