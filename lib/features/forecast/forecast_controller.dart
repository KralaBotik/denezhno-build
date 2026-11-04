import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../accounts/accounts_controller.dart';
import '../payments/payments_controller.dart';
import 'safe_to_spend.dart';

/// The reserve (household setting), loaded while storage is open.
final reserveProvider = AsyncNotifierProvider<ReserveController, Money>(
  ReserveController.new,
);

class ReserveController extends AsyncNotifier<Money> {
  @override
  Future<Money> build() async {
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    if (!ready) return Money(0);
    return ref.read(householdStoreProvider).reserve();
  }

  Future<void> set(Money reserve) async {
    await ref.read(householdStoreProvider).setReserve(reserve);
    if (ref.mounted) ref.invalidateSelf();
  }
}

/// «Можно потратить» for today, recomputed whenever accounts, plans, card
/// figures or the reserve change. Pure calculation in [computeSafeToSpend].
final safeToSpendProvider = Provider<AsyncValue<SafeToSpend>>((ref) {
  final accounts = ref.watch(accountsProvider);
  final payments = ref.watch(paymentsProvider);
  final reserve = ref.watch(reserveProvider);
  for (final v in [accounts, payments, reserve]) {
    if (v case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  final a = accounts.value, p = payments.value, r = reserve.value;
  if (a == null || p == null || r == null) return const AsyncLoading();
  return AsyncData(
    computeSafeToSpend(
      accounts: a,
      payments: p,
      reserve: r,
      today: CalendarDate.today(),
    ),
  );
});
