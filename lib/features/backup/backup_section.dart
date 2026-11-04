import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/controller.dart';
import '../../core/backup/backup_crypto.dart';
import '../../core/calendar_date.dart';
import '../../l10n/generated/app_localizations.dart';
import '../accounts/accounts_controller.dart';
import '../forecast/forecast_controller.dart';
import '../payments/payments_controller.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

/// Moving the encrypted file in and out of the app. Only ciphertext ever
/// touches the file system (a temporary file deleted right after sharing).
abstract interface class BackupIo {
  Future<void> share(Uint8List encrypted, String fileName);
  Future<Uint8List?> pick();
}

/// Prefix of the temporary folders that hold an encrypted backup while the
/// share sheet is open.
const shareTempPrefix = 'denezhno-share-';

/// Deletes backup files left behind when the app was closed or killed while
/// a share was in progress. Called once at launch, before any share can
/// start. Also clears share_plus's own cache copy (Android keeps one until
/// the next share). Only ciphertext can be found there; errors are ignored.
Future<int> cleanupStaleShareFiles({Directory? temp, Directory? cache}) async {
  var removed = 0;
  final root = temp ?? Directory.systemTemp;
  try {
    await for (final e in root.list(followLinks: false)) {
      final name = e.uri.pathSegments.where((p) => p.isNotEmpty).last;
      if (e is Directory && name.startsWith(shareTempPrefix)) {
        await e.delete(recursive: true);
        removed++;
      }
    }
    final plugin = Directory('${(cache ?? root.parent).path}/share_plus');
    if (cache != null && await plugin.exists()) {
      await plugin.delete(recursive: true);
      removed++;
    }
  } on Object {
    // Best effort: a leftover file is encrypted and is retried next launch.
  }
  return removed;
}

/// Writes [encrypted] to a fresh temporary folder, waits for [present] (the
/// share sheet) to finish, then deletes the folder — also on errors.
Future<void> shareThrough(
  Uint8List encrypted,
  String fileName,
  Future<Object?> Function(File file) present,
) async {
  final dir = await Directory.systemTemp.createTemp(shareTempPrefix);
  try {
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(encrypted, flush: true);
    await present(file);
  } finally {
    await dir.delete(recursive: true);
  }
}

final class SystemBackupIo implements BackupIo {
  /// The temporary file is deleted only after share() completes: on iOS the
  /// plugin completes from UIActivityViewController's completion handler,
  /// i.e. after «Сохранить в Файлы», AirDrop or the target app's extension
  /// finished (or the sheet was cancelled). On Android share_plus copies the
  /// file into its own cache first, so deleting ours is safe there too.
  /// If the app dies meanwhile, [cleanupStaleShareFiles] removes it at the
  /// next launch.
  @override
  Future<void> share(Uint8List encrypted, String fileName) => shareThrough(
    encrypted,
    fileName,
    (file) => SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/octet-stream')],
      ),
    ),
  );

  @override
  Future<Uint8List?> pick() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'backup', uniformTypeIdentifiers: ['public.data']),
      ],
    );
    return file?.readAsBytes();
  }
}

final backupIoProvider = Provider<BackupIo>((ref) => SystemBackupIo());

/// Whether the app is still empty (restore is allowed only then).
final canRestoreProvider = FutureProvider.autoDispose<bool>((ref) async {
  final ready = ref.watch(
    appControllerProvider.select((s) => s.storage == StorageStatus.ready),
  );
  ref.watch(accountsProvider);
  if (!ready) return false;
  return ref.read(backupStoreProvider).canRestore();
});

