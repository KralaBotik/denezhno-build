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
import '../accounts/accounts.dart';
import '../accounts/accounts_controller.dart';
import 'payments.dart';
import 'payments_controller.dart';
import 'reminders_controller.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

const flowEditPath = '/flow';
const cardFiguresPath = '/card-figures';

const _monthsGenitive = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];
const weekdayNames = [
  'понедельник',
  'вторник',
  'среда',
  'четверг',
  'пятница',
  'суббота',
  'воскресенье',
];

String formatDate(CalendarDate d) => '${d.day} ${_monthsGenitive[d.month - 1]}';

String formatDue(AppLocalizations s, CalendarDate due, CalendarDate today) {
  final days = today.daysUntil(due);
  if (days == 0) return s.dueToday;
  if (days == 1) return s.dueTomorrow;
  return formatDate(due);
}

String flowKindLabel(AppLocalizations s, FlowKind k) => switch (k) {
  FlowKind.salary => s.flowKindSalary,
  FlowKind.otherIncome => s.flowKindOtherIncome,
  FlowKind.subscription => s.flowKindSubscription,
  FlowKind.utilities => s.flowKindUtilities,
  FlowKind.loanPayment => s.flowKindLoanPayment,
  FlowKind.rent => s.flowKindRent,
  FlowKind.communication => s.flowKindCommunication,
  FlowKind.otherPayment => s.flowKindOtherPayment,
};

String cadenceLabel(AppLocalizations s, Cadence c) => switch (c) {
  Monthly(:final day) => s.monthlyOn(day),
  Weekly(:final weekday) => s.weeklyOn(weekdayNames[weekday - 1]),
  Yearly(:final month, :final day) => s.yearlyOn(
    '$day ${_monthsGenitive[month - 1]}',
  ),
  Once(:final date) => s.onceOn(formatDate(date)),
};

Color _secondary(BuildContext c) => Palette.of(c).textSecondary;

/// One upcoming payment: date badge, name, when, signed amount.
class PaymentRow extends StatelessWidget {
  const PaymentRow({
    super.key,
    required this.item,
    required this.today,
    this.trailing,
  });
  final UpcomingItem item;
  final CalendarDate today;
  final Widget? trailing;

