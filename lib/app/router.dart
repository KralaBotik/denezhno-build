import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../features/accounts/accounts_screens.dart';
import '../features/forecast/home_screen.dart';
import '../features/payments/payments.dart';
import '../features/payments/payments_screens.dart';
import '../features/backup/backup_section.dart';
import '../features/income/income.dart';
import '../features/income/income_screens.dart';
import '../ui/theme.dart';
import 'screens.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _TabShell(shell),
        branches: [
          for (final section in AppSection.values)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: section.path,
                  pageBuilder: (context, state) => CupertinoPage<void>(
                    key: state.pageKey,
                    child: switch (section) {
                      AppSection.home => const HomeScreen(),
                      AppSection.accounts => const AccountsScreen(),
                      AppSection.payments => const PaymentsScreen(),
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: addAccountPath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: const AddAccountScreen(),
        ),
      ),
      GoRoute(
        path: updateBalancesPath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: UpdateBalancesScreen(
            onlyAccountId: state.uri.queryParameters['account'],
          ),
        ),
      ),
      GoRoute(
        path: accountPath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: AccountScreen(accountId: state.extra! as String),
        ),
      ),
      GoRoute(
        path: flowEditPath,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return CupertinoPage<void>(
            key: state.pageKey,
            child: extra is PlannedFlow
                ? FlowEditScreen(flow: extra, direction: extra.direction)
                : FlowEditScreen(
                    direction: extra is FlowDirection
                        ? extra
                        : FlowDirection.outflow,
                  ),
          );
        },
      ),
      GoRoute(
        path: cardFiguresPath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: CardFiguresScreen(accountId: state.extra! as String),
        ),
      ),
      GoRoute(
        path: incomeSchedulePath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: SalaryScheduleScreen(sourceId: state.extra as String?),
        ),
      ),
      GoRoute(
        path: incomePaymentPath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: IncomePaymentScreen(paymentKey: state.extra! as PaymentKey),
        ),
      ),
      GoRoute(
        path: incomeReceivePath,
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: ReceiveScreen(paymentKey: state.extra! as PaymentKey),
        ),
      ),
      for (final (path, page) in <(String, Widget)>[
        (settingsPath, const SettingsScreen()),
        (reservePath, const ReserveScreen()),
        (backupPath, const BackupScreen()),
        (developerPath, const DeveloperScreen()),
      ])
        GoRoute(
          path: path,
          pageBuilder: (context, state) =>
              CupertinoPage<void>(key: state.pageKey, child: page),
        ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class _TabShell extends StatelessWidget {
  const _TabShell(this.shell);
  final StatefulNavigationShell shell;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final p = Palette.of(context);
    return CupertinoPageScaffold(
      backgroundColor: p.background,
      child: Column(
        children: [
          Expanded(child: shell),
          // Matches CupertinoTabScaffold: compact native tab labels keep their
          // size; screen content keeps the user's full TextScaler/VoiceOver.
          MediaQuery.withNoTextScaling(
            child: CupertinoTabBar(
              backgroundColor: p.surface.withValues(alpha: 0.94),
              activeColor: p.accent,
              inactiveColor: p.textTertiary,
              border: Border(top: BorderSide(color: p.separator, width: 0.5)),
              currentIndex: shell.currentIndex,
              onTap: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              items: [
                for (final section in AppSection.values)
                  BottomNavigationBarItem(
                    icon: Icon(
                      section.icon,
                      key: ValueKey('tab.${section.name}'),
                    ),
                    label: section.title(strings),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
