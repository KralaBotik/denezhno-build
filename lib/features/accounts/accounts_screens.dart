import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/controller.dart';
import '../../app/screens.dart' show StorageNotice;
import '../../core/money/money.dart';
import '../../core/money/money_text.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import 'accounts.dart';
import 'accounts_controller.dart';

const addAccountPath = '/add-account';
const updateBalancesPath = '/update-balances';
const accountPath = '/account';

String kindLabel(AppLocalizations s, AccountKind kind) => switch (kind) {
  AccountKind.debit => s.kindDebit,
  AccountKind.cash => s.kindCash,
  AccountKind.savings => s.kindSavings,
  AccountKind.deposit => s.kindDeposit,
  AccountKind.creditCard => s.kindCreditCard,
  AccountKind.loan => s.kindLoan,
};

IconData kindIcon(AccountKind kind) => switch (kind) {
  AccountKind.debit => CupertinoIcons.creditcard,
  AccountKind.cash => CupertinoIcons.money_rubl,
  AccountKind.savings => CupertinoIcons.tray_arrow_down_fill,
  AccountKind.deposit => CupertinoIcons.lock_fill,
  AccountKind.creditCard => CupertinoIcons.creditcard_fill,
  AccountKind.loan => CupertinoIcons.building_2_fill,
};

Color kindColor(Palette p, AccountKind kind) => switch (kind) {
  AccountKind.debit || AccountKind.cash => p.accent,
  AccountKind.savings || AccountKind.deposit => p.gold,
  AccountKind.creditCard || AccountKind.loan => p.negative,
};

/// Days since the last confirmed balance (null — never confirmed).
int? daysSince(DateTime? updated, DateTime now) {
  if (updated == null) return null;
  final a = DateTime(now.year, now.month, now.day);
  final local = updated.toLocal();
  return a.difference(DateTime(local.year, local.month, local.day)).inDays;
}

String freshnessLabel(AppLocalizations s, DateTime? updated, DateTime now) {
  final days = daysSince(updated, now);
  if (days == null) return '';
  if (days <= 0) return s.updatedToday;
  if (days == 1) return s.updatedYesterday;
  return s.updatedDaysAgo(days);
}

