import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../accounts/accounts_controller.dart';
import '../income/income_controller.dart';
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

/// The period used when the next salary date is unknown (7 / 14 / 30 days
/// or a date), stored in the database (schema v5).
final forecastPeriodProvider =
    AsyncNotifierProvider<ForecastPeriodController, ForecastPeriod>(
      ForecastPeriodController.new,
    );

class ForecastPeriodController extends AsyncNotifier<ForecastPeriod> {
  @override
  Future<ForecastPeriod> build() async {
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    if (!ready) return defaultForecastPeriod;
    return ref.read(incomeStoreProvider).forecastPeriod();
  }

  Future<void> choose(ForecastPeriod period) async {
    state = AsyncData(period);
    await ref.read(incomeStoreProvider).setForecastPeriod(period);
  }
}

/// «Можно потратить» for today, recomputed whenever accounts, plans, card
/// figures or the reserve change. Pure calculation in [computeSafeToSpend].
final safeToSpendProvider = Provider<AsyncValue<SafeToSpend>>((ref) {
  final accounts = ref.watch(accountsProvider);
  final payments = ref.watch(paymentsProvider);
  final reserve = ref.watch(reserveProvider);
  final period =
      ref.watch(forecastPeriodProvider).value ?? defaultForecastPeriod;
  final income = ref.watch(incomeProvider);
  for (final v in [accounts, payments, reserve, income]) {
    if (v case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  final a = accounts.value, p = payments.value, r = reserve.value;
  final i = income.value;
  if (a == null || p == null || r == null || i == null) {
    return const AsyncLoading();
  }
  return AsyncData(
    computeSafeToSpend(
      accounts: a,
      payments: p,
      reserve: r,
      today: CalendarDate.today(),
      period: period,
      incomes: i.payments,
    ),
  );
});
