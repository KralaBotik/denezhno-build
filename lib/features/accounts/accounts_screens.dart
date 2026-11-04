import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/controller.dart';
import '../../app/screens.dart' show StorageNotice;
import '../../core/money/money.dart';
import '../../core/money/money_text.dart';
import '../../l10n/generated/app_localizations.dart';
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

String freshnessLabel(AppLocalizations s, DateTime? updated, DateTime now) {
  if (updated == null) return '';
  final a = DateTime(now.year, now.month, now.day);
  final local = updated.toLocal();
  final b = DateTime(local.year, local.month, local.day);
  final days = a.difference(b).inDays;
  if (days <= 0) return s.updatedToday;
  if (days == 1) return s.updatedYesterday;
  return s.updatedDaysAgo(days);
}

Color _secondary(BuildContext context) =>
    CupertinoColors.secondaryLabel.resolveFrom(context);

/// «Счета» tab: totals, accounts grouped as money / savings / debts, and the
/// main action «Обновить остатки».
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
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final accounts = ref.watch(accountsProvider);
    return CupertinoPageScaffold(
      key: const ValueKey('screen.accounts'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(s.accounts),
        leading: CupertinoButton(
          key: const ValueKey('accounts.add'),
          padding: EdgeInsets.zero,
          onPressed: ready ? () => context.push<void>(addAccountPath) : null,
          child: Semantics(
            label: s.addAccount,
            button: true,
            child: const ExcludeSemantics(child: Icon(CupertinoIcons.add)),
          ),
        ),
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
                children: [
                  Text(s.accountsStorageClosed),
                  const SizedBox(height: 16),
                  const StorageNotice(),
                ],
              )
            : switch (accounts) {
                AsyncData(:final value) when value.isEmpty => _Empty(),
                AsyncData(:final value) => _AccountsList(
                  accounts: value,
                  banner: _banner,
                  onUpdate: _openUpdate,
                ),
                AsyncError() => ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(s.accountsLoadFailed),
                    CupertinoButton(
                      onPressed: () => ref.invalidate(accountsProvider),
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

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 32),
        const ExcludeSemantics(
          child: Icon(
            CupertinoIcons.creditcard,
            size: 52,
            color: CupertinoColors.activeBlue,
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            s.accountsEmptyTitle,
            textAlign: TextAlign.center,
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
        ),
        const SizedBox(height: 12),
        Text(s.accountsEmptyHint, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        CupertinoButton.filled(
          key: const ValueKey('accounts.addFirst'),
          onPressed: () => context.push<void>(addAccountPath),
          child: Text(s.addAccount),
        ),
      ],
    );
  }
}

class _AccountsList extends StatelessWidget {
  const _AccountsList({
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
    final totals = AccountTotals(accounts);
    final now = DateTime.now();
    Widget group(String title, Iterable<AccountSummary> items) {
      final list = items.toList();
      if (list.isEmpty) return const SizedBox.shrink();
      return CupertinoListSection.insetGrouped(
        header: Text(title),
        children: [
          for (final a in list)
            CupertinoListTile(
              key: ValueKey('account.${a.id}'),
              title: Text(a.name),
              subtitle: Text(
                [
                  kindLabel(s, a.kind),
                  if (a.creditLimit case final limit?)
                    s.creditLimitValue(formatMoney(limit)),
                  if (a.isProtected && !a.kind.isLiability) s.notIncluded,
                  freshnessLabel(s, a.lastUpdatedAt, now),
                ].where((t) => t.isNotEmpty).join(' · '),
              ),
              additionalInfo: Text(formatMoney(a.amount)),
              trailing: const CupertinoListTileChevron(),
              onTap: () => context.push<void>(accountPath, extra: a.id),
            ),
        ],
      );
    }

    return ListView(
      children: [
        if (banner != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Semantics(
              liveRegion: true,
              child: Text(
                banner!,
                key: const ValueKey('accounts.banner'),
                style: TextStyle(color: _secondary(context)),
              ),
            ),
          ),
        CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile(
              title: Text(s.totalOwnMoney),
              additionalInfo: Text(
                formatMoney(totals.ownMoney),
                key: const ValueKey('total.own'),
              ),
            ),
            if (totals.savings.minorUnits != 0)
              CupertinoListTile(
                title: Text(s.groupSavings),
                additionalInfo: Text(
                  formatMoney(totals.savings),
                  key: const ValueKey('total.savings'),
                ),
              ),
            if (totals.debts.minorUnits != 0)
              CupertinoListTile(
                title: Text(s.groupDebts),
                additionalInfo: Text(
                  formatMoney(totals.debts),
                  key: const ValueKey('total.debts'),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CupertinoButton.filled(
            key: const ValueKey('accounts.update'),
            onPressed: onUpdate,
            child: Text(s.updateBalances),
          ),
        ),
        group(
          s.groupMoney,
          accounts.where((a) => !a.kind.isLiability && !a.isProtected),
        ),
        group(
          s.groupSavings,
          accounts.where((a) => !a.kind.isLiability && a.isProtected),
        ),
        group(s.groupDebts, accounts.where((a) => a.kind.isLiability)),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Form for a new account. Amounts are entered as people see them in the
/// bank app: money on the account, or the current debt for cards and loans.
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

  Money? _parse(String text, {required bool required}) {
    final value = parseMoneyInput(text);
    if (value == null && required) throw const FormatException('empty');
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
        amount = _parse(_amount.text, required: false) ?? Money(0);
      } on Object {
        _amountError = s.invalidAmount;
      }
      if (_kind == AccountKind.creditCard) {
        try {
          limit = _parse(_limit.text, required: false);
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
    final amountLabel = switch (_kind) {
      AccountKind.creditCard => s.fieldAmountCard,
      AccountKind.loan => s.fieldAmountLoan,
      _ => s.fieldAmountAsset,
    };
    Widget error(String? text) => text == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text(
              text,
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
          );
    return CupertinoPageScaffold(
      key: const ValueKey('screen.addAccount'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(s.addAccount),
        trailing: CupertinoButton(
          key: const ValueKey('addAccount.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: Text(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text(s.accountKind),
              children: [
                for (final kind in AccountKind.values)
                  CupertinoListTile(
                    key: ValueKey('kind.${kind.name}'),
                    title: Text(kindLabel(s, kind)),
                    trailing: _kind == kind
                        ? const Icon(CupertinoIcons.check_mark, size: 20)
                        : null,
                    onTap: () => setState(() {
                      _kind = kind;
                      _protected = kind.protectedByDefault;
                    }),
                  ),
              ],
            ),
            _Field(
              fieldKey: 'addAccount.name',
              label: s.fieldName,
              controller: _name,
              placeholder: kindLabel(s, _kind),
            ),
            error(_nameError),
            _Field(
              fieldKey: 'addAccount.amount',
              label: amountLabel,
              controller: _amount,
              placeholder: '0',
              numeric: true,
            ),
            error(_amountError),
            if (_kind == AccountKind.creditCard) ...[
              _Field(
                fieldKey: 'addAccount.limit',
                label: s.fieldCreditLimit,
                controller: _limit,
                placeholder: '0',
                numeric: true,
              ),
              error(_limitError),
            ],
            if (!_kind.isLiability)
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    title: Text(s.protectedLabel),
                    subtitle: Text(s.protectedHint, maxLines: 2),
                    trailing: CupertinoSwitch(
                      key: const ValueKey('addAccount.protected'),
                      value: _protected,
                      onChanged: (v) => setState(() => _protected = v),
                    ),
                  ),
                ],
              ),
            error(_saveError),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.placeholder,
    this.numeric = false,
  });
  final String fieldKey;
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final bool numeric;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: _secondary(context))),
        const SizedBox(height: 6),
        CupertinoTextField(
          key: ValueKey(fieldKey),
          controller: controller,
          placeholder: placeholder,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          autocorrect: !numeric,
        ),
      ],
    ),
  );
}

