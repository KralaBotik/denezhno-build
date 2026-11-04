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

Color _secondary(BuildContext c) =>
    CupertinoColors.secondaryLabel.resolveFrom(c);

String _signed(UpcomingItem i) => i.direction == FlowDirection.inflow
    ? '+${formatMoney(i.amount)}'
    : formatMoney(-i.amount);

/// «Платежи» tab: the next 30 days, credit-card figures, recurring payments
/// and incomes.
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final data = ref.watch(paymentsProvider);
    return CupertinoPageScaffold(
      key: const ValueKey('screen.payments'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(s.payments),
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
        child: !ready
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: const [StorageNotice()],
              )
            : switch (data) {
                AsyncData(:final value) => _PaymentsBody(snapshot: value),
                AsyncError() => ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(s.accountsLoadFailed),
                    CupertinoButton(
                      onPressed: () => ref.invalidate(paymentsProvider),
                      child: Text(s.retry),
                    ),
                  ],
                ),
                _ => const Center(child: CupertinoActivityIndicator()),
              },
      ),
    );
  }
}

class _PaymentsBody extends ConsumerWidget {
  const _PaymentsBody({required this.snapshot});
  final PaymentsSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
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
    ) {
      return CupertinoListSection.insetGrouped(
        header: Text(title),
        children: [
          for (final f in list)
            CupertinoListTile(
              key: ValueKey('flow.${f.id}'),
              title: Text(f.name),
              subtitle: Text(cadenceLabel(s, f.cadence)),
              additionalInfo: Text(formatMoney(f.amount)),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.push<void>(flowEditPath, extra: f),
            ),
          CupertinoListTile(
            key: ValueKey('flow.add.${dir.name}'),
            title: Text(
              add,
              style: const TextStyle(color: CupertinoColors.activeBlue),
            ),
            onTap: () => context.push<void>(flowEditPath, extra: dir),
          ),
        ],
      );
    }

    return ListView(
      children: [
        const _RemindersRow(),
        CupertinoListSection.insetGrouped(
          header: Text(s.upcomingTitle),
          children: [
            if (items.isEmpty)
              CupertinoListTile(
                title: Text(
                  s.upcomingEmpty,
                  maxLines: 4,
                  style: TextStyle(color: _secondary(context)),
                ),
              ),
            for (final i in items)
              CupertinoListTile(
                key: ValueKey(
                  'upcoming.${i.flowId ?? i.cardFiguresId}.${i.dueOn}',
                ),
                title: Text(
                  i.title,
                  style: i.done
                      ? TextStyle(
                          color: _secondary(context),
                          decoration: TextDecoration.lineThrough,
                        )
                      : null,
                ),
                subtitle: Text(
                  [
                    formatDue(s, i.dueOn, today),
                    if (i.isMinimumOnly) s.cardMinOnly,
                  ].join(' · '),
                  maxLines: 2,
                ),
                additionalInfo: Text(_signed(i)),
                trailing: CupertinoButton(
                  key: ValueKey(
                    'mark.${i.flowId ?? i.cardFiguresId}.${i.dueOn}',
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 44),
                  onPressed: () => unawaited(
                    i.source == UpcomingSource.flow
                        ? controller.setFlowDone(i.flowId!, i.dueOn, !i.done)
                        : controller.setCardSettled(i.cardFiguresId!, !i.done),
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
                        color: i.done
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (snapshot.creditCards.isNotEmpty)
          CupertinoListSection.insetGrouped(
            header: Text(s.creditCardsTitle),
            children: [
              for (final card in snapshot.creditCards.entries)
                CupertinoListTile(
                  key: ValueKey('card.${card.key}'),
                  title: Text(card.value),
                  subtitle: Text(
                    _figuresText(s, snapshot.cardFigures[card.key]),
                    maxLines: 3,
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () =>
                      context.push<void>(cardFiguresPath, extra: card.key),
                ),
            ],
          ),
        flowSection(
          s.recurringTitle,
          outflows,
          s.addPayment,
          FlowDirection.outflow,
        ),
        flowSection(s.incomesTitle, inflows, s.addIncome, FlowDirection.inflow),
        const SizedBox(height: 24),
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
      key: const ValueKey('screen.flowEdit'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.direction == FlowDirection.inflow
              ? s.incomeTitle
              : s.paymentTitle,
        ),
        trailing: CupertinoButton(
          key: const ValueKey('flow.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: Text(s.save),
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
                CupertinoListTile(
                  key: const ValueKey('flow.schedule'),
                  title: Text(cadenceLabel(s, _cadence)),
                  trailing: Text(
                    s.chooseDate,
                    style: const TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onTap: () => unawaited(_pickSchedule()),
                ),
              ],
            ),
            if (widget.direction == FlowDirection.outflow && debts.isNotEmpty)
              CupertinoListSection.insetGrouped(
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
      key: const ValueKey('screen.cardFigures'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(name),
        trailing: CupertinoButton(
          key: const ValueKey('figures.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: Text(s.save),
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
    final permitted = ref.watch(remindersProvider).value ?? false;
    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          key: const ValueKey('reminders.row'),
          title: Text(s.remindersTitle),
          subtitle: permitted || _denied
              ? Text(permitted ? s.remindersOn : s.remindersDenied, maxLines: 3)
              : null,
          trailing: permitted
              ? const Icon(
                  CupertinoIcons.bell_fill,
                  color: CupertinoColors.activeGreen,
                )
              : CupertinoButton(
                  key: const ValueKey('reminders.enable'),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final granted = await ref
                        .read(remindersProvider.notifier)
                        .enable();
                    if (mounted) setState(() => _denied = !granted);
                  },
                  child: Text(s.remindersEnable),
                ),
        ),
      ],
    );
  }
}
