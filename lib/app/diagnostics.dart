import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kProfileMode;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/security/storage_diagnostic.dart';
import '../l10n/generated/app_localizations.dart';
import 'controller.dart';

/// First line of every report; also lets CI confirm the feature is in the IPA.
const diagnosticsMarker = 'DENEZHNO-DIAGNOSTICS-V1';
const appVersionLabel = '0.3.0+3';

/// Final defence for text that leaves the app through the screen or clipboard.
/// Sources are already allowlisted (fixed stage names, type names, numeric
/// codes); this additionally strips anything that could carry a key, an
/// absolute path or free text.
String sanitizeDiagnostic(String text) {
  // '<', '>' and '!' are the stage-trace markers (enter / ok / failed); '+' is
  // part of the version label. None of them can carry a key, path or text.
  var out = text.replaceAll(RegExp(r'[^A-Za-z0-9 _.:;=,()+<>!\-/\n]'), '');
  out = out.replaceAll(RegExp(r'[0-9A-Fa-f]{24,}'), '[hex]');
  out = out.replaceAllMapped(
    RegExp(r'(^|[\s=:;(])/[A-Za-z_.~][^\s;,)]*'),
    (m) => '${m[1]}[path]',
  );
  return out;
}

String _buildMode() =>
    kDebugMode ? 'debug' : (kProfileMode ? 'profile' : 'release');

/// Plain-text report: versions, storage state, allowlisted failure
/// descriptions and the recent stage trace. No keys, paths, SQL or user data.
String buildDiagnosticReport({
  required StorageStatus status,
  String? failure,
  String? lastFailure,
  String? trace,
  String? platform,
  String? buildMode,
  DateTime? now,
}) {
  final lines = <String>[
    diagnosticsMarker,
    'app: $appVersionLabel ${buildMode ?? _buildMode()}',
    'platform: ${platform ?? '${Platform.operatingSystem} ${Platform.operatingSystemVersion}'}',
    'utc: ${(now ?? DateTime.now()).toUtc().toIso8601String()}',
    'storage: ${status.name}',
    'failure: ${failure ?? 'none'}',
    if (lastFailure != null && lastFailure != failure)
      'earlier failure in this launch: $lastFailure',
    'stages: ${trace ?? storageStageTrace()}',
  ];
  return sanitizeDiagnostic(lines.join('\n'));
}

/// Builds the report for the current app state.
final diagnosticReportProvider = Provider.autoDispose<String>((ref) {
  final state = ref.watch(appControllerProvider);
  final last = ref.watch(lastStorageFailureProvider);
  return buildDiagnosticReport(
    status: state.storage,
    failure: state.diagnostic,
    lastFailure: last,
  );
});

/// Report text with a "copy" button. Shown on the storage-error screen and in
/// Settings. Nothing is written to disk; nothing is deleted or recreated here.
class DiagnosticsPanel extends ConsumerStatefulWidget {
  const DiagnosticsPanel({super.key});
  @override
  ConsumerState<DiagnosticsPanel> createState() => _DiagnosticsPanelState();
}

enum _CopyResult { none, copied, failed }

class _DiagnosticsPanelState extends ConsumerState<DiagnosticsPanel> {
  _CopyResult _result = _CopyResult.none;

  Future<void> _copy(String report) async {
    try {
      await Clipboard.setData(ClipboardData(text: report));
      if (mounted) setState(() => _result = _CopyResult.copied);
    } catch (_) {
      if (mounted) setState(() => _result = _CopyResult.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final report = ref.watch(diagnosticReportProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.diagnosticsHint,
          style: TextStyle(
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          key: const ValueKey('diagnostics.report'),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemFill.resolveFrom(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            report,
            style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
          ),
        ),
        CupertinoButton(
          key: const ValueKey('diagnostics.copy'),
          padding: const EdgeInsets.symmetric(vertical: 12),
          onPressed: () => unawaited(_copy(report)),
          child: Text(s.copyDiagnostics),
        ),
        if (_result != _CopyResult.none)
          Semantics(
            liveRegion: true,
            child: Text(
              key: const ValueKey('diagnostics.copyResult'),
              _result == _CopyResult.copied
                  ? s.diagnosticsCopied
                  : s.diagnosticsCopyFailed,
            ),
          ),
      ],
    );
  }
}
