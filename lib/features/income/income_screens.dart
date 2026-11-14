import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../../core/money/money_text.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../accounts/accounts.dart';
import '../accounts/accounts_controller.dart';
import '../operations/operations.dart';
import '../payments/payments.dart' show FlowDirection, Monthly, PlannedFlow;
import '../payments/payments_screens.dart'
    show
        cadenceLabel,
        flowEditPath,
        formatDate,
        formatDue,
        pickDate,
        pickFromList;
import '../payments/pay_screen.dart' show ConfirmationQuestions;
import 'income.dart';
import 'income_controller.dart';

const incomeSchedulePath = '/income/schedule';
const incomePaymentPath = '/income/payment';
const incomeReceivePath = '/income/receive';

/// Short status of a payment for lists.
String paymentStatus(AppLocalizations s, IncomePayment p, CalendarDate today) =>
    switch (p.state) {
      PaymentState.received => s.stateReceived,
      PaymentState.cancelled => s.stateCancelled,
      PaymentState.legacyMark => s.stateLegacy,
      PaymentState.open when p.dateUnknown => s.dateUnknownValue,
      PaymentState.open when p.isPartial => s.statePartial,
      PaymentState.open when p.isOverdue(today) => s.stateOverdue,
      PaymentState.open => formatDue(s, p.dueOn!, today),
    };

/// Income payments worth showing among «Ближайшие»: still expected and due
/// within 30 days, or late (overdue or no known date) — late ones first.
List<IncomePayment> upcomingIncome(
  List<IncomePayment> all,
  CalendarDate today,
) {
  final list = [
    for (final p in all)
      if (p.isOpen &&
          p.remaining.minorUnits > 0 &&
          (p.dueOn == null || p.dueOn! <= today.addDays(30)))
        p,
  ];
  list.sort((a, b) {
    final x = a.dueOn ?? a.scheduledOn;
    final y = b.dueOn ?? b.scheduledOn;
    return x.compareTo(y);
  });
  return list;
}

/// Money accounts the salary can come to (debts excluded).
List<AccountSummary> moneyAccounts(List<AccountSummary> all) =>
    all.where((a) => !a.kind.isLiability).toList();

/// One income payment in a list: date badge, label, status, the amount still
/// expected (or what came). Opens the payment card.
class IncomeRow extends StatelessWidget {
  const IncomeRow({super.key, required this.payment, required this.today});
  final IncomePayment payment;
  final CalendarDate today;