  static const _months = [
    'янв',
    'фев',
    'мар',
    'апр',
    'мая',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final inflow = item.direction == FlowDirection.inflow;
    final soon = today.daysUntil(item.dueOn) <= 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.m),
      child: Row(
        children: [
          Container(
            width: 46,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: soon && !item.done ? p.warningSoft : p.surface2,
              borderRadius: BorderRadius.circular(Space.radiusSmall),
            ),
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1.3,
              child: Column(
                children: [
                  Text(
                    '${item.dueOn.day}',
                    style: AppText.headline(p.text).copyWith(height: 1.1),
                  ),
                  Text(
                    _months[item.dueOn.month - 1],
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
                Text(
                  item.title,
                  style: AppText.body(item.done ? p.textTertiary : p.text)
                      .copyWith(
                        decoration: item.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                ),
                Text(
                  [
                    formatDue(s, item.dueOn, today),
                    if (item.isMinimumOnly) s.cardMinOnly,
                  ].join(' · '),
                  style: AppText.caption(p.textSecondary),
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
                  inflow ? item.amount : -item.amount,
                  prefix: inflow ? '+' : '',
                  color: item.done
                      ? p.textTertiary
                      : inflow
                      ? p.accent
                      : p.text,
                  size: 16,
                ),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// «Платежи»: the next 30 days, credit-card figures, recurring payments and
/// incomes; «+» adds a payment or an income.
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final s = AppLocalizations.of(context);
    final choice = await showCupertinoModalPopup<FlowDirection>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(s.addPaymentOrIncome),
        actions: [
          CupertinoActionSheetAction(
            key: const ValueKey('sheet.payment'),
            onPressed: () => Navigator.of(ctx).pop(FlowDirection.outflow),
            child: Text(s.addPayment),
          ),
          CupertinoActionSheetAction(
            key: const ValueKey('sheet.income'),
            onPressed: () => Navigator.of(ctx).pop(FlowDirection.inflow),
            child: Text(s.addIncome),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(s.cancel),
        ),
      ),
    );
    if (choice != null && context.mounted) {
      await context.push<void>(flowEditPath, extra: choice);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final data = ref.watch(paymentsProvider);
    return AppPage(
      key: const ValueKey('screen.payments'),
      title: s.payments,
      trailing: CupertinoButton(
        key: const ValueKey('payments.add'),
        padding: EdgeInsets.zero,
        onPressed: ready ? () => unawaited(_add(context)) : null,
        child: const Icon(CupertinoIcons.add_circled_solid, size: 28),
      ),
      children: [
        if (!ready)
          const StorageNotice(showDiagnostics: false)
        else
          switch (data) {
            AsyncData(:final value) => _PaymentsBody(snapshot: value),
            AsyncError() => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountsLoadFailed, style: AppText.body(p.text)),
                  const SizedBox(height: Space.m),
                  PillButton(
                    label: s.retry,
                    onPressed: () => ref.invalidate(paymentsProvider),
                  ),
                ],
              ),
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

class _PaymentsBody extends ConsumerWidget {
  const _PaymentsBody({required this.snapshot});
  final PaymentsSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final today = CalendarDate.today();
    final items = upcomingFor(snapshot, today);
    final controller = ref.read(paymentsProvider.notifier);
    final outflows = snapshot.flows
        .where((f) => f.direction == FlowDirection.outflow)
        .toList();
    final inflows = snapshot.flows
        .where((f) => f.direction == FlowDirection.inflow)
        .toList();

    Widget flowSection(
      String title,
      List<PlannedFlow> list,
      String add,
      FlowDirection dir,
    ) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title),
        CardGroup(
          children: [
            for (final f in list)
              SettingsRow(
                key: ValueKey('flow.${f.id}'),
                icon: dir == FlowDirection.inflow
                    ? CupertinoIcons.arrow_down_left
                    : CupertinoIcons.arrow_up_right,
                iconColor: dir == FlowDirection.inflow
                    ? p.accent
                    : p.textSecondary,
                title: f.name,
                subtitle:
                    '${flowKindLabel(s, f.kind)} · ${cadenceLabel(s, f.cadence)}',
                value: formatMoney(f.amount),
                onTap: () => context.push<void>(flowEditPath, extra: f),
              ),
            SettingsRow(
              key: ValueKey('flow.add.${dir.name}'),
              icon: CupertinoIcons.add,
              title: add,
              onTap: () => context.push<void>(flowEditPath, extra: dir),
            ),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _RemindersRow(),
        SectionHeader(s.upcomingTitle),
        if (items.isEmpty)
          AppCard(
            child: Text(
              s.upcomingEmpty,
              style: AppText.secondary(p.textSecondary),
            ),
          )
        else
          CardGroup(
            children: [
              for (final i in items)
                PaymentRow(
                  key: ValueKey(
                    'upcoming.${i.flowId ?? i.cardFiguresId}.${i.dueOn}',
                  ),
                  item: i,
                  today: today,
                  trailing: CupertinoButton(
                    key: ValueKey(
                      'mark.${i.flowId ?? i.cardFiguresId}.${i.dueOn}',
                    ),
                    padding: const EdgeInsets.only(left: Space.s),
                    minimumSize: const Size(44, 44),
                    onPressed: () => unawaited(
                      i.source == UpcomingSource.flow
                          ? controller.setFlowDone(i.flowId!, i.dueOn, !i.done)
                          : controller.setCardSettled(
                              i.cardFiguresId!,
                              !i.done,
                            ),
                    ),
                    child: Semantics(
                      label: i.done
                          ? s.undoMark
                          : i.direction == FlowDirection.inflow
                          ? s.markReceived
                          : s.markPaid,
                      button: true,
                      child: ExcludeSemantics(
                        child: Icon(
                          i.done
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.circle,
                          color: i.done ? p.accent : p.textTertiary,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (snapshot.creditCards.isNotEmpty) ...[
          SectionHeader(s.creditCardsTitle),
          CardGroup(
            children: [
              for (final card in snapshot.creditCards.entries)
                SettingsRow(
                  key: ValueKey('card.${card.key}'),
                  icon: CupertinoIcons.creditcard_fill,
                  iconColor: snapshot.cardFigures[card.key] == null
                      ? p.warning
                      : p.negative,
                  title: card.value,
                  subtitle: _figuresText(s, snapshot.cardFigures[card.key]),
                  onTap: () =>
                      context.push<void>(cardFiguresPath, extra: card.key),
                ),
            ],
          ),
        ],
        flowSection(
          s.recurringTitle,
          outflows,
          s.addPayment,
          FlowDirection.outflow,
        ),
        flowSection(s.incomesTitle, inflows, s.addIncome, FlowDirection.inflow),
      ],
    );
  }

  static String _figuresText(AppLocalizations s, CardFigures? f) {
    if (f == null) return s.cardNoFigures;
    return [
      if (f.graceAmount != null)
        s.cardGraceLine(formatMoney(f.graceAmount!), formatDate(f.graceDueOn!)),
      if (f.minPayment != null)
        s.cardMinLine(formatMoney(f.minPayment!), formatDate(f.minDueOn!)),
      if (f.settled) s.cardSettled,
    ].join('\n');
  }
}

Future<CalendarDate?> pickDate(BuildContext context, CalendarDate initial) {
  var picked = initial;
  return showCupertinoModalPopup<CalendarDate>(
    context: context,
    builder: (ctx) => Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(ctx),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              key: const ValueKey('picker.done'),
              onPressed: () => Navigator.of(ctx).pop(picked),
              child: Text(AppLocalizations.of(ctx).save),
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime(
                initial.year,
                initial.month,
                initial.day,
              ),
              onDateTimeChanged: (t) => picked = CalendarDate.fromDateTime(t),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<int?> pickFromList(
  BuildContext context,
  List<String> labels,
  int initialIndex,
) {
  var picked = initialIndex;
  return showCupertinoModalPopup<int>(
    context: context,
    builder: (ctx) => Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(ctx),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              key: const ValueKey('picker.done'),
              onPressed: () => Navigator.of(ctx).pop(picked),
              child: Text(AppLocalizations.of(ctx).save),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 36,
              scrollController: FixedExtentScrollController(
                initialItem: initialIndex,
              ),
              onSelectedItemChanged: (i) => picked = i,
              children: [for (final l in labels) Center(child: Text(l))],
            ),
          ),
        ],
      ),
    ),
  );
}

enum _CadenceChoice { monthly, weekly, yearly, once }

/// Add or edit a recurring payment / income. [initial] is an existing plan
/// to edit, or the direction for a new one.
class FlowEditScreen extends ConsumerStatefulWidget {
  const FlowEditScreen({super.key, this.flow, required this.direction});
  final PlannedFlow? flow;
  final FlowDirection direction;
  @override
  ConsumerState<FlowEditScreen> createState() => _FlowEditScreenState();
}

class _FlowEditScreenState extends ConsumerState<FlowEditScreen> {
  late final _name = TextEditingController(text: widget.flow?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.flow == null ? '' : moneyInputText(widget.flow!.amount),
  );
  late FlowKind _kind;
  late _CadenceChoice _choice;
  late String? _linked = widget.flow?.accountId;
  late int _day;
  late int _weekday;
  late CalendarDate _date;
  String? _nameError;
  String? _amountError;
  String? _saveError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final today = CalendarDate.today();
    _kind =
        widget.flow?.kind ??
        (widget.direction == FlowDirection.inflow
            ? FlowKind.salary
            : FlowKind.subscription);
    _day = today.day;
    _weekday = today.weekday;
    _date = today.addDays(7);
    _choice = _CadenceChoice.monthly;
    switch (widget.flow?.cadence) {
      case Monthly(:final day):
        _day = day;
      case Weekly(:final weekday):
        _choice = _CadenceChoice.weekly;
        _weekday = weekday;
      case Yearly(:final month, :final day):
        _choice = _CadenceChoice.yearly;
        _date = CalendarDate.clamped(today.year, month, day);
      case Once(:final date):
        _choice = _CadenceChoice.once;
        _date = date;
      case null:
        break;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Cadence get _cadence => switch (_choice) {
    _CadenceChoice.monthly => Monthly(_day),
    _CadenceChoice.weekly => Weekly(_weekday),
    _CadenceChoice.yearly => Yearly(_date.month, _date.day),
    _CadenceChoice.once => Once(_date),
  };

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    Money? amount;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? s.nameRequired : null;
      _amountError = null;
      _saveError = null;
      try {
        amount = parseMoneyInput(_amount.text);
        if (amount == null || amount!.minorUnits <= 0) {
          _amountError = s.invalidAmount;
        }
      } on Object {
        _amountError = s.invalidAmount;
      }
    });
    if (_nameError != null || _amountError != null) return;
    await _run(
      () => ref
          .read(paymentsProvider.notifier)
          .saveFlow(
            PlannedFlow(
              id: widget.flow?.id,
              kind: _kind,
              name: _name.text.trim(),
              amount: amount!,
              cadence: _cadence,
              startsOn: widget.flow?.startsOn ?? CalendarDate.today(),
              accountId: widget.direction == FlowDirection.outflow
                  ? _linked
                  : null,
            ),
          ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    final s = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await action();
      if (mounted) context.pop();
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError = s.saveFailed;
        });
      }
    }
  }

  Future<void> _pickSchedule() async {
    switch (_choice) {
      case _CadenceChoice.monthly:
        final i = await pickFromList(context, [
          for (var d = 1; d <= 31; d++) '$d',
        ], _day - 1);
        if (i != null) setState(() => _day = i + 1);
      case _CadenceChoice.weekly:
        final i = await pickFromList(context, weekdayNames, _weekday - 1);
        if (i != null) setState(() => _weekday = i + 1);
      case _CadenceChoice.yearly || _CadenceChoice.once:
        final d = await pickDate(context, _date);
        if (d != null) setState(() => _date = d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final kinds = FlowKind.values
        .where((k) => k.direction == widget.direction)
        .toList();
    final debts = <(String?, String)>[
      for (final a
          in ref.watch(accountsProvider).value ?? const <AccountSummary>[])
        if (a.kind.isLiability) (a.id, a.name),
    ];
    Widget error(String? t) => t == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text(
              t,
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          );
    Widget field(
      String key,
      String label,
      TextEditingController c, {
      bool numeric = false,
    }) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: _secondary(context))),
          const SizedBox(height: 6),
          CupertinoTextField(
            padding: const EdgeInsets.all(Space.m),
            decoration: fieldDecoration(context),
            key: ValueKey(key),
            controller: c,
            keyboardType: numeric
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
          ),
        ],
      ),
    );
    final labels = {
      _CadenceChoice.monthly: s.cadenceMonthly,
      _CadenceChoice.weekly: s.cadenceWeekly,
      _CadenceChoice.yearly: s.cadenceYearly,
      _CadenceChoice.once: s.cadenceOnce,
    };
    return CupertinoPageScaffold(
      backgroundColor: Palette.of(context).background,
      key: const ValueKey('screen.flowEdit'),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Palette.of(context).background,
        border: null,
        middle: BarText(
          widget.direction == FlowDirection.inflow
              ? s.incomeTitle
              : s.paymentTitle,
        ),
        trailing: CupertinoButton(
          key: const ValueKey('flow.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: BarText(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            field('flow.name', s.fieldName, _name),
            error(_nameError),
            field('flow.amount', s.fieldAmount, _amount, numeric: true),
            error(_amountError),
            CupertinoListSection.insetGrouped(
              backgroundColor: const Color(0x00000000),
              margin: const EdgeInsets.fromLTRB(
                Space.l,
                Space.s,
                Space.l,
                Space.s,
              ),
              decoration: BoxDecoration(
                color: Palette.of(context).surface,
                borderRadius: BorderRadius.circular(Space.radius),
              ),
              header: Text(s.fieldKind),
              children: [
                for (final k in kinds)
                  CupertinoListTile(
                    key: ValueKey('flowKind.${k.name}'),
                    title: Text(flowKindLabel(s, k)),
                    trailing: _kind == k
                        ? const Icon(CupertinoIcons.check_mark, size: 20)
                        : null,
                    onTap: () => setState(() => _kind = k),
                  ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              backgroundColor: const Color(0x00000000),
              margin: const EdgeInsets.fromLTRB(
                Space.l,
                Space.s,
                Space.l,
                Space.s,
              ),
              decoration: BoxDecoration(
                color: Palette.of(context).surface,
                borderRadius: BorderRadius.circular(Space.radius),
              ),
              header: Text(s.fieldSchedule),
              children: [
                for (final c in _CadenceChoice.values)
                  CupertinoListTile(
                    key: ValueKey('cadence.${c.name}'),
                    title: Text(labels[c]!),
                    trailing: _choice == c
                        ? const Icon(CupertinoIcons.check_mark, size: 20)
                        : null,
                    onTap: () => setState(() => _choice = c),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.l),
                  child: SettingsRow(
                    key: const ValueKey('flow.schedule'),
                    icon: CupertinoIcons.calendar,
                    title: cadenceLabel(s, _cadence),
                    subtitle: s.chooseDate,
                    onTap: () => unawaited(_pickSchedule()),
                  ),
                ),
              ],
            ),
            if (widget.direction == FlowDirection.outflow && debts.isNotEmpty)
              CupertinoListSection.insetGrouped(
                backgroundColor: const Color(0x00000000),
                margin: const EdgeInsets.fromLTRB(
                  Space.l,
                  Space.s,
                  Space.l,
                  Space.s,
                ),
                decoration: BoxDecoration(
                  color: Palette.of(context).surface,
                  borderRadius: BorderRadius.circular(Space.radius),
                ),
                header: Text(s.linkedTo),
                footer: Text(s.linkedHint),
                children: [
                  for (final (id, name) in [(null, s.notLinked), ...debts])
                    CupertinoListTile(
                      key: ValueKey('link.${id ?? 'none'}'),
                      title: Text(name),
                      trailing: _linked == id
                          ? const Icon(CupertinoIcons.check_mark, size: 20)
                          : null,
                      onTap: () => setState(() => _linked = id),
                    ),
                ],
              ),
            if (widget.flow?.id != null)
              CupertinoButton(
                key: const ValueKey('flow.delete'),
                onPressed: _saving
                    ? null
                    : () => unawaited(
                        _run(
                          () => ref
                              .read(paymentsProvider.notifier)
                              .archiveFlow(widget.flow!.id!),
                        ),
                      ),
                child: Text(
                  s.delete,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ),
            error(_saveError),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Figures copied from the credit-card screen of the bank app.
class CardFiguresScreen extends ConsumerStatefulWidget {
  const CardFiguresScreen({super.key, required this.accountId});
  final String accountId;
  @override
  ConsumerState<CardFiguresScreen> createState() => _CardFiguresScreenState();
}

class _CardFiguresScreenState extends ConsumerState<CardFiguresScreen> {
  final _grace = TextEditingController();
  final _min = TextEditingController();
  late CalendarDate _graceDue;
  late CalendarDate _minDue;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final current = ref
        .read(paymentsProvider)
        .value
        ?.cardFigures[widget.accountId];
    final fallback = CalendarDate.today().addDays(20);
    _graceDue = current?.graceDueOn ?? fallback;
    _minDue = current?.minDueOn ?? current?.graceDueOn ?? fallback;
    if (current?.graceAmount != null) {
      _grace.text = moneyInputText(current!.graceAmount!);
    }
    if (current?.minPayment != null) {
      _min.text = moneyInputText(current!.minPayment!);
    }
  }

  @override
  void dispose() {
    _grace.dispose();
    _min.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    Money? grace;
    Money? min;
    try {
      grace = parseMoneyInput(_grace.text);
      min = parseMoneyInput(_min.text);
      if ((grace?.minorUnits ?? 0) < 0 || (min?.minorUnits ?? 0) < 0) {
        throw const FormatException('negative');
      }
    } on Object {
      setState(() => _error = s.invalidAmount);
      return;
    }
    if (grace == null && min == null) {
      setState(() => _error = s.figuresNeedOne);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      await ref
          .read(paymentsProvider.notifier)
          .saveCardFigures(
            CardFigures(
              id: '',
              accountId: widget.accountId,
              graceAmount: grace,
              graceDueOn: grace == null ? null : _graceDue,
              minPayment: min,
              minDueOn: min == null ? null : _minDue,
            ),
          );
      if (mounted) context.pop();
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = s.saveFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final name =
        ref.watch(paymentsProvider).value?.creditCards[widget.accountId] ?? '';
    Widget block(
      String key,
      String label,
      TextEditingController c,
      CalendarDate due,
      ValueChanged<CalendarDate> onDue,
    ) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: _secondary(context))),
          const SizedBox(height: 6),
          CupertinoTextField(
            padding: const EdgeInsets.all(Space.m),
            decoration: fieldDecoration(context),
            key: ValueKey('figures.$key'),
            controller: c,
            placeholder: '0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          CupertinoButton(
            key: ValueKey('figures.$key.date'),
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () async {
              final d = await pickDate(context, due);
              if (d != null) onDue(d);
            },
            child: Text('${s.dueDateField}: ${formatDate(due)}'),
          ),
        ],
      ),
    );
    return CupertinoPageScaffold(
      backgroundColor: Palette.of(context).background,
      key: const ValueKey('screen.cardFigures'),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Palette.of(context).background,
        border: null,
        middle: BarText(name),
        trailing: CupertinoButton(
          key: const ValueKey('figures.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: BarText(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                s.cardFiguresHint,
                style: TextStyle(color: _secondary(context)),
              ),
            ),
            block(
              'grace',
              s.graceAmountField,
              _grace,
              _graceDue,
              (d) => setState(() => _graceDue = d),
            ),
            block(
              'min',
              s.minPaymentField,
              _min,
              _minDue,
              (d) => setState(() => _minDue = d),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RemindersRow extends ConsumerStatefulWidget {
  const _RemindersRow();
  @override
  ConsumerState<_RemindersRow> createState() => _RemindersRowState();
}

class _RemindersRowState extends ConsumerState<_RemindersRow> {
  bool _denied = false;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final permitted = ref.watch(remindersProvider).value ?? false;
    return AppCard(
      key: const ValueKey('reminders.row'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: permitted
                ? CupertinoIcons.bell_fill
                : CupertinoIcons.bell_slash,
            color: permitted ? p.accent : p.textSecondary,
          ),
          const SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.remindersTitle, style: AppText.headline(p.text)),
                if (permitted || _denied)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      permitted ? s.remindersOn : s.remindersDenied,
                      style: AppText.caption(p.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
          if (!permitted)
            Flexible(
              child: PillButton(
                key: const ValueKey('reminders.enable'),
                label: s.remindersEnable,
                filled: true,
                onPressed: () async {
                  final granted = await ref
                      .read(remindersProvider.notifier)
                      .enable();
                  if (mounted) setState(() => _denied = !granted);
                },
              ),
            ),
        ],
      ),
    );
  }
}
