import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../accounts/accounts_controller.dart';
import '../operations/operations.dart';
import 'income.dart';

/// Income sources and payments for the UI. Reloads when storage opens and
/// when accounts change (a receipt changes balances and vice versa).
final incomeProvider = AsyncNotifierProvider<IncomeController, IncomeSnapshot>(
  IncomeController.new,
);

const _empty = IncomeSnapshot(sources: [], payments: []);

class IncomeController extends AsyncNotifier<IncomeSnapshot> {
  @override
  Future<IncomeSnapshot> build() async {
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    if (!ready) return _empty;
    return ref.read(incomeStoreProvider).income();
  }

  IncomeStore get _store => ref.read(incomeStoreProvider);

  Future<T> _then<T>(Future<T> action, {bool balances = false}) async {
    final result = await action;
    if (ref.mounted) {
      ref.invalidateSelf();
      if (balances) ref.invalidate(accountsProvider);
    }
    return result;
  }

  Future<String> create({
    required String name,
    required IncomeKind kind,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  }) => _then(
    _store.createIncomeSource(
      name: name,
      kind: kind,
      holidayRule: holidayRule,
      parts: parts,
      accountId: accountId,
    ),
  );

  Future<void> updateSchedule(
    String id, {
    required String name,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  }) => _then(
    _store.updateIncomeSchedule(
      id,
      name: name,
      holidayRule: holidayRule,
      parts: parts,
      accountId: accountId,
    ),
  );

  Future<void> archive(String id) => _then(_store.archiveIncomeSource(id));
  Future<void> move(PaymentKey key, CalendarDate to) =>
      _then(_store.movePayment(key, to));
  Future<void> dateUnknown(PaymentKey key) =>
      _then(_store.markPaymentDateUnknown(key));
  Future<void> setAmount(PaymentKey key, Money amount) =>
      _then(_store.setPaymentAmount(key, amount));
  Future<void> cancel(PaymentKey key) => _then(_store.cancelPayment(key));
  Future<void> reopen(PaymentKey key) => _then(_store.reopenPayment(key));

  Future<OperationPreview> preview(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    Map<String, ConfirmationAnswer> answers = const {},
  }) => _store.previewReceipt(
    key,
    amount: amount,
    accountId: accountId,
    date: date,
    answers: answers,
  );

  Future<void> receive(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required Map<String, ConfirmationAnswer> answers,
    ShortfallChoice shortfall = ShortfallChoice.restLater,
    CalendarDate? restOn,
  }) => _then(
    _store.receivePayment(
      key,
      amount: amount,
      accountId: accountId,
      date: date,
      answers: answers,
      shortfall: shortfall,
      restOn: restOn,
    ),
    balances: true,
  );

  Future<void> cancelReceipt(String receiptId) =>
      _then(_store.cancelReceipt(receiptId), balances: true);
}
