import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/preferences.dart';
import '../l10n/generated/app_localizations.dart';
import '../features/payments/reminders_controller.dart';
import 'controller.dart';
import 'router.dart';

class DenezhnoApp extends ConsumerStatefulWidget {
  const DenezhnoApp({super.key});
  @override
  ConsumerState<DenezhnoApp> createState() => _DenezhnoAppState();
}

class _DenezhnoAppState extends ConsumerState<DenezhnoApp> {
  late final AppLifecycleListener _lifecycle;
  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () =>
          unawaited(ref.read(appControllerProvider.notifier).suspend()),
      onResume: () =>
          unawaited(ref.read(appControllerProvider.notifier).resume()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(appControllerProvider.notifier).resume());
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appControllerProvider.select((s) => s.theme));
    // Keeps pending payment reminders in sync while the app runs, without
    // rebuilding the whole app when they change.
    ref.listen(remindersProvider, (_, _) {});
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: CupertinoThemeData(
        brightness: switch (theme) {
          AppTheme.system => null,
          AppTheme.light => Brightness.light,
          AppTheme.dark => Brightness.dark,
        },
        primaryColor: CupertinoColors.activeBlue,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