/// One screen with every account: type the amount from the bank app or tap
/// «Не изменилось». Empty fields are left untouched.
class UpdateBalancesScreen extends ConsumerStatefulWidget {
  const UpdateBalancesScreen({super.key});
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
    final accounts = ref.watch(accountsProvider).value ?? const [];
    return CupertinoPageScaffold(
      key: const ValueKey('screen.updateBalances'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(s.updateBalances),
        trailing: CupertinoButton(
          key: const ValueKey('updateBalances.save'),
          padding: EdgeInsets.zero,
          onPressed: _saving ? null : () => unawaited(_save()),
          child: Text(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                s.updateHint,
                style: TextStyle(color: _secondary(context)),
              ),
            ),
            for (final a in accounts)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.name),
                    Text(
                      '${a.kind.isLiability ? '${s.groupDebts}: ' : ''}'
                      '${s.currentAmount(formatMoney(a.amount))}',
                      style: TextStyle(color: _secondary(context)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            key: ValueKey('balance.${a.id}'),
                            controller: _controllerFor(a.id),
                            placeholder: moneyInputText(a.amount),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            autocorrect: false,
                          ),
                        ),
                        CupertinoButton(
                          key: ValueKey('unchanged.${a.id}'),
                          padding: const EdgeInsets.only(left: 12),
                          onPressed: () => setState(
                            () => _controllerFor(a.id).text = moneyInputText(
                              a.amount,
                            ),
                          ),
                          child: Text(s.unchanged),
                        ),
                      ],
                    ),
                    if (_errors.contains(a.id))
                      Text(
                        s.invalidAmount,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                  ],
                ),
              ),
            if (_saveError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  _saveError!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// One account: what it is, how much, and whether it counts in the forecast.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key, required this.accountId});
  final String accountId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final list = ref.watch(accountsProvider).value ?? const <AccountSummary>[];
    final a = list.where((x) => x.id == accountId).firstOrNull;
    return CupertinoPageScaffold(
      key: const ValueKey('screen.account'),
      navigationBar: CupertinoNavigationBar(middle: Text(a?.name ?? '')),
      child: SafeArea(
        child: a == null
            ? const SizedBox.shrink()
            : ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        title: Text(kindLabel(s, a.kind)),
                        additionalInfo: Text(formatMoney(a.amount)),
                      ),
                      if (a.creditLimit case final limit?)
                        CupertinoListTile(
                          title: Text(s.creditLimitValue(formatMoney(limit))),
                        ),
                      CupertinoListTile(
                        title: Text(
                          freshnessLabel(s, a.lastUpdatedAt, DateTime.now()),
                        ),
                      ),
                    ],
                  ),
                  if (!a.kind.isLiability)
                    CupertinoListSection.insetGrouped(
                      footer: Text(s.includedHint),
                      children: [
                        CupertinoListTile(
                          title: Text(s.includedInForecast, maxLines: 2),
                          trailing: CupertinoSwitch(
                            key: const ValueKey('account.included'),
                            value: !a.isProtected,
                            onChanged: (v) => unawaited(
                              ref
                                  .read(accountsProvider.notifier)
                                  .setIncluded(a.id, v),
                            ),
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
