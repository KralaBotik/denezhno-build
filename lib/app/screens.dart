import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/preferences.dart';
import '../l10n/generated/app_localizations.dart';
import 'controller.dart';
import 'diagnostics.dart';
import '../core/money/money.dart';
import '../core/money/money_text.dart';
import '../features/backup/backup_section.dart';
import '../features/forecast/forecast_controller.dart';

enum AppSection {
  home('/', CupertinoIcons.house),
  accounts('/accounts', CupertinoIcons.creditcard),
  transactions('/transactions', CupertinoIcons.list_bullet),
  payments('/payments', CupertinoIcons.calendar),
  forecast('/forecast', CupertinoIcons.chart_bar);

  const AppSection(this.path, this.icon);
  final String path;
  final IconData icon;
  String title(AppLocalizations s) => switch (this) {
    home => s.home,
    accounts => s.accounts,
    transactions => s.transactions,
    payments => s.payments,
    forecast => s.forecast,
  };
  String description(AppLocalizations s) => switch (this) {
    home => s.homeEmpty,
    accounts => s.accountsEmpty,
    transactions => s.transactionsEmpty,
    payments => s.paymentsEmpty,
    forecast => s.forecastEmpty,
  };
}

class SectionScreen extends StatelessWidget {
  const SectionScreen({super.key, required this.section});
  final AppSection section;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      key: ValueKey('screen.${section.name}'),
      navigationBar: CupertinoNavigationBar(
        middle: Text(section == AppSection.home ? s.appName : section.title(s)),
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
        child: CustomScrollView(
          key: PageStorageKey(section.name),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.list(
                children: [
                  const SizedBox(height: 32),
                  ExcludeSemantics(
                    child: Icon(
                      section.icon,
                      size: 52,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    header: true,
                    child: Text(
                      section == AppSection.home ? s.welcome : section.title(s),
                      textAlign: TextAlign.center,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(section.description(s), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    s.notAvailableYet,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel.resolveFrom(
                        context,
                      ),
                    ),
                  ),
                  if (section == AppSection.home) ...[
                    const SizedBox(height: 32),
                    const StorageNotice(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final theme = ref.watch(appControllerProvider.select((s) => s.theme));
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    final labels = [s.themeSystem, s.themeLight, s.themeDark];
    return CupertinoPageScaffold(
      key: const ValueKey('screen.settings'),
      navigationBar: CupertinoNavigationBar(middle: Text(s.settings)),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Semantics(header: true, child: Text(s.appearance)),
            ),
            for (final choice in AppTheme.values)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Semantics(
                  selected: theme == choice,
                  child: CupertinoButton(
                    key: ValueKey('theme.${choice.name}'),
                    onPressed: ready
                        ? () => unawaited(
                            ref
                                .read(appControllerProvider.notifier)
                                .setTheme(choice),
                          )
                        : null,
                    child: Row(
                      children: [
                        Expanded(child: Text(labels[choice.index])),
                        if (theme == choice)
                          const Icon(CupertinoIcons.check_mark, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(header: true, child: Text(s.storage)),
                  const SizedBox(height: 12),
                  const StorageNotice(showDiagnostics: false),
                  const SizedBox(height: 24),
                  const ReserveRow(),
                  const SizedBox(height: 24),
                  const BackupSection(),
                  const SizedBox(height: 24),
                  Semantics(header: true, child: Text(s.diagnostics)),
                  const SizedBox(height: 8),
                  const DiagnosticsPanel(),
                  const SizedBox(height: 24),
                  Text(s.syncUnavailable),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorageNotice extends ConsumerWidget {
  const StorageNotice({super.key, this.showDiagnostics = true});

  /// On the error screen the diagnostics are shown right under the message.
  final bool showDiagnostics;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appControllerProvider.select((s) => s.storage));
    final s = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(switch (status) {
            StorageStatus.opening => s.storageOpening,
            StorageStatus.ready => s.storageReady,
            StorageStatus.paused => s.storagePaused,
            StorageStatus.unavailable => s.storageError,
          }),
          if (status == StorageStatus.unavailable)
            CupertinoButton(
              onPressed: () =>
                  unawaited(ref.read(appControllerProvider.notifier).resume()),
              child: Text(s.retry),
            ),
          if (status == StorageStatus.unavailable && showDiagnostics) ...[
            const SizedBox(height: 8),
            const DiagnosticsPanel(),
          ],
        ],
      ),
    );
  }
}

/// Settings row for the reserve kept out of «можно потратить».
class ReserveRow extends ConsumerWidget {
  const ReserveRow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final reserve = ref.watch(reserveProvider).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(s.reserveTitle)),
        const SizedBox(height: 4),
        Text(
          s.reserveHint,
          style: TextStyle(
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        CupertinoButton(
          key: const ValueKey('reserve.edit'),
          padding: const EdgeInsets.symmetric(vertical: 8),
          onPressed: !ready || reserve == null
              ? null
              : () => unawaited(_edit(context, ref, reserve)),
          child: Text(
            reserve == null ? s.reserveEdit : formatMoney(reserve),
            key: const ValueKey('reserve.value'),
          ),
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Money current) async {
    final s = AppLocalizations.of(context);
    final controller = TextEditingController(text: moneyInputText(current));
    final value = await showCupertinoDialog<Money>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(s.reserveEdit),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            key: const ValueKey('reserve.field'),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.cancel),
          ),
          CupertinoDialogAction(
            key: const ValueKey('reserve.save'),
            isDefaultAction: true,
            onPressed: () {
              try {
                final m = parseMoneyInput(controller.text) ?? Money(0);
                if (m.minorUnits >= 0) Navigator.of(ctx).pop(m);
              } on Object {
                // Invalid input: keep the dialog open.
              }
            },
            child: Text(s.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null) await ref.read(reserveProvider.notifier).set(value);
  }
}