  static const _months = [
    'янв', 'фев', 'мар', 'апр', 'мая', 'июн', //
    'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final pay = payment;
    final date = pay.dueOn ?? pay.scheduledOn;
    final late = pay.isOverdue(today) || pay.dateUnknown;
    final shown = pay.isOpen ? pay.remaining : pay.received;
    return GestureDetector(
      key: ValueKey('income.${pay.key}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push<void>(incomePaymentPath, extra: pay.key),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.m),
        child: Row(
          children: [
            Container(
              width: 46,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: late ? p.warningSoft : p.accentSoft,
                borderRadius: BorderRadius.circular(Space.radiusSmall),
              ),
              child: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.3,
                child: Column(
                  children: [
                    Text(
                      pay.dateUnknown ? '?' : '${date.day}',
                      style: AppText.headline(p.text).copyWith(height: 1.1),
                    ),
                    Text(
                      _months[date.month - 1],
                      style: AppText.caption(p.textSecondary)
                          .copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pay.label, style: AppText.body(p.text)),
                  Text(
                    paymentStatus(s, pay, today),
                    style: AppText.caption(late ? p.warning : p.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Space.s),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.34,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: MoneyText(
                    shown,
                    prefix: '+',
                    size: 16,
                    color: pay.isOpen ? p.accent : p.textTertiary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: Space.xs),
              child: Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: p.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «Доходы» on the Payments tab — one place for every income: salary
/// sources (with their schedule) and other incomes (side jobs, cashback…).
/// One «Добавить доход» asks which kind, so salary is never added through
/// the general form by mistake.
class IncomeSourcesSection extends ConsumerWidget {
  const IncomeSourcesSection({super.key, this.otherIncomes = const []});
  final List<PlannedFlow> otherIncomes;

  Future<void> _add(BuildContext context, bool hasSalary) async {
    final s = AppLocalizations.of(context);
    final choice = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(s.addIncomeWhat),
        actions: [
          CupertinoActionSheetAction(
            key: const ValueKey('incomeSheet.salary'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(hasSalary ? s.sheetSalaryMore : s.sheetSalary),
          ),
          CupertinoActionSheetAction(
            key: const ValueKey('incomeSheet.other'),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.sheetOtherIncome),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(s.cancel),
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    await (choice
        ? context.push<void>(incomeSchedulePath)
        : context.push<void>(flowEditPath, extra: FlowDirection.inflow));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final sources = ref.watch(incomeProvider).value?.sources ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(s.incomeTitle),
        CardGroup(
          children: [
            for (final src in sources)
              SettingsRow(
                key: ValueKey('source.${src.id}'),
                icon: CupertinoIcons.briefcase_fill,
                iconColor: p.accent,
                title: src.name,
                subtitle: [
                  for (final part in src.currentParts)
                    if (part.cadence case Monthly(:final day))
                      '${part.label}: ${s.scheduleLine(day, formatMoney(part.amount))}'
                    else
                      '${part.label}: ${formatMoney(part.amount)}',
                ].join('\n'),
                onTap: () =>
                    context.push<void>(incomeSchedulePath, extra: src.id),
              ),
            if (sources.isEmpty)
              SettingsRow(
                key: const ValueKey('income.setup'),
                icon: CupertinoIcons.briefcase,
                iconColor: p.accent,
                title: s.salarySetup,
                subtitle: s.salarySetupHint,
                onTap: () => context.push<void>(incomeSchedulePath),
              ),
            for (final f in otherIncomes)
              SettingsRow(
                key: ValueKey('flow.${f.id}'),
                icon: CupertinoIcons.arrow_down_left,
                iconColor: p.accent,
                title: f.name,
                subtitle: s.otherIncomeSubtitle(cadenceLabel(s, f.cadence)),
                value: formatMoney(f.amount),
                onTap: () => context.push<void>(flowEditPath, extra: f),
              ),
            SettingsRow(
              key: const ValueKey('income.add'),
              icon: CupertinoIcons.add,
              title: s.addIncome,
              onTap: () => unawaited(_add(context, sources.isNotEmpty)),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Schedule: salary and advance (one or two payments a month).

class SalaryScheduleScreen extends ConsumerStatefulWidget {
  const SalaryScheduleScreen({super.key, this.sourceId});
  final String? sourceId;
  @override
  ConsumerState<SalaryScheduleScreen> createState() =>
      _SalaryScheduleScreenState();
}

class _PartFields {
  _PartFields({this.id, String label = '', String day = '', String amount = ''})
    : label = TextEditingController(text: label),
      day = TextEditingController(text: day),
      amount = TextEditingController(text: amount);
  final String? id;
  final TextEditingController label;
  final TextEditingController day;
  final TextEditingController amount;
  void dispose() {
    label.dispose();
    day.dispose();
    amount.dispose();
  }
}

class _SalaryScheduleScreenState extends ConsumerState<SalaryScheduleScreen> {
  final _name = TextEditingController();
  final _parts = <_PartFields>[];
  int _count = 2;
  HolidayRule _rule = HolidayRule.previousWorkday;
  String? _accountId;
  String? _error;
  bool _loaded = false;
  bool _saving = false;

  IncomeSource? _source(IncomeSnapshot snap) =>
      snap.sources.where((x) => x.id == widget.sourceId).firstOrNull;

  void _load(AppLocalizations s, IncomeSnapshot? snap) {
    if (_loaded) return;
    _loaded = true;
    final src = snap == null ? null : _source(snap);
    if (src == null) {
      _name.text = s.sourceNameDefault;
      _parts
        ..add(_PartFields(label: s.advanceDefault))
        ..add(_PartFields(label: s.salaryDefault));
      final accounts = moneyAccounts(ref.read(accountsProvider).value ?? []);
      _accountId = accounts.isEmpty ? null : accounts.first.id;
      return;
    }
    _name.text = src.name;
    _rule = src.holidayRule;
    _accountId = src.accountId;
    for (final part in src.currentParts) {
      _parts.add(
        _PartFields(
          id: part.id,
          label: part.label,
          day: part.cadence is Monthly
              ? '${(part.cadence as Monthly).day}'
              : '',
          amount: moneyInputText(part.amount),
        ),
      );
    }
    _count = _parts.length.clamp(1, 2);
    if (_parts.length == 1) _parts.add(_PartFields(label: s.advanceDefault));
  }

  @override
  void dispose() {
    _name.dispose();
    for (final p in _parts) {
      p.dispose();
    }
    super.dispose();
  }

  List<_PartFields> get _active =>
      _count == 1 ? [_parts.last] : _parts.take(2).toList();

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    final specs = <PartSpec>[];
    for (final f in _active) {
      final day = int.tryParse(f.day.text.trim());
      if (day == null || day < 1 || day > 31) {
        setState(() => _error = s.invalidDay);
        return;
      }
      Money? amount;
      try {
        amount = parseMoneyInput(f.amount.text);
      } on Object {
        amount = null;
      }
      if (amount == null || amount.minorUnits <= 0) {
        setState(() => _error = s.invalidAmount);
        return;
      }
      if (f.label.text.trim().isEmpty) {
        setState(() => _error = s.invalidLabel);
        return;
      }
      specs.add(
        PartSpec(
          id: f.id,
          label: f.label.text.trim(),
          amount: amount,
          cadence: Monthly(day),
        ),
      );
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    final c = ref.read(incomeProvider.notifier);
    try {
      if (widget.sourceId == null) {
        await c.create(
          name: _name.text,
          kind: IncomeKind.salary,
          holidayRule: _rule,
          parts: specs,
          accountId: _accountId,
        );
      } else {
        await c.updateSchedule(
          widget.sourceId!,
          name: _name.text,
          holidayRule: _rule,
          parts: specs,
          accountId: _accountId,
        );
      }
      if (mounted) context.pop();
    } on Object {
      if (mounted) setState(() => _error = s.saveFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _archive() async {
    final s = AppLocalizations.of(context);
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(s.archiveSource),
        content: Text(s.archiveSourceConfirm),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel),
          ),
          CupertinoDialogAction(
            key: const ValueKey('source.archiveConfirm'),
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(s.archiveSource),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(incomeProvider.notifier).archive(widget.sourceId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    _load(s, ref.watch(incomeProvider).value);
    final accounts = moneyAccounts(ref.watch(accountsProvider).value ?? []);
    final account = accounts.where((a) => a.id == _accountId).firstOrNull;
    final rules = [
      HolidayRule.previousWorkday,
      HolidayRule.nextWorkday,
      HolidayRule.none,
    ];
    String ruleLabel(HolidayRule r) => switch (r) {
      HolidayRule.previousWorkday => s.holidayPrevious,
      HolidayRule.nextWorkday => s.holidayNext,
      HolidayRule.none => s.holidayNone,
    };
    // Fields with a visible outline: on a white card a plain filled field
    // looked like empty space on the iPhone.
    final outlined = BoxDecoration(
      color: p.surface2,
      border: Border.all(color: p.separator),
      borderRadius: BorderRadius.circular(Space.radiusSmall),
    );
    Widget field(
      String key,
      TextEditingController c, {
      TextInputType? keyboard,
      String? suffix,
      String? placeholder,
      TextStyle? style,
      TextAlign align = TextAlign.start,
    }) => CupertinoTextField(
      key: ValueKey(key),
      controller: c,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.m,
        vertical: Space.s + 2,
      ),
      decoration: outlined,
      keyboardType: keyboard,
      placeholder: placeholder,
      textAlign: align,
      style: style ?? AppText.body(p.text),
      suffix: suffix == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: Space.m),
              child: Text(suffix, style: AppText.body(p.textSecondary)),
            ),
    );
    return CupertinoPageScaffold(
      key: const ValueKey('screen.salarySchedule'),
      backgroundColor: p.background,
      navigationBar: CupertinoNavigationBar(
        middle: BarText(
          widget.sourceId == null ? s.scheduleTitleNew : s.scheduleTitleEdit,
        ),
        backgroundColor: p.background,
        border: null,
        trailing: CupertinoButton(
          key: const ValueKey('schedule.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: BarText(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            FormFieldCard(
              label: s.sourceName,
              child: field('schedule.name', _name),
            ),
            FormFieldCard(
              label: s.paymentsPerMonth,
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  key: const ValueKey('schedule.count'),
                  groupValue: _count,
                  onValueChanged: (v) => setState(() => _count = v ?? 2),
                  children: {
                    1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(s.onePayment, key: const ValueKey('count.1')),
                    ),
                    2: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        s.twoPayments,
                        key: const ValueKey('count.2'),
                      ),
                    ),
                  },
                ),
              ),
            ),
            for (final (i, f) in _active.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.s),
                child: AppCard(
                  key: ValueKey('schedule.part.$i'),
                  padding: const EdgeInsets.all(Space.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      field(
                        'part.$i.label',
                        f.label,
                        placeholder: s.partLabelPlaceholder,
                        style: AppText.headline(p.text),
                      ),
                      const SizedBox(height: Space.s),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 84,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.partDayShort,
                                  style: AppText.caption(p.textSecondary),
                                ),
                                const SizedBox(height: Space.xs),
                                field(
                                  'part.$i.day',
                                  f.day,
                                  keyboard: TextInputType.number,
                                  placeholder: s.partDayPlaceholder,
                                  align: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Space.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.partAmount,
                                  style: AppText.caption(p.textSecondary),
                                ),
                                const SizedBox(height: Space.xs),
                                field(
                                  'part.$i.amount',
                                  f.amount,
                                  keyboard:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  placeholder: s.partAmountPlaceholder,
                                  suffix: '₽',
                                  style: AppText.amount(p.text),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.xs),
              child: Text(s.dayHint, style: AppText.caption(p.textTertiary)),
            ),
            const SizedBox(height: Space.m),
            CardGroup(
              children: [
                SettingsRow(
                  key: const ValueKey('schedule.account'),
                  title: s.incomeAccount,
                  value: account?.name ?? s.incomeAccountNone,
                  onTap: accounts.isEmpty
                      ? null
                      : () async {
                          final i = await pickFromList(context, [
                            for (final a in accounts) a.name,
                          ], account == null ? 0 : accounts.indexOf(account));
                          if (i != null) {
                            setState(() => _accountId = accounts[i].id);
                          }
                        },
                ),
                SettingsRow(
                  key: const ValueKey('schedule.rule'),
                  title: s.holidayRuleTitle,
                  subtitle: ruleLabel(_rule),
                  onTap: () async {
                    final i = await pickFromList(context, [
                      for (final r in rules) ruleLabel(r),
                    ], rules.indexOf(_rule));
                    if (i != null) setState(() => _rule = rules[i]);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(Space.xs),
              child: Text(
                s.holidayHint,
                style: AppText.caption(p.textTertiary),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(Space.xs),
                child: Text(
                  _error!,
                  key: const ValueKey('schedule.error'),
                  style: AppText.secondary(p.negative),
                ),
              ),
            if (widget.sourceId != null) ...[
              Padding(
                padding: const EdgeInsets.all(Space.xs),
                child: Text(
                  s.scheduleEditNote,
                  style: AppText.caption(p.textSecondary),
                ),
              ),
              const SizedBox(height: Space.l),
              Center(
                child: CupertinoButton(
                  key: const ValueKey('source.archive'),
                  onPressed: () => unawaited(_archive()),
                  child: Text(s.archiveSource, style: AppText.body(p.negative)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// One payment: plan, expectation, fact, and the actions.

IncomePayment? findPayment(IncomeSnapshot? snap, PaymentKey key) =>
    snap?.payments.where((p) => p.key == key).firstOrNull;

class IncomePaymentScreen extends ConsumerWidget {
  const IncomePaymentScreen({super.key, required this.paymentKey});
  final PaymentKey paymentKey;

  Future<bool> _confirm(
    BuildContext context,
    String text,
    String action, {
    bool destructive = false,
  }) async =>
      await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          content: Text(text),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(AppLocalizations.of(ctx).cancel),
            ),
            CupertinoDialogAction(
              key: const ValueKey('confirm.ok'),
              isDestructiveAction: destructive,
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(action),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final today = CalendarDate.today();
    final snapshot = ref.watch(incomeProvider).value;
    final pay = findPayment(snapshot, paymentKey);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final c = ref.read(incomeProvider.notifier);
    String accountName(String? id) =>
        accounts.where((a) => a.id == id).firstOrNull?.name ?? '';
    if (pay == null) {
      return AppPage(
        key: const ValueKey('screen.incomePayment'),
        title: s.receiveTitle,
        children: [
          if (snapshot == null)
            const Center(child: CupertinoActivityIndicator())
          else
            AppCard(
              child: Text(s.paymentNotFound, style: AppText.body(p.text)),
            ),
        ],
      );
    }
    final moved = pay.scheduledOn != pay.plannedOn;
    return AppPage(
      key: const ValueKey('screen.incomePayment'),
      title: pay.label,
      heroTag: 'nav.incomePayment',
      children: [
        Text(pay.sourceName, style: AppText.secondary(p.textSecondary)),
        const SizedBox(height: Space.s),
        Align(
          alignment: Alignment.centerLeft,
          child: StatusPill(
            key: const ValueKey('payment.status'),
            label: paymentStatus(s, pay, today),
            icon: pay.isOpen
                ? CupertinoIcons.clock
                : CupertinoIcons.checkmark_alt,
            foreground: pay.isOverdue(today) || pay.dateUnknown
                ? p.warning
                : p.accent,
            background: pay.isOverdue(today) || pay.dateUnknown
                ? p.warningSoft
                : p.accentSoft,
          ),
        ),
        SectionHeader(s.paymentPlan),
        CardGroup(
          children: [
            SettingsRow(
              key: const ValueKey('payment.planned'),
              title: formatDate(pay.scheduledOn),
              subtitle: moved
                  ? s.paymentHolidayMoved(formatDate(pay.plannedOn))
                  : null,
              value: formatMoney(pay.plannedAmount),
            ),
          ],
        ),
        if (pay.isOpen) ...[
          SectionHeader(s.paymentExpected),
          CardGroup(
            children: [
              SettingsRow(
                key: const ValueKey('payment.expectedOn'),
                title: pay.dueOn == null
                    ? s.dateUnknownValue
                    : formatDate(pay.dueOn!),
                value: formatMoney(pay.expected),
                onTap: () async {
                  final text = moneyInputText(pay.expected);
                  final controller = TextEditingController(text: text);
                  final amount = await showCupertinoDialog<Money>(
                    context: context,
                    builder: (ctx) => CupertinoAlertDialog(
                      title: Text(s.actionChangeAmount),
                      content: Padding(
                        padding: const EdgeInsets.only(top: Space.s),
                        child: CupertinoTextField(
                          key: const ValueKey('payment.amountField'),
                          controller: controller,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(s.cancel),
                        ),
                        CupertinoDialogAction(
                          key: const ValueKey('payment.amountSave'),
                          onPressed: () {
                            Money? m;
                            try {
                              m = parseMoneyInput(controller.text);
                            } on Object {
                              m = null;
                            }
                            Navigator.of(ctx).pop(m);
                          },
                          child: Text(s.save),
                        ),
                      ],
                    ),
                  );
                  controller.dispose();
                  if (amount != null && amount.minorUnits > 0) {
                    await c.setAmount(pay.key, amount);
                  }
                },
              ),
              if (pay.received.minorUnits > 0)
                SettingsRow(
                  key: const ValueKey('payment.remaining'),
                  title: s.paymentRemaining,
                  value: formatMoney(pay.remaining),
                ),
            ],
          ),
        ],
        if (pay.receipts.isNotEmpty) ...[
          SectionHeader(s.receiptsTitle),
          CardGroup(
            children: [
              for (final r in pay.receipts)
                SettingsRow(
                  key: ValueKey('receipt.${r.id}'),
                  title: formatMoney(r.amount),
                  subtitle: [
                    formatDate(r.receivedOn),
                    if (r.accountId != null) accountName(r.accountId),
                    if (r.cancelled) s.receiptCancelled,
                  ].join(' · '),
                  trailing: r.cancelled
                      ? null
                      : CupertinoButton(
                          key: ValueKey('receipt.${r.id}.cancel'),
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            if (await _confirm(
                              context,
                              s.cancelReceiptConfirm,
                              s.cancelReceipt,
                              destructive: true,
                            )) {
                              await c.cancelReceipt(r.id);
                            }
                          },
                          child: Text(
                            s.cancelReceipt,
                            style: AppText.secondary(p.negative),
                          ),
                        ),
                ),
            ],
          ),
        ],
        const SizedBox(height: Space.l),
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [
            if (pay.isOpen) ...[
              PillButton(
                key: const ValueKey('payment.receive'),
                label: s.actionReceived,
                icon: CupertinoIcons.checkmark_alt,
                filled: true,
                onPressed: () =>
                    context.push<void>(incomeReceivePath, extra: pay.key),
              ),
              PillButton(
                key: const ValueKey('payment.move'),
                label: s.actionMove,
                icon: CupertinoIcons.calendar,
                onPressed: () async {
                  final date = await pickDate(
                    context,
                    (pay.dueOn ?? today) < today ? today : (pay.dueOn ?? today),
                  );
                  if (date != null) await c.move(pay.key, date);
                },
              ),
              if (!pay.dateUnknown)
                PillButton(
                  key: const ValueKey('payment.unknown'),
                  label: s.actionUnknown,
                  onPressed: () => unawaited(c.dateUnknown(pay.key)),
                ),
              if (pay.received.minorUnits == 0)
                PillButton(
                  key: const ValueKey('payment.cancel'),
                  label: s.actionCancelPayment,
                  onPressed: () async {
                    if (await _confirm(
                      context,
                      s.cancelPaymentConfirm,
                      s.actionCancelPayment,
                    )) {
                      await c.cancel(pay.key);
                    }
                  },
                ),
            ],
            if (pay.state == PaymentState.cancelled)
              PillButton(
                key: const ValueKey('payment.reopen'),
                label: s.actionReopen,
                onPressed: () => unawaited(c.reopen(pay.key)),
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// «Получено»: amount, account, date → what will happen → confirm → write.

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key, required this.paymentKey});
  final PaymentKey paymentKey;
  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  final _amount = TextEditingController();
  CalendarDate _date = CalendarDate.today();
  String? _accountId;

  /// Answers per account, each about a specific confirmation.
  final _given = <String, ConfirmationAnswer>{};
  ShortfallChoice _shortfall = ShortfallChoice.restLater;
  CalendarDate? _restOn;
  bool _restUnknown = true;
  OperationPreview? _preview;
  int _request = 0;
  String? _error;
  bool _saving = false;
  bool _ready = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Money? get _parsed {
    try {
      final m = parseMoneyInput(_amount.text);
      return m == null || m.minorUnits <= 0 ? null : m;
    } on Object {
      return null;
    }
  }

  /// Recomputes what recording will do; nothing is written.
  Future<void> _refresh() async {
    final amount = _parsed;
    final id = ++_request;
    setState(() => _preview = null);
    if (amount == null || _accountId == null) return;
    try {
      final shown = await ref
          .read(incomeProvider.notifier)
          .preview(
            widget.paymentKey,
            amount: amount,
            accountId: _accountId!,
            date: _date,
            answers: Map.of(_given),
          );
      if (mounted && id == _request) {
        setState(() {
          _preview = shown;
          _error = null;
        });
      }
    } on Object {
      if (mounted && id == _request) {
        setState(() => _error = AppLocalizations.of(context).saveFailed);
      }
    }
  }

  /// A balance was confirmed that day and the person has not answered yet.
  /// A balance was confirmed on or after the date and that question is
  /// not answered (about the current confirmation).
  bool get _needsPlacement =>
      _preview != null && _preview!.unanswered(_given).isNotEmpty;

  Future<void> _confirm() async {
    final shown = _preview;
    final amount = _parsed;
    if (shown == null || amount == null || _accountId == null) return;
    if (_needsPlacement) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(incomeProvider.notifier)
          .receive(
            widget.paymentKey,
            amount: amount,
            accountId: _accountId!,
            date: _date,
            answers: Map.of(_given),
            shortfall: _shortfall,
            restOn: _restUnknown ? null : _restOn,
          );
      if (mounted) context.pop();
    } on Object {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).saveFailed);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final snapshot = ref.watch(incomeProvider).value;
    final pay = findPayment(snapshot, widget.paymentKey);
    final accounts = moneyAccounts(ref.watch(accountsProvider).value ?? []);
    if (snapshot != null && pay == null) {
      return CupertinoPageScaffold(
        key: const ValueKey('screen.receive'),
        backgroundColor: p.background,
        navigationBar: CupertinoNavigationBar(
          middle: BarText(s.receiveTitle),
          backgroundColor: p.background,
          border: null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Space.l),
            child: AppCard(
              child: Text(s.paymentNotFound, style: AppText.body(p.text)),
            ),
          ),
        ),
      );
    }
    if (!_ready && pay != null) {
      _ready = true;
      _amount.text = moneyInputText(pay.remaining);
      _accountId =
          accounts.where((a) => a.id == pay.accountId).firstOrNull?.id ??
          (accounts.isEmpty ? null : accounts.first.id);
      unawaited(Future.microtask(_refresh));
    }
    final account = accounts.where((a) => a.id == _accountId).firstOrNull;
    final amount = _parsed;
    final less =
        pay != null &&
        amount != null &&
        amount.minorUnits < pay.remaining.minorUnits;
    final shown = _preview;
    return CupertinoPageScaffold(
      key: const ValueKey('screen.receive'),
      backgroundColor: p.background,
      navigationBar: CupertinoNavigationBar(
        middle: BarText(pay?.label ?? s.receiveTitle),
        backgroundColor: p.background,
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            if (accounts.isEmpty)
              AppCard(
                child: Text(s.receiveNoAccounts, style: AppText.body(p.text)),
              ),
            FormFieldCard(
              label: s.receiveAmount,
              child: CupertinoTextField(
                key: const ValueKey('receive.amount'),
                controller: _amount,
                padding: const EdgeInsets.all(Space.m),
                decoration: fieldDecoration(context),
                style: AppText.amount(p.text, size: 22),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => unawaited(_refresh()),
                suffix: Padding(
                  padding: const EdgeInsets.only(right: Space.m),
                  child: Text('₽', style: AppText.body(p.textSecondary)),
                ),
              ),
            ),
            CardGroup(
              children: [
                SettingsRow(
                  key: const ValueKey('receive.account'),
                  title: s.receiveAccount,
                  value: account?.name ?? s.incomeAccountNone,
                  onTap: accounts.isEmpty
                      ? null
                      : () async {
                          final i = await pickFromList(context, [
                            for (final a in accounts) a.name,
                          ], account == null ? 0 : accounts.indexOf(account));
                          if (i != null) {
                            setState(() {
                              _accountId = accounts[i].id;
                              _given.clear();
                            });
                            unawaited(_refresh());
                          }
                        },
                ),
                SettingsRow(
                  key: const ValueKey('receive.date'),
                  title: s.receiveDate,
                  value: formatDate(_date),
                  onTap: () async {
                    final d = await pickDate(context, _date);
                    if (d == null || !mounted) return;
                    if (d > CalendarDate.today()) {
                      setState(() => _error = s.receiveFuture);
                      return;
                    }
                    setState(() {
                      _date = d;
                      _given.clear();
                    });
                    unawaited(_refresh());
                  },
                ),
              ],
            ),
            if (less) ...[
              const SizedBox(height: Space.m),
              AppCard(
                key: const ValueKey('receive.less'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      s.receiveLess(formatMoney(pay.remaining)),
                      style: AppText.secondary(p.textSecondary),
                    ),
                    const SizedBox(height: Space.s),
                    CupertinoSlidingSegmentedControl<ShortfallChoice>(
                      key: const ValueKey('receive.shortfall'),
                      groupValue: _shortfall,
                      onValueChanged: (v) => setState(
                        () => _shortfall = v ?? ShortfallChoice.restLater,
                      ),
                      children: {
                        ShortfallChoice.restLater: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            s.restLater,
                            key: const ValueKey('shortfall.later'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ShortfallChoice.wholePayment: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            s.wholePayment,
                            key: const ValueKey('shortfall.whole'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      },
                    ),
                    if (_shortfall == ShortfallChoice.restLater)
                      SettingsRow(
                        key: const ValueKey('receive.restOn'),
                        title: s.restDate,
                        value: _restUnknown || _restOn == null
                            ? s.restUnknown
                            : formatDate(_restOn!),
                        onTap: () async {
                          final d = await pickDate(
                            context,
                            _restOn ?? CalendarDate.today().addDays(7),
                          );
                          if (d != null) {
                            setState(() {
                              _restOn = d;
                              _restUnknown = false;
                            });
                          }
                        },
                      ),
                  ],
                ),
              ),
            ],
            SectionHeader(s.receiveCheck),
            AppCard(
              key: const ValueKey('receive.preview'),
              child: shown == null
                  ? const Center(child: CupertinoActivityIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConfirmationQuestions(
                          questions: shown.questions,
                          given: _given,
                          accounts: accounts,
                          onAnswer: (q, included) {
                            setState(
                              () => _given[q.accountId] = ConfirmationAnswer(
                                q.assertionId,
                                included: included,
                              ),
                            );
                            unawaited(_refresh());
                          },
                        ),
                        if (!_needsPlacement)
                          for (final e in shown.balances.entries)
                            Text(
                              s.receiveBalanceChange(
                                accounts
                                        .where((a) => a.id == e.key)
                                        .firstOrNull
                                        ?.name ??
                                    '',
                                formatMoney(e.value.$1),
                                formatMoney(e.value.$2),
                              ),
                              key: const ValueKey('receive.change'),
                              style: AppText.body(p.text),
                            ),
                      ],
                    ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(Space.xs),
                child: Text(
                  _error!,
                  key: const ValueKey('receive.error'),
                  style: AppText.secondary(p.negative),
                ),
              ),
            const SizedBox(height: Space.l),
            Center(
              child: PillButton(
                key: const ValueKey('receive.confirm'),
                label: s.receiveConfirm,
                icon: CupertinoIcons.checkmark_alt,
                filled: true,
                onPressed: shown == null || _saving || _needsPlacement
                    ? null
                    : () => unawaited(_confirm()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
