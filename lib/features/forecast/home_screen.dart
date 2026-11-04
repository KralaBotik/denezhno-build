import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/controller.dart';
import '../../app/screens.dart' show StorageNotice, settingsPath;
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../../core/money/money_text.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../accounts/accounts.dart';
import '../accounts/accounts_controller.dart';
import '../accounts/accounts_screens.dart';
import '../payments/payments.dart';
import '../payments/payments_controller.dart';
import '../payments/payments_screens.dart'
    show formatDate, flowEditPath, cardFiguresPath, PaymentRow;
import 'forecast_controller.dart';
import 'safe_to_spend.dart';

/// Data the figure cannot be trusted without. Notes (minimum-only, possible
/// duplicate) do not make the figure preliminary but are shown alongside.
bool isPreliminary(SafeToSpend v) =>
    v.veryStale ||
    v.warnings.any(
      (w) => switch (w) {
        NoAccounts() ||
        NoSalary() ||
        CardWithoutFigures() ||
        OverdueCardFigures() ||
        StaleBalances() => true,
        MinimumOnly() || PossibleDuplicate() => false,
      },
    );

/// Главная: the safe-to-spend figure and everything needed to trust it.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final forecast = ref.watch(safeToSpendProvider);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    return AppPage(
      key: const ValueKey('screen.home'),
      title: s.appName,
      trailing: CupertinoButton(
        key: const ValueKey('open.settings'),
        padding: EdgeInsets.zero,
        onPressed: () => context.push<void>(settingsPath),
        child: Semantics(
          label: s.settings,
          button: true,
          child: ExcludeSemantics(
            child: Icon(CupertinoIcons.gear_alt_fill, color: p.textSecondary),
          ),
        ),
      ),
      children: [
        if (!ready)
          const StorageNotice()
        else if (accounts.isEmpty)
          const _Onboarding()
        else
          switch (forecast) {
            AsyncData(:final value) => _Dashboard(
              value: value,
              accounts: accounts,
            ),
            AsyncError() => AppCard(
              child: Text(s.accountsLoadFailed, style: AppText.body(p.text)),
            ),
            _ => const Padding(
              padding: EdgeInsets.all(Space.xxl),
              child: CupertinoActivityIndicator(),
            ),
          },
      ],
    );
  }
}

class _Onboarding extends StatelessWidget {
  const _Onboarding();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    return AppCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        children: [
          IconBadge(
            icon: CupertinoIcons.creditcard_fill,
            color: p.accent,
            size: 56,
          ),
          const SizedBox(height: Space.l),
          Semantics(
            header: true,
            child: Text(
              s.homeEmptyTitle,
              textAlign: TextAlign.center,
              style: AppText.title(p.text),
            ),
          ),
          const SizedBox(height: Space.s),
          Text(
            s.homeEmptyHint,
            textAlign: TextAlign.center,
            style: AppText.secondary(p.textSecondary),
          ),
          const SizedBox(height: Space.l),
          PillButton(
            key: const ValueKey('home.addAccount'),
            label: s.addAccount,
            icon: CupertinoIcons.add,
            filled: true,
            onPressed: () => context.push<void>(addAccountPath),
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.value, required this.accounts});
  final SafeToSpend value;
  final List<AccountSummary> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final today = CalendarDate.today();
    final totals = AccountTotals(accounts);
    final payments = ref.watch(paymentsProvider).value;
    final next = payments == null
        ? const <UpcomingItem>[]
        : upcomingFor(payments, today).where((i) => !i.done).take(4).toList();

    void card(String? id) {
      if (id != null) context.push<void>(cardFiguresPath, extra: id);
    }

