import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/controller.dart';
import '../../app/screens.dart' show StorageNotice;
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../../core/money/money_text.dart';
import '../../l10n/generated/app_localizations.dart';
import '../accounts/accounts_controller.dart';
import '../accounts/accounts_screens.dart';
import '../payments/payments.dart';
import '../payments/payments_controller.dart';
import '../payments/payments_screens.dart' show formatDate, formatDue;
import 'safe_to_spend.dart';
import 'forecast_controller.dart';

Color _secondary(BuildContext c) =>
    CupertinoColors.secondaryLabel.resolveFrom(c);

/// Главная: how much can be spent safely until the next income, with the full
/// breakdown, warnings, the nearest payments and «Обновить остатки».
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final forecast = ref.watch(safeToSpendProvider);
    final hasAccounts =
        (ref.watch(accountsProvider).value ?? const []).isNotEmpty;
    return CupertinoPageScaffold(
      key: const ValueKey('screen.home'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(s.appName),
        trailing: CupertinoButton(
          key: const ValueKey('open.settings'),
          padding: EdgeInsets.zero,
          onPressed: () => context.push<void>('/settings'),
          child: Semantics(
            label: s.settings,
            button: true,
            child: const ExcludeSemantics(child: Icon(CupertinoIcons.gear)),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            if (ready && hasAccounts)
              switch (forecast) {
                AsyncData(:final value) => _Forecast(value: value),
                AsyncError() => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(s.accountsLoadFailed),
                ),
                _ => const Padding(
                  padding: EdgeInsets.all(32),
                  child: CupertinoActivityIndicator(),
                ),
              }
            else if (ready)
              const _Empty(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: StorageNotice(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              s.homeEmptyTitle,
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
          ),
          const SizedBox(height: 12),
          Text(s.homeEmptyHint, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          CupertinoButton.filled(
            key: const ValueKey('home.addAccount'),
            onPressed: () => context.push<void>(addAccountPath),
            child: Text(s.addAccount),
          ),
        ],
      ),
    );
  }
}

class _Forecast extends ConsumerWidget {
  const _Forecast({required this.value});
  final SafeToSpend value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final today = CalendarDate.today();
    final short = value.available.minorUnits < 0;
    final title = value.horizonKind == HorizonKind.salary
        ? s.canSpendUntilSalary(formatDate(value.horizon))
        : s.canSpendUntilMonthEnd;
    final bigStyle = CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
        .copyWith(
          fontSize: 40,
          color: short
              ? CupertinoColors.systemRed
              : value.veryStale
              ? _secondary(context)
              : null,
        );
    String warning(SpendWarning w) => switch (w) {
      NoAccounts() => s.warnNoAccounts,
      NoSalary() => s.warnNoSalary,
      CardWithoutFigures(:final name) => s.warnCardNoFigures(name),
      MinimumOnly(:final name) => s.warnMinimumOnly(name),
      StaleBalances(:final oldest) => s.staleNote(formatDate(oldest)),
      PossibleDuplicate(:final name) => s.warnPossibleDuplicate(name),
      OverdueCardFigures(:final name, :final dueOn) => s.warnOverdueFigures(
        name,
        formatDate(dueOn),
      ),
    };
    Widget row(String key, String label, Money amount, {bool minus = true}) =>
        CupertinoListTile(
          key: ValueKey(key),
          title: Text(label, maxLines: 2),
          additionalInfo: Text(
            minus ? formatMoney(-amount) : formatMoney(amount),
          ),
        );
    final payments = ref.watch(paymentsProvider).value;
    final next = payments == null
        ? const <UpcomingItem>[]
        : upcomingFor(payments, today).where((i) => !i.done).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Semantics(
            container: true,
            label: title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: _secondary(context))),
                const SizedBox(height: 4),
                Text(
                  short
                      ? s.shortBy(formatMoney(-value.available))
                      : formatMoney(value.available),
                  key: const ValueKey('home.available'),
                  style: bigStyle,
                ),
                if (!short)
                  Text(
                    s.perDay(formatMoney(value.perDay), value.daysLeft),
                    key: const ValueKey('home.perDay'),
                  ),
                if (value.veryStale)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      s.veryStaleNote,
                      style: const TextStyle(
                        color: CupertinoColors.systemOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        for (final w in value.warnings)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              warning(w),
              style: const TextStyle(color: CupertinoColors.systemOrange),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: CupertinoButton.filled(
            key: const ValueKey('home.update'),
            onPressed: () => unawaited(context.push<void>(updateBalancesPath)),
            child: Text(s.updateBalances),
          ),
        ),
        CupertinoListSection.insetGrouped(
          header: Text(s.howCalculated),
          footer: Text(
            [
              s.expectedIncomeNote,
              if (value.skippedAsDuplicates.isNotEmpty)
                s.skippedDuplicatesNote(
                  value.skippedAsDuplicates
                      .map((d) => d.title)
                      .toSet()
                      .join(', '),
                ),
            ].join('\n'),
          ),
          children: [
            row('row.money', s.rowMoney, value.money, minus: false),
            if (value.payments.isNotEmpty)
              row(
                'row.payments',
                s.rowPayments(value.payments.length),
                value.paymentsTotal,
              ),
            if (value.cardPayments.isNotEmpty)
              row('row.cards', s.rowCards, value.cardPaymentsTotal),
            if (value.goals.minorUnits != 0)
              row('row.goals', s.rowGoals, value.goals),
            row('row.reserve', s.rowReserve, value.reserve),
            row('row.result', s.rowResult, value.available, minus: false),
          ],
        ),
        if (next.isNotEmpty)
          CupertinoListSection.insetGrouped(
            header: Text(s.nextPayments),
            children: [
              for (final i in next)
                CupertinoListTile(
                  title: Text(i.title),
                  subtitle: Text(formatDue(s, i.dueOn, today)),
                  additionalInfo: Text(
                    i.direction == FlowDirection.inflow
                        ? '+${formatMoney(i.amount)}'
                        : formatMoney(-i.amount),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
