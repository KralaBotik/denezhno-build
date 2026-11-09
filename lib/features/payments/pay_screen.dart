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
import 'payments.dart';
import 'payments_controller.dart';
import 'payments_screens.dart' show formatDate, pickDate, pickFromList;

const payPath = '/pay';

String _when(DateTime t) {
  final local = t.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '${formatDate(CalendarDate.fromDateTime(local))}, $hh:$mm';
}

/// «Оплачено» (R3 risk Р1): the payment becomes an operation in the
/// journal — an expense, or a transfer to the card/loan it repays. What it
/// will do is shown first; when the account's balance was confirmed the
/// same day, the person must say whether the payment was already in it;
/// a similar operation must be acknowledged. Only then it is written, in
/// one transaction with the payment's status.
class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key, required this.target});
  final PayTarget target;
  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  final _amount = TextEditingController();
  late CalendarDate _date;
  String? _accountId;
  SameDayPlacement _placement = SameDayPlacement.auto;
  bool _notDuplicate = false;
  PaymentCheck? _check;
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

  /// What paying will do; nothing is written.
  Future<void> _refresh() async {
    final amount = _parsed;
    final id = ++_request;
    setState(() {
      _check = null;
      _notDuplicate = false;
    });
    if (amount == null || _accountId == null) return;
    try {
      final check = await ref
          .read(paymentsProvider.notifier)
          .preview(
            widget.target,
            amount: amount,
            accountId: _accountId!,
            date: _date,
            placement: _placement,
          );
      if (mounted && id == _request) {
        setState(() {
          _check = check;
          _error = null;
        });
      }
    } on Object catch (e) {
      if (mounted && id == _request) {
        final s = AppLocalizations.of(context);
        setState(
          () => _error = e is InvalidOperation && e.reason == 'already paid'
              ? s.payAlreadyPaid
              : s.payFailed,
        );
      }
    }
  }

  bool get _needsPlacement =>
      _check != null &&
      _check!.operation.askIncluded &&
      _placement == SameDayPlacement.auto;

  bool get _canConfirm =>
      _check != null &&
      !_saving &&
      !_needsPlacement &&
      (_check!.similar.isEmpty || _notDuplicate);

  Future<void> _confirm() async {
    final amount = _parsed;
    if (!_canConfirm || amount == null) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(paymentsProvider.notifier)
          .pay(
            widget.target,
            amount: amount,
            accountId: _accountId!,
            date: _date,
            placement: _check!.operation.placement,
            confirmedNotDuplicate: _notDuplicate,
          );
      if (mounted) context.pop();
    } on Object catch (e) {
      if (mounted) {
        final s = AppLocalizations.of(context);
        setState(
          () => _error = e is InvalidOperation && e.reason == 'already paid'
              ? s.payAlreadyPaid
              : s.payFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _skip(PlanDate t) async {
    final s = AppLocalizations.of(context);
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Text(s.paySkipConfirm),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancel),
          ),
          CupertinoDialogAction(
            key: const ValueKey('pay.skipConfirm'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(s.paySkip),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref
        .read(paymentsProvider.notifier)
        .setSkipped(t.flowId, t.dueOn, true);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final snap = ref.watch(paymentsProvider).value;
    final all = ref.watch(accountsProvider).value ?? const <AccountSummary>[];
    final money = all.where((a) => !a.kind.isLiability).toList();
    final today = CalendarDate.today();

    // What is being paid: title, due date, the amount by default.
    String title = s.payTitle;
    CalendarDate? due;
    Money? byDefault;
    String? debtAccount;
    switch (widget.target) {
      case PlanDate(:final flowId, :final dueOn):
        final f = snap?.flows.where((x) => x.id == flowId).firstOrNull;
        title = f?.name ?? title;
        due = dueOn;
        byDefault = f?.amount;
        debtAccount = f?.accountId;
      case CardDue(:final figuresId):
        final f = snap?.cardFigures.values
            .where((x) => x.id == figuresId)
            .firstOrNull;
        title = snap?.creditCards[f?.accountId] ?? title;
        due = f?.graceDueOn ?? f?.minDueOn;
        byDefault = f?.remainingDue;
        debtAccount = f?.accountId;
    }
    if (!_ready && snap != null && all.isNotEmpty) {
      _ready = true;
      _amount.text = byDefault == null ? '' : moneyInputText(byDefault);
      _date = due == null || due > today ? today : due;
      _accountId = money.isEmpty ? null : money.first.id;
      unawaited(Future.microtask(_refresh));
    } else if (!_ready) {
      _date = today;
    }
    final account = money.where((a) => a.id == _accountId).firstOrNull;
    final check = _check;
    String name(String id) =>
        all.where((a) => a.id == id).firstOrNull?.name ?? '';
    bool isDebt(String id) =>
        all.where((a) => a.id == id).firstOrNull?.kind.isLiability ?? false;

    return CupertinoPageScaffold(
      key: const ValueKey('screen.pay'),
      backgroundColor: p.background,
      navigationBar: CupertinoNavigationBar(
        middle: BarText(title),
        backgroundColor: p.background,
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            if (due != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.s),
                child: Text(
                  s.payDue(formatDate(due)),
                  style: AppText.secondary(p.textSecondary),
                ),
              ),
            if (money.isEmpty)
              AppCard(
                child: Text(s.payNoAccounts, style: AppText.body(p.text)),
              ),
            FormFieldCard(
              label: s.payAmount,
              child: CupertinoTextField(
                key: const ValueKey('pay.amount'),
                controller: _amount,
                padding: const EdgeInsets.all(Space.m),
                decoration: fieldDecoration(context),
                style: AppText.amount(p.text, size: 22),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) {
                  _placement = SameDayPlacement.auto;
                  unawaited(_refresh());
                },
                suffix: Padding(
                  padding: const EdgeInsets.only(right: Space.m),
                  child: Text('₽', style: AppText.body(p.textSecondary)),
                ),
              ),
            ),
            CardGroup(
              children: [
                SettingsRow(
                  key: const ValueKey('pay.account'),
                  title: s.payAccount,
                  value: account?.name ?? s.incomeAccountNone,
                  onTap: money.isEmpty
                      ? null
                      : () async {
                          final i = await pickFromList(context, [
                            for (final a in money) a.name,
                          ], account == null ? 0 : money.indexOf(account));
                          if (i != null) {
                            setState(() {
                              _accountId = money[i].id;
                              _placement = SameDayPlacement.auto;
                            });
                            unawaited(_refresh());
                          }
                        },
                ),
                SettingsRow(
                  key: const ValueKey('pay.date'),
                  title: s.payDate,
                  value: _ready ? formatDate(_date) : '',
                  onTap: () async {
                    final d = await pickDate(context, _date);
                    if (d == null || !mounted) return;
                    if (d > CalendarDate.today()) {
                      setState(() => _error = s.receiveFuture);
                      return;
                    }
                    setState(() {
                      _date = d;
                      _placement = SameDayPlacement.auto;
                    });
                    unawaited(_refresh());
                  },
                ),
              ],
            ),
            if (debtAccount != null)
              Padding(
                padding: const EdgeInsets.all(Space.xs),
                child: Text(
                  s.payTransferNote,
                  style: AppText.caption(p.textSecondary),
                ),
              ),
            SectionHeader(s.receiveCheck),
            AppCard(
              key: const ValueKey('pay.preview'),
              child: check == null
                  ? (_error == null
                        ? const Center(child: CupertinoActivityIndicator())
                        : Text(_error!, style: AppText.body(p.negative)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_needsPlacement)
                          _SameDayChoice(
                            question: s.sameDayQuestion(
                              account?.name ?? '',
                              check.operation.latestConfirmation == null
                                  ? formatDate(_date)
                                  : _when(check.operation.latestConfirmation!),
                            ),
                            yes: s.sameDayYes,
                            no: s.sameDayNo,
                            onChoose: (inBalance) {
                              setState(
                                () => _placement = inBalance
                                    ? SameDayPlacement.inConfirmedBalance
                                    : SameDayPlacement.afterConfirmedBalance,
                              );
                              unawaited(_refresh());
                            },
                          )
                        else if (check.operation.inConfirmedBalance &&
                            check.operation.confirmedAt != null)
                          Text(
                            s.payAlreadyIn(
                              account?.name ?? '',
                              _when(check.operation.confirmedAt!),
                            ),
                            key: const ValueKey('pay.alreadyIn'),
                            style: AppText.body(p.text),
                          )
                        else
                          for (final e in check.operation.balances.entries)
                            Text(
                              isDebt(e.key)
                                  ? s.payDebtChange(
                                      name(e.key),
                                      formatMoney(e.value.$1),
                                      formatMoney(e.value.$2),
                                    )
                                  : s.payBalanceChange(
                                      name(e.key),
                                      formatMoney(e.value.$1),
                                      formatMoney(e.value.$2),
                                    ),
                              key: ValueKey('pay.change.${e.key}'),
                              style: AppText.body(p.text),
                            ),
                        if (check.operation.askIncluded && !_needsPlacement)
                          CupertinoButton(
                            key: const ValueKey('pay.switch'),
                            padding: const EdgeInsets.only(top: Space.s),
                            alignment: Alignment.centerLeft,
                            onPressed: () {
                              setState(
                                () => _placement = SameDayPlacement.auto,
                              );
                              unawaited(_refresh());
                            },
                            child: Text(
                              s.periodChange,
                              style: AppText.secondary(p.accent),
                            ),
                          ),
                      ],
                    ),
            ),
            if (check != null && check.similar.isNotEmpty) ...[
              const SizedBox(height: Space.m),
              AppCard(
                key: const ValueKey('pay.similar'),
                color: p.warningSoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final x in check.similar)
                      Text(
                        s.similarFound(
                          formatDate(x.date),
                          formatMoney(x.amount),
                          x.description == null ? '' : ' («${x.description}»)',
                        ),
                        style: AppText.secondary(p.text),
                      ),
                    const SizedBox(height: Space.s),
                    Row(
                      children: [
                        CupertinoSwitch(
                          key: const ValueKey('pay.notDuplicate'),
                          value: _notDuplicate,
                          activeTrackColor: p.accent,
                          onChanged: (v) => setState(() => _notDuplicate = v),
                        ),
                        const SizedBox(width: Space.s),
                        Expanded(
                          child: Text(
                            s.similarConfirm,
                            style: AppText.secondary(p.text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (_error != null && check != null)
              Padding(
                padding: const EdgeInsets.all(Space.xs),
                child: Text(
                  _error!,
                  key: const ValueKey('pay.error'),
                  style: AppText.secondary(p.negative),
                ),
              ),
            const SizedBox(height: Space.l),
            Center(
              child: PillButton(
                key: const ValueKey('pay.confirm'),
                label: s.payConfirm,
                icon: CupertinoIcons.checkmark_alt,
                filled: true,
                onPressed: _canConfirm ? () => unawaited(_confirm()) : null,
              ),
            ),
            if (widget.target case final PlanDate t)
              Center(
                child: CupertinoButton(
                  key: const ValueKey('pay.skip'),
                  onPressed: _saving ? null : () => unawaited(_skip(t)),
                  child: Text(
                    s.paySkip,
                    style: AppText.secondary(p.textSecondary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// «Was it already in the balance you confirmed that day?» — no default:
/// the person answers before anything can be written (R3 risk Р1).
class _SameDayChoice extends StatelessWidget {
  const _SameDayChoice({
    required this.question,
    required this.yes,
    required this.no,
    required this.onChoose,
  });
  final String question;
  final String yes;
  final String no;
  final void Function(bool inBalance) onChoose;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(
      key: const ValueKey('sameDay.choice'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(question, style: AppText.body(p.text)),
        const SizedBox(height: Space.s),
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [
            PillButton(
              key: const ValueKey('sameDay.yes'),
              label: yes,
              onPressed: () => onChoose(true),
            ),
            PillButton(
              key: const ValueKey('sameDay.no'),
              label: no,
              onPressed: () => onChoose(false),
            ),
          ],
        ),
      ],
    );
  }
}

/// Shared with «Получено»: the same explicit same-day question.
Widget sameDayChoice({
  required String question,
  required String yes,
  required String no,
  required void Function(bool inBalance) onChoose,
}) => _SameDayChoice(question: question, yes: yes, no: no, onChoose: onChoose);
