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
import '../backup/backup_section.dart' show UpgradeNotice;
import '../income/income_controller.dart';
import '../income/income_screens.dart';
import '../payments/pay_screen.dart';
import '../payments/payments_controller.dart';
import '../payments/payments_screens.dart'
    show formatDate, cardFiguresPath, PaymentRow, pickDate;
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
        SalaryOverdue() ||
        SalaryDateUnknown() ||
        CardWithoutFigures() ||
        OverdueCardFigures() ||
        StaleBalances() => true,
        MinimumOnly() ||
        PaymentOverdue() ||
        PossibleDuplicate() ||
        SalaryDelayed() ||
        SalaryPartial() => false,
      },
    );

/// Главная: the safe-to-spend figure and everything needed to trust it.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final status = ref.watch(appControllerProvider.select((st) => st.storage));
    final ready = status == StorageStatus.ready;
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
        if (status == StorageStatus.upgradeRequired)
          const UpgradeNotice()
        else if (!ready)
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
    // Income first (late ones on top), then payments; four rows at most.
    final incomes = upcomingIncome(
      ref.watch(incomeProvider).value?.payments ?? const [],
      today,
    ).take(2).toList();
    final next = payments == null
        ? const <UpcomingItem>[]
        : upcomingFor(payments, today)
              .where((i) => !i.done && i.direction == FlowDirection.outflow)
              .take(4 - incomes.length)
              .toList();

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
              onTap: () => context.push<void>(incomeSchedulePath),
            ),
          );
        case SalaryOverdue(:final payment):
          fixes.insert(
            0,
            NoticeTile(
              key: ValueKey('fix.salaryOverdue.${payment.key}'),
              icon: CupertinoIcons.money_rubl_circle,
              text: s.incomeOverdue(payment.label, formatDate(payment.dueOn!)),
              onTap: null,
              actions: [
                PillButton(
                  key: const ValueKey('salary.received'),
                  label: s.actionReceived,
                  icon: CupertinoIcons.checkmark_alt,
                  filled: true,
                  onPressed: () =>
                      context.push<void>(incomeReceivePath, extra: payment.key),
                ),
                PillButton(
                  key: const ValueKey('salary.move'),
                  label: s.actionMove,
                  icon: CupertinoIcons.calendar,
                  onPressed: () async {
                    final date = await pickDate(context, today.addDays(1));
                    if (date != null) {
                      await ref
                          .read(incomeProvider.notifier)
                          .move(payment.key, date);
                    }
                  },
                ),
                PillButton(
                  key: const ValueKey('salary.details'),
                  label: s.actionDetails,
                  onPressed: () =>
                      context.push<void>(incomePaymentPath, extra: payment.key),
                ),
              ],
            ),
          );
        case SalaryDateUnknown(:final payment):
          fixes.insert(
            0,
            NoticeTile(
              key: ValueKey('fix.salaryUnknown.${payment.key}'),
              icon: CupertinoIcons.question_circle,
              text: s.incomeUnknown(payment.label),
              onTap: null,
              actions: [
                PillButton(
                  key: const ValueKey('salary.receivedUnknown'),
                  label: s.actionReceived,
                  icon: CupertinoIcons.checkmark_alt,
                  filled: true,
                  onPressed: () =>
                      context.push<void>(incomeReceivePath, extra: payment.key),
                ),
                PillButton(
                  key: const ValueKey('salary.setDate'),
                  label: s.actionSetDate,
                  icon: CupertinoIcons.calendar,
                  onPressed: () async {
                    final date = await pickDate(context, today.addDays(1));
                    if (date != null) {
                      await ref
                          .read(incomeProvider.notifier)
                          .move(payment.key, date);
                    }
                  },
                ),
              ],
            ),
          );
        case SalaryDelayed(:final payment, :final perDayIfOnTime):
          notes.add(
            NoticeTile(
              key: ValueKey('note.salaryDelayed.${payment.key}'),
              tone: NoticeTone.info,
              icon: CupertinoIcons.calendar_badge_plus,
              text: perDayIfOnTime == null
                  ? s.incomeDelayedSimple(
                      payment.label,
                      formatDate(payment.dueOn!),
                    )
                  : s.incomeDelayed(
                      payment.label,
                      formatDate(payment.dueOn!),
                      formatMoney(value.perDay),
                      formatMoney(perDayIfOnTime),
                    ),
              onTap: () =>
                  context.push<void>(incomePaymentPath, extra: payment.key),
            ),
          );
        case SalaryPartial(:final payment):
          notes.add(
            NoticeTile(
              key: ValueKey('note.salaryPartial.${payment.key}'),
              tone: NoticeTone.info,
              icon: CupertinoIcons.chart_pie,
              text: s.incomePartial(
                payment.label,
                formatMoney(payment.received),
                formatMoney(payment.expected),
              ),
              onTap: () =>
                  context.push<void>(incomePaymentPath, extra: payment.key),
            ),
          );
        case PaymentOverdue(:final name, :final dueOn, :final flowId):
          fixes.insert(
            0,
            NoticeTile(
              key: ValueKey('fix.paymentOverdue.$flowId.$dueOn'),
              icon: CupertinoIcons.exclamationmark_circle,
              text: s.fixPaymentOverdue(name, formatDate(dueOn)),
              onTap: null,
              actions: [
                PillButton(
                  key: ValueKey('overdue.pay.$flowId.$dueOn'),
                  label: s.payTitle,
                  icon: CupertinoIcons.checkmark_alt,
                  filled: true,
                  onPressed: () => context.push<void>(
                    payPath,
                    extra: PlanDate(flowId, dueOn),
                  ),
                ),
                PillButton(
                  key: ValueKey('overdue.skip.$flowId.$dueOn'),
                  label: s.paySkip,
                  onPressed: () => unawaited(
                    ref
                        .read(paymentsProvider.notifier)
                        .setSkipped(flowId, dueOn, true),
                  ),
                ),
              ],
            ),
          );
        case CardWithoutFigures(:final name, :final accountId):
          final debt = value.cards
              .where((c) => c.accountId == accountId)
              .firstOrNull
              ?.debt;
          fixes.add(
            NoticeTile(
              key: ValueKey('fix.card.$accountId'),
              icon: CupertinoIcons.creditcard,
              text: debt == null
                  ? s.fixCardNoFigures(name)
                  : s.fixCardUnknown(name, formatMoney(debt)),
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
        if (value.obligationsTotal.minorUnits > 0) ...[
          const SizedBox(height: Space.m),
          AppCard(
            key: const ValueKey('home.obligations'),
            padding: const EdgeInsets.symmetric(
              horizontal: Space.l,
              vertical: Space.m,
            ),
            child: Row(
              children: [
                IconBadge(
                  icon: CupertinoIcons.calendar_badge_minus,
                  color: p.warning,
                  size: 30,
                ),
                const SizedBox(width: Space.m),
                Expanded(
                  child: Text(
                    s.obligationsUntil(formatDate(value.horizon)),
                    style: AppText.secondary(p.text),
                  ),
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
                      child: MoneyText(
                        value.obligationsTotal,
                        key: const ValueKey('home.obligationsAmount'),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                amount: value.totalDebt,
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
        if (next.isEmpty && incomes.isEmpty)
          AppCard(
            child: Text(
              s.noUpcoming,
              style: AppText.secondary(p.textSecondary),
            ),
          )
        else
          CardGroup(
            children: [
              for (final row in <(CalendarDate, Widget)>[
                for (final pay in incomes)
                  (pay.dueOn ?? today, IncomeRow(payment: pay, today: today)),
                for (final i in next)
                  (i.dueOn, PaymentRow(item: i, today: today)),
              ]..sort((a, b) => a.$1.compareTo(b.$1)))
                row.$2,
            ],
          ),
        const SizedBox(height: Space.l),
        _Breakdown(value: value),
        _Scenarios(value: value),
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

class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.value, required this.accounts});
  final SafeToSpend value;
  final List<AccountSummary> accounts;

  Future<void> _choosePeriod(BuildContext context, WidgetRef ref) async {
    final s = AppLocalizations.of(context);
    final controller = ref.read(forecastPeriodProvider.notifier);
    final choice = await showCupertinoModalPopup<ForecastPeriod>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(s.periodTitle),
        message: Text(s.periodHint),
        actions: [
          for (final d in const [7, 14, 30])
            CupertinoActionSheetAction(
              key: ValueKey('period.$d'),
              onPressed: () => Navigator.of(ctx).pop(PeriodDays(d)),
              child: Text(s.periodDaysOption(d)),
            ),
          CupertinoActionSheetAction(
            key: const ValueKey('period.date'),
            onPressed: () async {
              final today = CalendarDate.today();
              final picked = await pickDate(ctx, today.addDays(14));
              if (picked != null && ctx.mounted) {
                Navigator.of(ctx).pop(PeriodUntil(picked));
              }
            },
            child: Text(s.periodUntilOption),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(s.cancel),
        ),
      ),
    );
    if (choice != null) await controller.choose(choice);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period =
        ref.watch(forecastPeriodProvider).value ?? defaultForecastPeriod;
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    const white = Color(0xFFFFFFFF);
    const white70 = Color(0xB3FFFFFF);
    final short = value.available.minorUnits < 0;
    final preliminary = isPreliminary(value);
    final salary = value.horizonKind == HorizonKind.salary;
    final date = formatDate(value.horizon);
    final days = switch (period) {
      PeriodDays(:final days) => days,
      PeriodUntil() => null,
    };
    final title = salary
        ? (short ? s.heroShortUntil(date) : s.heroUntil(date))
        : days != null
        ? (short ? s.heroPeriodShortDays(days) : s.heroPeriodDays(days))
        : (short ? s.heroPeriodShortUntil(date) : s.heroPeriodUntil(date));
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        key: const ValueKey('home.horizon'),
                        style: AppText.secondary(white70),
                      ),
                      if (!salary)
                        GestureDetector(
                          key: const ValueKey('home.period'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () => unawaited(_choosePeriod(context, ref)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${s.periodChange} ›',
                              style: AppText.caption(
                                white,
                              ).copyWith(decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: Space.s),
                Flexible(
                  child: StatusPill(
                    key: const ValueKey('home.status'),
                    label: preliminary ? s.statusPreliminary : s.statusComplete,
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
                        if (v.cards.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: Space.s),
                            child: Text(
                              s.rowCardsTitle,
                              style: AppText.caption(p.textSecondary),
                            ),
                          ),
                          for (final c in v.cards) _CardLine(card: c),
                        ],
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

/// One credit card in «Как считаем»: debt, the two bank figures and what was
/// subtracted — never mixed into one number.
class _CardLine extends StatelessWidget {
  const _CardLine({required this.card});
  final CardPosition card;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final basis = switch (card.basis) {
      CardBasis.grace => s.cardBasisGrace,
      CardBasis.minimumOnly => s.cardBasisMinimum,
      CardBasis.noFigures => s.cardBasisNoFigures,
      CardBasis.plannedPayment => s.cardBasisPlanned,
      CardBasis.dueAfterHorizon => s.cardBasisAfter,
      CardBasis.settled => s.cardBasisSettled,
      CardBasis.noDebt => s.cardBasisNoDebt,
    };
    final warn =
        card.basis == CardBasis.noFigures ||
        card.basis == CardBasis.minimumOnly;
    return Padding(
      key: ValueKey('row.card.${card.accountId}'),
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${card.name} · ${s.cardDebtLine(formatMoney(card.debt))}',
            style: AppText.secondary(p.text),
          ),
          if (card.graceAmount != null && card.graceDueOn != null)
            Text(
              s.cardGraceShort(
                formatMoney(card.graceAmount!),
                formatDate(card.graceDueOn!),
              ),
              style: AppText.caption(p.textSecondary),
            ),
          if (card.minPayment != null && card.minDueOn != null)
            Text(
              s.cardMinShort(
                formatMoney(card.minPayment!),
                formatDate(card.minDueOn!),
              ),
              style: AppText.caption(p.textSecondary),
            ),
          Text(
            card.deducted.minorUnits > 0
                ? '$basis: ${formatMoney(card.deducted)}'
                : basis,
            style: AppText.caption(warn ? p.warning : p.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// Information only: the overall position. Never called a safe amount.
class _Scenarios extends StatelessWidget {
  const _Scenarios({required this.value});
  final SafeToSpend value;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    if (value.totalDebt.minorUnits <= 0 && value.minimumOnlyAvailable == null) {
      return const SizedBox.shrink();
    }
    Widget item({
      required Key key,
      required String title,
      required Money amount,
      required String note,
      bool warn = false,
    }) => Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: Space.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(title, style: AppText.secondary(p.text))),
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
                    child: MoneyText(
                      amount,
                      size: 16,
                      color: amount.minorUnits < 0 ? p.negative : p.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(note, style: AppText.caption(warn ? p.warning : p.textTertiary)),
        ],
      ),
    );
    final all = value.ifAllDebtsPaid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(s.scenariosTitle),
        CardGroup(
          children: [
            if (value.totalDebt.minorUnits > 0)
              item(
                key: const ValueKey('scenario.allDebts'),
                title: all.minorUnits < 0
                    ? s.scenarioAllDebtsShort
                    : s.scenarioAllDebts,
                amount: all.minorUnits < 0 ? -all : all,
                note: s.scenarioAllDebtsNote(formatMoney(value.totalDebt)),
              ),
            if (value.minimumOnlyAvailable case final min?)
              item(
                key: const ValueKey('scenario.minimum'),
                title: s.scenarioMinimum,
                amount: min,
                note: s.scenarioMinimumNote,
                warn: true,
              ),
          ],
        ),
      ],
    );
  }
}
