import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/money/money.dart';
import '../payments/payments.dart' show PendingKey;
import 'accounts.dart';

/// Accounts for the UI. Loads only while the encrypted storage is open;
/// every write goes through the single serialized store and then reloads.
final accountsProvider =
    AsyncNotifierProvider<AccountsController, List<AccountSummary>>(
      AccountsController.new,
    );

class AccountsController extends AsyncNotifier<List<AccountSummary>> {
  @override
  Future<List<AccountSummary>> build() async {
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    if (!ready) return const [];
    return ref.read(accountsStoreProvider).accounts();
  }

  Future<void> create(NewAccount account) async {
    await ref.read(accountsStoreProvider).createAccount(account);
    _reload();
  }

  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> amounts, {
    Map<PendingKey, bool> pending = const {},
  }) async {
    final result = await ref
        .read(accountsStoreProvider)
        .updateBalances(amounts, pending: pending);
    _reload();
    return result;
  }

  Future<void> setIncluded(String id, bool included) async {
    await ref.read(accountsStoreProvider).setIncludedInForecast(id, included);
    _reload();
  }

  Future<void> updateDetails(String id, String name, Money? limit) async {
    await ref
        .read(accountsStoreProvider)
        .updateAccountDetails(id, name: name, creditLimit: limit);
    _reload();
  }

  void _reload() {
    if (ref.mounted) ref.invalidateSelf();
  }
}

/// Sums for the header. Savings marked «не трогать» are kept apart from
/// spendable money; debts are summed as positive amounts.
final class AccountTotals {
  AccountTotals(List<AccountSummary> accounts)
    : ownMoney = _sum(
        accounts.where((a) => !a.kind.isLiability && !a.isProtected),
      ),
      savings = _sum(
        accounts.where((a) => !a.kind.isLiability && a.isProtected),
      ),
      debts = _sum(accounts.where((a) => a.kind.isLiability));
  final Money ownMoney;
  final Money savings;
  final Money debts;

  static Money _sum(Iterable<AccountSummary> list) =>
      list.fold(Money(0), (sum, a) => sum + a.amount);
}
