import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/money/money.dart';
import '../core/money/money_text.dart';
import '../features/forecast/forecast_controller.dart';
import '../features/settings/preferences.dart';
import '../l10n/generated/app_localizations.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'controller.dart';
import 'diagnostics.dart';

/// Bottom tabs. «Операции» and «Прогноз» return when those features exist;
/// the forecast lives on Главная (see docs/design-system.md).
enum AppSection {
  home('/', CupertinoIcons.house_fill),
  accounts('/accounts', CupertinoIcons.creditcard_fill),
  payments('/payments', CupertinoIcons.calendar);

  const AppSection(this.path, this.icon);
  final String path;
  final IconData icon;
  String title(AppLocalizations s) => switch (this) {
    home => s.home,
    accounts => s.accounts,
    payments => s.payments,
  };
}

const settingsPath = '/settings';
const reservePath = '/reserve';
const backupPath = '/backup';
const developerPath = '/developer';

/// Storage state for the person. Shown only when something is not right
/// (opening, closed, error); with diagnostics on the error screen.
class StorageNotice extends ConsumerWidget {
  const StorageNotice({super.key, this.showDiagnostics = true});

  /// On the error screen the diagnostics are shown right under the message.
  final bool showDiagnostics;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appControllerProvider.select((s) => s.storage));
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final error = status == StorageStatus.unavailable;
    return Semantics(
      liveRegion: true,
      child: AppCard(
        color: error ? p.negativeSoft : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(switch (status) {
              StorageStatus.opening => s.storageOpening,
              StorageStatus.ready => s.storageReady,
              StorageStatus.paused => s.storagePaused,
              StorageStatus.unavailable => s.storageError,
              StorageStatus.upgradeRequired => s.storageUpgrade,
            }, style: AppText.body(p.text)),
            if (error)
              Padding(
                padding: const EdgeInsets.only(top: Space.m),
                child: PillButton(
                  label: s.retry,
                  filled: true,
                  onPressed: () => unawaited(
                    ref.read(appControllerProvider.notifier).resume(),
                  ),
                ),
              ),
            if (error && showDiagnostics) ...[
              const SizedBox(height: Space.m),
              const DiagnosticsPanel(),
            ],
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
    final p = Palette.of(context);
    final theme = ref.watch(appControllerProvider.select((s) => s.theme));
    final status = ref.watch(appControllerProvider.select((s) => s.storage));
    final ready = status == StorageStatus.ready;
    final reserve = ref.watch(reserveProvider).value;
    final labels = {
      AppTheme.system: s.themeAuto,
      AppTheme.light: s.themeLightShort,
      AppTheme.dark: s.themeDarkShort,
    };
    return AppPage(
      key: const ValueKey('screen.settings'),
      title: s.settings,
      children: [
        if (!ready) const StorageNotice(showDiagnostics: false),
        SectionHeader(s.appearance),
        AppCard(
          child: SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<AppTheme>(
              groupValue: theme,
              onValueChanged: (v) {
                if (v != null && ready) {
                  unawaited(
                    ref.read(appControllerProvider.notifier).setTheme(v),
                  );
                }
              },
              children: {
                for (final e in labels.entries)
                  e.key: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      e.value,
                      key: ValueKey('theme.${e.key.name}'),
                      style: AppText.secondary(p.text),
                    ),
                  ),
              },
            ),
          ),
        ),
        SectionHeader(s.settingsFinance),
        CardGroup(
          children: [
            SettingsRow(
              key: const ValueKey('reserve.edit'),
              icon: CupertinoIcons.shield_lefthalf_fill,
              title: s.reserveTitle,
              value: reserve == null ? null : formatMoney(reserve),
              onTap: ready ? () => context.push<void>(reservePath) : null,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xs, Space.s, Space.xs, 0),
          child: Text(s.reserveHint, style: AppText.caption(p.textTertiary)),
        ),
        SectionHeader(s.settingsData),
        CardGroup(
          children: [
            SettingsRow(
              key: const ValueKey('settings.backup'),
              icon: CupertinoIcons.lock_shield_fill,
              title: s.backupTitle,
              subtitle: s.backupRowHint,
              onTap: () => context.push<void>(backupPath),
            ),
          ],
        ),
        SectionHeader(s.settingsAbout),
        CardGroup(
          children: [
            SettingsRow(
              title: s.versionLabel,
              value: '${appVersionLabel.replaceAll('+', ' (')})',
            ),
            SettingsRow(
              key: const ValueKey('settings.developer'),
              icon: CupertinoIcons.wrench_fill,
              iconColor: p.textSecondary,
              title: s.developerTitle,
              onTap: () => context.push<void>(developerPath),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xs, Space.l, Space.xs, 0),
          child: Text(
            s.syncUnavailable,
            style: AppText.caption(p.textTertiary),
          ),
        ),
      ],
    );
  }
}

/// The reserve kept out of «можно потратить».
class ReserveScreen extends ConsumerStatefulWidget {
  const ReserveScreen({super.key});
  @override
  ConsumerState<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends ConsumerState<ReserveScreen> {
  late final TextEditingController _field = TextEditingController(
    text: switch (ref.read(reserveProvider).value) {
      final Money m => moneyInputText(m),
      null => '',
    },
  );
  String? _error;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppLocalizations.of(context);
    Money? value;
    try {
      value = parseMoneyInput(_field.text) ?? Money(0);
      if (value.minorUnits < 0) value = null;
    } on Object {
      value = null;
    }
    if (value == null) {
      setState(() => _error = s.invalidAmount);
      return;
    }
    try {
      await ref.read(reserveProvider.notifier).set(value);
      if (mounted) context.pop();
    } on Object {
      if (mounted) setState(() => _error = s.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    return CupertinoPageScaffold(
      key: const ValueKey('screen.reserve'),
      backgroundColor: p.background,
      navigationBar: CupertinoNavigationBar(
        middle: BarText(s.reserveTitle),
        backgroundColor: p.background,
        border: null,
        trailing: CupertinoButton(
          key: const ValueKey('reserve.save'),
          padding: EdgeInsets.zero,
          onPressed: () => unawaited(_save()),
          child: BarText(s.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            FormFieldCard(
              label: s.fieldAmount,
              error: _error,
              child: CupertinoTextField(
                key: const ValueKey('reserve.field'),
                controller: _field,
                padding: const EdgeInsets.all(Space.m),
                decoration: fieldDecoration(context),
                style: AppText.amount(p.text, size: 22),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                suffix: Padding(
                  padding: const EdgeInsets.only(right: Space.m),
                  child: Text('₽', style: AppText.body(p.textSecondary)),
                ),
              ),
            ),
            Text(s.reserveExplain, style: AppText.secondary(p.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// Technical diagnostics, kept away from everyday settings.
class DeveloperScreen extends ConsumerWidget {
  const DeveloperScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    return AppPage(
      key: const ValueKey('screen.developer'),
      title: s.developerTitle,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Space.m),
          child: Text(
            s.developerHint,
            style: AppText.secondary(p.textSecondary),
          ),
        ),
        const StorageNotice(showDiagnostics: false),
        const SizedBox(height: Space.m),
        const AppCard(child: DiagnosticsPanel()),
      ],
    );
  }
}