class BackupSection extends ConsumerStatefulWidget {
  const BackupSection({super.key});
  @override
  ConsumerState<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends ConsumerState<BackupSection> {
  bool _busy = false;
  String? _message;
  bool _error = false;

  void _say(String text, {bool error = false}) => setState(() {
    _message = text;
    _error = error;
  });

  Future<String?> _askPassword({required bool create}) async {
    final s = AppLocalizations.of(context);
    final first = TextEditingController();
    final second = TextEditingController();
    String? problem;
    final result = await showCupertinoDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => CupertinoAlertDialog(
          title: Text(create ? s.backupCreate : s.restoreEnterPassword),
          content: Column(
            children: [
              if (create)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(s.backupPasswordWarning),
                ),
              CupertinoTextField(
                key: const ValueKey('backup.password'),
                controller: first,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                placeholder: create ? s.backupPassword : s.restoreEnterPassword,
              ),
              if (create) ...[
                const SizedBox(height: 8),
                CupertinoTextField(
                  key: const ValueKey('backup.password2'),
                  controller: second,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  placeholder: s.backupPasswordRepeat,
                ),
              ],
              if (problem != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    problem!,
                    style: const TextStyle(color: CupertinoColors.systemRed),
                  ),
                ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.cancel),
            ),
            CupertinoDialogAction(
              key: const ValueKey('backup.ok'),
              isDefaultAction: true,
              onPressed: () {
                if (create && first.text.length < minBackupPasswordLength) {
                  setLocal(() => problem = s.backupPasswordShort);
                } else if (create && first.text != second.text) {
                  setLocal(() => problem = s.backupPasswordsDiffer);
                } else if (first.text.isNotEmpty) {
                  Navigator.of(ctx).pop(first.text);
                }
              },
              child: Text(s.save),
            ),
          ],
        ),
      ),
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> _create() async {
    final s = AppLocalizations.of(context);
    final password = await _askPassword(create: true);
    if (password == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final bytes = await ref.read(backupStoreProvider).exportBackup(password);
      await ref
          .read(backupIoProvider)
          .share(bytes, 'Denezhno-${CalendarDate.today().iso}.dnzb');
      _say(s.backupCreated);
    } on Object {
      _say(s.backupFailed, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final s = AppLocalizations.of(context);
    final Uint8List? file;
    try {
      file = await ref.read(backupIoProvider).pick();
    } on Object {
      _say(s.restoreFailed, error: true);
      return;
    }
    if (file == null || !mounted) return;
    final password = await _askPassword(create: false);
    if (password == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(backupStoreProvider).restoreBackup(file, password);
      // Reload everything from the restored database, including the theme.
      final app = ref.read(appControllerProvider.notifier);
      await app.suspend();
      await app.resume();
      ref
        ..invalidate(accountsProvider)
        ..invalidate(paymentsProvider)
        ..invalidate(reserveProvider)
        ..invalidate(canRestoreProvider);
      _say(s.restoreDone);
    } on BackupError catch (e) {
      _say(switch (e) {
        WrongPasswordOrDamaged() => s.restoreWrongPassword,
        NotABackup() => s.restoreNotBackup,
        UnsupportedBackupVersion() => s.restoreUnsupported,
        IncompleteBackup() => s.restoreIncomplete,
        RestoreTargetNotEmpty() => s.restoreOnlyEmpty,
        WeakPassword() => s.restoreWrongPassword,
      }, error: true);
    } on Object {
      _say(s.restoreFailed, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final p = Palette.of(context);
    final ready = ref.watch(
      appControllerProvider.select((st) => st.storage == StorageStatus.ready),
    );
    final canRestore = ref.watch(canRestoreProvider).value ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon: CupertinoIcons.lock_shield_fill, color: p.accent),
              const SizedBox(width: Space.m),
              Expanded(
                child: Text(s.backupHint, style: AppText.secondary(p.text)),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.l),
        CardGroup(
          children: [
            SettingsRow(
              key: const ValueKey('backup.create'),
              icon: CupertinoIcons.square_arrow_up,
              title: s.backupCreate,
              onTap: ready && !_busy ? () => unawaited(_create()) : null,
            ),
            SettingsRow(
              key: const ValueKey('backup.restore'),
              icon: CupertinoIcons.arrow_down_doc,
              iconColor: canRestore ? p.accent : p.textTertiary,
              title: s.backupRestore,
              subtitle: canRestore ? null : s.restoreOnlyEmpty,
              onTap: ready && canRestore && !_busy
                  ? () => unawaited(_restore())
                  : null,
            ),
          ],
        ),
        if (_busy)
          Padding(
            padding: const EdgeInsets.only(top: Space.l),
            child: Row(
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(width: Space.s),
                Text(s.working, style: AppText.secondary(p.textSecondary)),
              ],
            ),
          ),
        if (_message != null)
          Padding(
            padding: const EdgeInsets.only(top: Space.l),
            child: Semantics(
              liveRegion: true,
              child: AppCard(
                color: _error ? p.negativeSoft : p.accentSoft,
                child: Text(
                  _message!,
                  key: const ValueKey('backup.message'),
                  style: AppText.secondary(_error ? p.negative : p.text),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// «Резервная копия»: create and restore, on its own page.
class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    key: const ValueKey('screen.backup'),
    title: AppLocalizations.of(context).backupTitle,
    children: const [BackupSection()],
  );
}