    final fixes = <Widget>[];
    final notes = <Widget>[];
    for (final w in value.warnings) {
      switch (w) {
        case NoAccounts():
          fixes.add(
            NoticeTile(
              text: s.fixNoAccounts,
              onTap: () => context.push<void>(addAccountPath),
            ),
          );
        case NoSalary():
          fixes.add(
            NoticeTile(
              key: const ValueKey('fix.salary'),
              icon: CupertinoIcons.money_rubl_circle,
              text: s.fixNoSalary,
              onTap: () =>
                  context.push<void>(flowEditPath, extra: FlowDirection.inflow),
            ),
          );
        case CardWithoutFigures(:final name, :final accountId):
          fixes.add(
            NoticeTile(
              key: ValueKey('fix.card.$accountId'),
              icon: CupertinoIcons.creditcard,
              text: s.fixCardNoFigures(name),
              onTap: () => card(accountId),
            ),
          );
        case OverdueCardFigures(:final name, :final dueOn, :final accountId):
          fixes.add(
            NoticeTile(
              icon: CupertinoIcons.clock,
              text: s.fixOverdue(name, formatDate(dueOn)),
              onTap: () => card(accountId),
            ),
          );
        case StaleBalances(:final oldest):
          fixes.add(
            NoticeTile(
              icon: CupertinoIcons.arrow_clockwise,
              text: s.fixStale(formatDate(oldest)),
              onTap: () => context.push<void>(updateBalancesPath),
            ),
          );
        case MinimumOnly(:final name, :final accountId):
          notes.add(
            NoticeTile(
              tone: NoticeTone.info,
              icon: CupertinoIcons.info,
              text: s.noteMinimumOnly(name),
              onTap: () => card(accountId),
            ),
          );
        case PossibleDuplicate(:final name):
          notes.add(
            NoticeTile(
              tone: NoticeTone.info,
              icon: CupertinoIcons.info,
              text: s.notePossibleDuplicate(name),
              onTap: () => context.go('/payments'),
            ),
          );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(value: value, accounts: accounts),
        const SizedBox(height: Space.m),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: s.ownMoney,
                amount: totals.ownMoney + totals.savings,
                amountKey: const ValueKey('home.own'),
                onTap: () => context.go('/accounts'),
              ),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: StatTile(
                label: s.debts,
                amount: totals.debts,
                amountKey: const ValueKey('home.debts'),
                onTap: () => context.go('/accounts'),
              ),
            ),
          ],
        ),
        if (fixes.isNotEmpty || notes.isNotEmpty) ...[
          SectionHeader(s.attentionTitle),
          CardGroup(children: [...fixes, ...notes]),
        ],
        SectionHeader(
          s.nextPayments,
          actionLabel: s.seeAll,
          actionKey: const ValueKey('home.allPayments'),
          onAction: () => context.go('/payments'),
        ),
        if (next.isEmpty)
          AppCard(
            child: Text(
              s.noUpcoming,
              style: AppText.secondary(p.textSecondary),
            ),
          )
        else
          CardGroup(
            children: [for (final i in next) PaymentRow(item: i, today: today)],
          ),
        const SizedBox(height: Space.l),
        _Breakdown(value: value),
      ],
    );
  }
}