/// «Счета»: totals, quick actions, accounts grouped as money / savings /
/// debts.
class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});
  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  String? _banner;

  Future<void> _openUpdate() async {
    final s = AppLocalizations.of(context);
    final result = await context.push<BalanceUpdateResult>(updateBalancesPath);
    if (result == null || !mounted) return;
    final amount = result.unexplained.minorUnits;
    setState(() {
      _banner = amount < 0
          ? s.updateResultExpenses(formatMoney(-result.unexplained))
          : amount > 0
          ? s.updateResultIncome(formatMoney(result.unexplained))
          : s.updateResultNone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final accounts = ref.watch(accountsProvider);
    return AppPage(
      key: const ValueKey('screen.accounts'),
      title: s.accounts,
      trailing: CupertinoButton(
        key: const ValueKey('accounts.add'),
        padding: EdgeInsets.zero,
        onPressed: ready ? () => context.push<void>(addAccountPath) : null,
        child: Semantics(
          label: s.addAccount,
          button: true,
          child: const ExcludeSemantics(
            child: Icon(CupertinoIcons.add_circled_solid, size: 28),
          ),
        ),
      ),
      children: [
        if (!ready)
          const StorageNotice(showDiagnostics: false)
        else
          switch (accounts) {
            AsyncData(:final value) when value.isEmpty => const _Empty(),
            AsyncData(:final value) => _AccountsBody(
              accounts: value,
              banner: _banner,
              onUpdate: _openUpdate,
            ),
            AsyncError() => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountsLoadFailed, style: AppText.body(p.text)),
                  const SizedBox(height: Space.m),
                  PillButton(
                    label: s.retry,
                    onPressed: () => ref.invalidate(accountsProvider),
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

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    return AppCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        children: [
          IconBadge(icon: CupertinoIcons.creditcard, color: p.accent, size: 56),
          const SizedBox(height: Space.l),
          Semantics(
            header: true,
            child: Text(
              s.accountsEmptyTitle,
              textAlign: TextAlign.center,
              style: AppText.title(p.text),
            ),
          ),
          const SizedBox(height: Space.s),
          Text(
            s.accountsEmptyHint,
            textAlign: TextAlign.center,
            style: AppText.secondary(p.textSecondary),
          ),
          const SizedBox(height: Space.l),
          PillButton(
            key: const ValueKey('accounts.addFirst'),
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

class _AccountsBody extends StatelessWidget {
  const _AccountsBody({
    required this.accounts,
    required this.banner,
    required this.onUpdate,
  });
  final List<AccountSummary> accounts;
  final String? banner;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final totals = AccountTotals(accounts);
    final now = DateTime.now();
    final money = accounts
        .where((a) => !a.kind.isLiability && !a.isProtected)
        .toList();
    final saved = accounts
        .where((a) => !a.kind.isLiability && a.isProtected)
        .toList();
    final debts = accounts.where((a) => a.kind.isLiability).toList();

    Widget group(String title, List<AccountSummary> list) {
      if (list.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title),
          CardGroup(
            children: [for (final a in list) AccountTile(account: a, now: now)],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.totalOwnMoney, style: AppText.secondary(p.textSecondary)),
              const SizedBox(height: Space.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: MoneyText(
                  totals.ownMoney,
                  key: const ValueKey('total.own'),
                  size: 32,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Space.m),
              Row(
                children: [
                  Expanded(
                    child: _MiniTotal(
                      label: s.groupSavings,
                      amount: totals.savings,
                      amountKey: const ValueKey('total.savings'),
                    ),
                  ),
                  Expanded(
                    child: _MiniTotal(
                      label: s.groupDebts,
                      amount: totals.debts,
                      amountKey: const ValueKey('total.debts'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.m),
              Wrap(
                spacing: Space.s,
                runSpacing: Space.s,
                children: [
                  PillButton(
                    key: const ValueKey('accounts.update'),
                    label: s.updateBalances,
                    icon: CupertinoIcons.arrow_clockwise,
                    filled: true,
                    onPressed: onUpdate,
                  ),
                  PillButton(
                    key: const ValueKey('accounts.addInline'),
                    label: s.addShort,
                    icon: CupertinoIcons.add,
                    onPressed: () => context.push<void>(addAccountPath),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (banner != null)
          Padding(
            padding: const EdgeInsets.only(top: Space.m),
            child: Semantics(
              liveRegion: true,
              child: AppCard(
                color: p.accentSoft,
                child: Text(
                  banner!,
                  key: const ValueKey('accounts.banner'),
                  style: AppText.secondary(p.text),
                ),
              ),
            ),
          ),
        group(s.groupMoney, money),
        group(s.groupSavings, saved),
        group(s.groupDebts, debts),
      ],
    );
  }
}

class _MiniTotal extends StatelessWidget {
  const _MiniTotal({
    required this.label,
    required this.amount,
    required this.amountKey,
  });
  final String label;
  final Money amount;
  final Key amountKey;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.caption(p.textSecondary)),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MoneyText(amount, key: amountKey, size: 17),
        ),
      ],
    );
  }
}

/// One account row: kind icon, name (wraps), details (wrap), amount.
class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.account, required this.now});
  final AccountSummary account;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final a = account;
    final days = daysSince(a.lastUpdatedAt, now);
    final stale = days != null && days > 3;
    final details = [
      kindLabel(s, a.kind),
      if (a.creditLimit case final limit?)
        s.creditLimitValue(formatMoney(limit)),
    ].join(' · ');
    return GestureDetector(
      key: ValueKey('account.${a.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push<void>(accountPath, extra: a.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconBadge(icon: kindIcon(a.kind), color: kindColor(p, a.kind)),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.name, style: AppText.body(p.text)),
                  const SizedBox(height: 2),
                  Text(details, style: AppText.caption(p.textSecondary)),
                  const SizedBox(height: 2),
                  Wrap(
                    spacing: Space.s,
                    runSpacing: 2,
                    children: [
                      if (a.lastUpdatedAt != null)
                        Text(
                          freshnessLabel(s, a.lastUpdatedAt, now),
                          style: AppText.caption(
                            stale ? p.warning : p.textTertiary,
                          ),
                        ),
                      if (a.isProtected && !a.kind.isLiability)
                        Text(
                          s.notIncluded,
                          style: AppText.caption(p.textTertiary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Space.s),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.38,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: MoneyText(a.amount, size: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom-of-form save area and error, shared by the account forms.
Widget _errorText(BuildContext context, String? error) => error == null
    ? const SizedBox.shrink()
    : Padding(
        padding: const EdgeInsets.only(top: Space.s),
        child: Text(
          error,
          style: AppText.secondary(Palette.of(context).negative),
        ),
      );

CupertinoNavigationBar _formBar(
  BuildContext context, {
  required String title,
  required Key saveKey,
  required VoidCallback? onSave,
}) {
  final p = Palette.of(context);
  return CupertinoNavigationBar(
    middle: BarText(title),
    backgroundColor: p.background,
    border: null,
    trailing: CupertinoButton(
      key: saveKey,
      padding: EdgeInsets.zero,
      onPressed: onSave,
      child: BarText(
        AppLocalizations.of(context).save,
        style: AppText.headline(onSave == null ? p.textTertiary : p.accent),
      ),
    ),
  );
}

Widget _textField(
  BuildContext context, {
  required String fieldKey,
  required TextEditingController controller,
  String? placeholder,
  bool money = false,
  bool signed = false,
}) {
  final p = Palette.of(context);
  return CupertinoTextField(
    key: ValueKey(fieldKey),
    controller: controller,
    placeholder: placeholder,
    padding: const EdgeInsets.all(Space.m),
    decoration: fieldDecoration(context),
    style: money ? AppText.amount(p.text, size: 19) : AppText.body(p.text),
    keyboardType: money
        ? TextInputType.numberWithOptions(decimal: true, signed: signed)
        : TextInputType.text,
    autocorrect: !money,
    suffix: money
        ? Padding(
            padding: const EdgeInsets.only(right: Space.m),
            child: Text('₽', style: AppText.body(p.textSecondary)),
          )
        : null,
  );
}

/// New account. Amounts are entered as people see them in the bank app:
/// money on the account, or the current debt for cards and loans.
class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});
  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  AccountKind _kind = AccountKind.debit;
  bool _protected = false;
  bool _saving = false;
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _limit = TextEditingController();
  String? _nameError;
  String? _amountError;
  String? _limitError;
  String? _saveError;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _limit.dispose();
    super.dispose();
  }

  Money? _parse(String text) {
    final value = parseMoneyInput(text);
    if (value != null && value.minorUnits < 0) {
      throw const FormatException('negative');
    }
    return value;
  }

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    Money? amount;
    Money? limit;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? s.nameRequired : null;
      _amountError = null;
      _limitError = null;
      _saveError = null;
      try {
        amount = _parse(_amount.text) ?? Money(0);
      } on Object {
        _amountError = s.invalidAmount;
      }
      if (_kind == AccountKind.creditCard) {
        try {
          limit = _parse(_limit.text);
        } on Object {
          _limitError = s.invalidAmount;
        }
      }
    });
    if (_nameError != null || _amountError != null || _limitError != null) {
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(accountsProvider.notifier)
          .create(
            NewAccount(
              kind: _kind,
              name: _name.text.trim(),
              amount: amount!,
              isProtected: _protected,
              creditLimit: limit,
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final amountLabel = switch (_kind) {
      AccountKind.creditCard => s.fieldAmountCard,
      AccountKind.loan => s.fieldAmountLoan,
      _ => s.fieldAmountAsset,
    };
    return CupertinoPageScaffold(
      key: const ValueKey('screen.addAccount'),
      backgroundColor: p.background,
      navigationBar: _formBar(
        context,
        title: s.addAccount,
        saveKey: const ValueKey('addAccount.save'),
        onSave: _saving ? null : () => unawaited(_save()),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Space.xs, bottom: Space.xs),
              child: Text(
                s.accountKind,
                style: AppText.caption(p.textSecondary),
              ),
            ),
            Wrap(
              spacing: Space.s,
              runSpacing: Space.s,
              children: [
                for (final kind in AccountKind.values)
                  _KindChip(
                    key: ValueKey('kind.${kind.name}'),
                    kind: kind,
                    selected: _kind == kind,
                    onTap: () => setState(() {
                      _kind = kind;
                      _protected = kind.protectedByDefault;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: Space.l),
            FormFieldCard(
              label: s.fieldName,
              error: _nameError,
              child: _textField(
                context,
                fieldKey: 'addAccount.name',
                controller: _name,
                placeholder: kindLabel(s, _kind),
              ),
            ),
            FormFieldCard(
              label: amountLabel,
              error: _amountError,
              child: _textField(
                context,
                fieldKey: 'addAccount.amount',
                controller: _amount,
                placeholder: '0',
                money: true,
              ),
            ),
            if (_kind == AccountKind.creditCard)
              FormFieldCard(
                label: s.fieldCreditLimit,
                error: _limitError,
                child: _textField(
                  context,
                  fieldKey: 'addAccount.limit',
                  controller: _limit,
                  placeholder: '0',
                  money: true,
                ),
              ),
            if (!_kind.isLiability)
              CardGroup(
                children: [
                  SettingsRow(
                    title: s.protectedLabel,
                    subtitle: s.protectedHint,
                    trailing: CupertinoSwitch(
                      key: const ValueKey('addAccount.protected'),
                      value: _protected,
                      activeTrackColor: p.accent,
                      onChanged: (v) => setState(() => _protected = v),
                    ),
                  ),
                ],
              ),
            _errorText(context, _saveError),
          ],
        ),
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    super.key,
    required this.kind,
    required this.selected,
    required this.onTap,
  });
  final AccountKind kind;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final s = AppLocalizations.of(context);
    final color = kindColor(p, kind);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.16) : p.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? color : p.separator,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(kindIcon(kind), size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(kindLabel(s, kind), style: AppText.secondary(p.text)),
            ),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(CupertinoIcons.checkmark_alt, size: 15, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

/// One screen with every account: type the amount from the bank app or tap
/// «Не изменилось». Empty fields are left untouched.
class UpdateBalancesScreen extends ConsumerStatefulWidget {
  const UpdateBalancesScreen({super.key, this.onlyAccountId});

  /// When opened from an account screen — only that account.
  final String? onlyAccountId;
  @override
  ConsumerState<UpdateBalancesScreen> createState() =>
      _UpdateBalancesScreenState();
}

class _UpdateBalancesScreenState extends ConsumerState<UpdateBalancesScreen> {
  final _controllers = <String, TextEditingController>{};
  final _errors = <String>{};
  bool _saving = false;
  String? _saveError;

  TextEditingController _controllerFor(String id) =>
      _controllers.putIfAbsent(id, TextEditingController.new);

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    final amounts = <String, Money>{};
    _errors.clear();
    for (final e in _controllers.entries) {
      try {
        final value = parseMoneyInput(e.value.text);
        if (value != null) amounts[e.key] = value;
      } on Object {
        _errors.add(e.key);
      }
    }
    setState(() => _saveError = null);
    if (_errors.isNotEmpty || amounts.isEmpty) return;
    setState(() => _saving = true);
    try {
      final result = await ref
          .read(accountsProvider.notifier)
          .updateBalances(amounts);
      if (mounted) context.pop(result);
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError = s.saveFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final all = ref.watch(accountsProvider).value ?? const <AccountSummary>[];
    final accounts = widget.onlyAccountId == null
        ? all
        : all.where((a) => a.id == widget.onlyAccountId).toList();
    final now = DateTime.now();
    return CupertinoPageScaffold(
      key: const ValueKey('screen.updateBalances'),
      backgroundColor: p.background,
      navigationBar: _formBar(
        context,
        title: s.updateBalances,
        saveKey: const ValueKey('updateBalances.save'),
        onSave: _saving ? null : () => unawaited(_save()),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            Text(s.updateHint, style: AppText.secondary(p.textSecondary)),
            const SizedBox(height: Space.l),
            for (final a in accounts)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.m),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconBadge(
                            icon: kindIcon(a.kind),
                            color: kindColor(p, a.kind),
                            size: 30,
                          ),
                          const SizedBox(width: Space.m),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.name, style: AppText.headline(p.text)),
                                Text(
                                  [
                                    if (a.kind.isLiability) s.groupDebts,
                                    s.currentAmount(formatMoney(a.amount)),
                                    freshnessLabel(s, a.lastUpdatedAt, now),
                                  ].where((t) => t.isNotEmpty).join(' · '),
                                  style: AppText.caption(p.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Space.m),
                      LayoutBuilder(
                        builder: (context, box) {
                          final field = CupertinoTextField(
                            key: ValueKey('balance.${a.id}'),
                            controller: _controllerFor(a.id),
                            placeholder: moneyInputText(a.amount),
                            padding: const EdgeInsets.all(Space.m),
                            decoration: BoxDecoration(
                              color: p.surface2,
                              borderRadius: BorderRadius.circular(
                                Space.radiusSmall,
                              ),
                            ),
                            style: AppText.amount(p.text, size: 19),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            autocorrect: false,
                          );
                          final button = PillButton(
                            key: ValueKey('unchanged.${a.id}'),
                            label: s.unchanged,
                            onPressed: () => setState(
                              () => _controllerFor(a.id).text = moneyInputText(
                                a.amount,
                              ),
                            ),
                          );
                          final narrow =
                              box.maxWidth < 300 ||
                              MediaQuery.textScalerOf(context).scale(10) > 15;
                          return narrow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    field,
                                    const SizedBox(height: Space.s),
                                    button,
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(child: field),
                                    const SizedBox(width: Space.s),
                                    button,
                                  ],
                                );
                        },
                      ),
                      if (_errors.contains(a.id))
                        Padding(
                          padding: const EdgeInsets.only(top: Space.xs),
                          child: Text(
                            s.invalidAmount,
                            style: AppText.caption(p.negative),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            _errorText(context, _saveError),
          ],
        ),
      ),
    );
  }
}

/// One account: what it is, how much, settings and edits.
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key, required this.accountId});
  final String accountId;
  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _name = TextEditingController();
  final _limit = TextEditingController();
  bool _editing = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    super.dispose();
  }

  void _startEdit(AccountSummary a) => setState(() {
    _editing = true;
    _error = null;
    _name.text = a.name;
    _limit.text = a.creditLimit == null ? '' : moneyInputText(a.creditLimit!);
  });

  Future<void> _saveEdit(AccountSummary a) async {
    final s = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty) {
      setState(() => _error = s.nameRequired);
      return;
    }
    Money? limit;
    try {
      limit = a.kind == AccountKind.creditCard
          ? parseMoneyInput(_limit.text)
          : null;
      if (limit != null && limit.minorUnits < 0) throw const FormatException();
    } on Object {
      setState(() => _error = s.invalidAmount);
      return;
    }
    try {
      await ref
          .read(accountsProvider.notifier)
          .updateDetails(a.id, _name.text.trim(), limit);
      if (mounted) setState(() => _editing = false);
    } on Object {
      if (mounted) setState(() => _error = s.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final list = ref.watch(accountsProvider).value ?? const <AccountSummary>[];
    final a = list.where((x) => x.id == widget.accountId).firstOrNull;
    if (a == null) {
      return CupertinoPageScaffold(
        key: const ValueKey('screen.account'),
        backgroundColor: p.background,
        child: const SizedBox.shrink(),
      );
    }
    final now = DateTime.now();
    return AppPage(
      key: const ValueKey('screen.account'),
      title: a.name,
      heroTag: 'nav.account',
      trailing: CupertinoButton(
        key: const ValueKey('account.edit'),
        padding: EdgeInsets.zero,
        onPressed: _editing
            ? () => unawaited(_saveEdit(a))
            : () => _startEdit(a),
        child: Text(
          _editing ? s.save : s.accountEdit,
          style: AppText.headline(p.accent),
        ),
      ),
      children: [
        AppCard(
          child: Row(
            children: [
              IconBadge(
                icon: kindIcon(a.kind),
                color: kindColor(p, a.kind),
                size: 48,
              ),
              const SizedBox(width: Space.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.kind.isLiability
                          ? '${kindLabel(s, a.kind)} · ${s.debtLabel}'
                          : kindLabel(s, a.kind),
                      style: AppText.secondary(p.textSecondary),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: MoneyText(
                        a.amount,
                        size: 28,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (a.lastUpdatedAt != null)
                      Text(
                        freshnessLabel(s, a.lastUpdatedAt, now),
                        style: AppText.caption(p.textTertiary),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.m),
        Align(
          alignment: Alignment.centerLeft,
          child: PillButton(
            key: const ValueKey('account.updateBalance'),
            label: s.updateThisBalance,
            icon: CupertinoIcons.arrow_clockwise,
            onPressed: () => context.push<BalanceUpdateResult>(
              '$updateBalancesPath?account=${a.id}',
            ),
          ),
        ),
        if (_editing) ...[
          const SizedBox(height: Space.l),
          FormFieldCard(
            label: s.fieldName,
            child: _textField(
              context,
              fieldKey: 'account.name',
              controller: _name,
            ),
          ),
          if (a.kind == AccountKind.creditCard)
            FormFieldCard(
              label: s.fieldCreditLimit,
              child: _textField(
                context,
                fieldKey: 'account.limit',
                controller: _limit,
                money: true,
              ),
            ),
          _errorText(context, _error),
        ] else if (a.creditLimit case final limit?) ...[
          SectionHeader(s.creditLimitTitle),
          CardGroup(
            children: [
              SettingsRow(title: s.creditLimitTitle, value: formatMoney(limit)),
              SettingsRow(
                title: s.creditAvailable,
                value: formatMoney(
                  (limit - a.amount).minorUnits < 0
                      ? Money(0)
                      : limit - a.amount,
                ),
              ),
            ],
          ),
        ],
        if (!a.kind.isLiability) ...[
          SectionHeader(s.includedInForecast),
          CardGroup(
            children: [
              SettingsRow(
                title: s.includedInForecast,
                subtitle: s.includedHint,
                trailing: CupertinoSwitch(
                  key: const ValueKey('account.included'),
                  value: !a.isProtected,
                  activeTrackColor: p.accent,
                  onChanged: (v) => unawaited(
                    ref.read(accountsProvider.notifier).setIncluded(a.id, v),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
