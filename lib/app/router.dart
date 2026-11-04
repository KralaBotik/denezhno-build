import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../features/accounts/accounts_screens.dart';
import '../features/forecast/home_screen.dart';
import '../features/payments/payments.dart';
import '../features/payments/payments_screens.dart';
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
                      _ => SectionScreen(section: section),
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
          child: const UpdateBalancesScreen(),
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
        path: '/settings',
        pageBuilder: (context, state) => CupertinoPage<void>(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
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
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(child: shell),
          // Matches CupertinoTabScaffold: compact native tab labels keep their
          // size; screen content keeps the user's full TextScaler/VoiceOver.
          MediaQuery.withNoTextScaling(
            child: CupertinoTabBar(
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