/// Oldest «обновлено» among the counted money accounts, as a phrase.
String freshnessPhrase(AppLocalizations s, List<AccountSummary> accounts) {
  DateTime? oldest;
  for (final a in accounts.where((a) => !a.kind.isLiability)) {
    final t = a.lastUpdatedAt;
    if (t != null && (oldest == null || t.isBefore(oldest))) oldest = t;
  }
  if (oldest == null) return s.freshNever;
  final days = CalendarDate.fromDateTime(oldest.toLocal())
      .daysUntil(CalendarDate.today());
  return days <= 0
      ? s.freshToday
      : days == 1
      ? s.freshYesterday
      : s.freshDays(days);
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.value, required this.accounts});
  final SafeToSpend value;
  final List<AccountSummary> accounts;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    const white = Color(0xFFFFFFFF);
    const white70 = Color(0xB3FFFFFF);
    final short = value.available.minorUnits < 0;
    final preliminary = isPreliminary(value);
    final salary = value.horizonKind == HorizonKind.salary;
    final date = formatDate(value.horizon);
    final title = short
        ? (salary ? s.heroShortUntil(date) : s.heroShortMonthEnd)
        : (salary ? s.heroUntil(date) : s.heroUntilMonthEnd);
    final colors = short
        ? const [Color(0xFFC0473F), Color(0xFF7E2622)]
        : [p.heroStart, p.heroEnd];
    return Semantics(
      container: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(title, style: AppText.secondary(white70))),
                const SizedBox(width: Space.s),
                Flexible(
                  child: StatusPill(
                    key: const ValueKey('home.status'),
                    label: preliminary ? s.statusPreliminary : s.statusPrecise,
                    icon: preliminary
                        ? CupertinoIcons.exclamationmark_circle_fill
                        : CupertinoIcons.checkmark_seal_fill,
                    foreground: preliminary ? p.gold : white,
                    background: const Color(0x26FFFFFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.s),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: MoneyText(
                short ? -value.available : value.available,
                key: const ValueKey('home.available'),
                size: 40,
                weight: FontWeight.w700,
                color: white,
                prefix: preliminary && !short ? '≈ ' : '',
              ),
            ),
            if (!short)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  s.perDayShort(formatMoney(value.perDay), value.daysLeft),
                  key: const ValueKey('home.perDay'),
                  style: AppText.secondary(const Color(0xE6FFFFFF)),
                ),
              ),
            if (preliminary)
              Padding(
                padding: const EdgeInsets.only(top: Space.s),
                child: Text(
                  s.preliminaryExplain,
                  style: AppText.caption(white70),
                ),
              ),
            const SizedBox(height: Space.s),
            Row(
              children: [
                const Icon(CupertinoIcons.clock, size: 14, color: white70),
                const SizedBox(width: Space.xs),
                Expanded(
                  child: Text(
                    freshnessPhrase(s, accounts),
                    style: AppText.caption(white70),
                  ),
                ),
                Flexible(
                  child: PillButton(
                    key: const ValueKey('home.update'),
                    label: s.updateShort,
                    icon: CupertinoIcons.arrow_clockwise,
                    onHero: true,
                    onPressed: () =>
                        unawaited(context.push<void>(updateBalancesPath)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// «Как считаем» — collapsed by default; every term of the figure.
class _Breakdown extends StatefulWidget {
  const _Breakdown({required this.value});
  final SafeToSpend value;
  @override
  State<_Breakdown> createState() => _BreakdownState();
}

class _BreakdownState extends State<_Breakdown> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final v = widget.value;
    Widget row(String key, String label, Money amount, {bool minus = true}) =>
        Padding(
          key: ValueKey(key),
          padding: const EdgeInsets.symmetric(vertical: Space.s),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: AppText.secondary(p.textSecondary)),
              ),
              const SizedBox(width: Space.s),
              Flexible(
                flex: 0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.4,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: MoneyText(minus ? -amount : amount, size: 15),
                  ),
                ),
              ),
            ],
          ),
        );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            key: const ValueKey('home.breakdown'),
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _open = !_open),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.howCalculated, style: AppText.headline(p.text)),
                ),
                AnimatedRotation(
                  turns: _open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: p.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: !_open
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: Space.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        row('row.money', s.rowMoney, v.money, minus: false),
                        if (v.payments.isNotEmpty)
                          row(
                            'row.payments',
                            s.rowPayments(v.payments.length),
                            v.paymentsTotal,
                          ),
                        if (v.cardPayments.isNotEmpty)
                          row('row.cards', s.rowCards, v.cardPaymentsTotal),
                        if (v.goals.minorUnits != 0)
                          row('row.goals', s.rowGoals, v.goals),
                        row('row.reserve', s.rowReserve, v.reserve),
                        Container(height: 0.5, color: p.separator),
                        row(
                          'row.result',
                          s.rowResult,
                          v.available,
                          minus: false,
                        ),
                        const SizedBox(height: Space.xs),
                        Text(
                          [
                            s.expectedIncomeNote,
                            if (v.skippedAsDuplicates.isNotEmpty)
                              s.skippedDuplicatesNote(
                                v.skippedAsDuplicates
                                    .map((d) => d.title)
                                    .toSet()
                                    .join(', '),
                              ),
                          ].join('\n'),
                          style: AppText.caption(p.textTertiary),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
