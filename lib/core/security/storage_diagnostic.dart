// Experimental import is deliberate: only the remote cause type is read, as in database tests.
// ignore: experimental_member_use
import 'package:drift/remote.dart' show DriftRemoteException;
import 'package:flutter/services.dart' show PlatformException;
import 'package:sqlite3/sqlite3.dart' show SqliteException;

/// Sanitized diagnostics for storage-open failures.
///
/// Records WHERE a failure happened and its type, never WHAT it contained: no
/// exception messages, paths, SQL, keys or user data. Only fixed stage names
/// written in this codebase, runtime type names, numeric SQLite/Keychain codes
/// and short native stage labels matching [_safe] are ever emitted. The original
/// exception is rethrown unchanged, so callers keep failing closed.
final _stages = Expando<String>('storageStage');
final _trace = <String>[];
void _note(String entry) {
  _trace.add(entry);
  if (_trace.length > 80) _trace.removeAt(0);
}

/// Recent stage transitions (`>enter`, `<ok`, `!failed`), fixed names only.
/// Lets a test report WHERE an operation hung instead of waiting for a timeout.
String storageStageTrace() => _trace.join(' ');

final _safe = RegExp(r'^[A-Za-z0-9_.:;=\- ]{1,96}$');

/// Runs [action]; if it throws, tags the exception with [stage] (the innermost
/// stage wins) and rethrows the same object.
Future<T> storageStage<T>(String stage, Future<T> Function() action) async {
  _note('>$stage');
  try {
    final result = await action();
    _note('<$stage');
    return result;
  } catch (error) {
    _note('!$stage');
    if (error is! String && error is! num && error is! bool) {
      _stages[error] ??= stage;
    }
    rethrow;
  }
}

/// One-line, allowlisted description such as
/// `stage=keychain.write type=PlatformException code=Unexpected security result code detail=-34018`.
String describeStorageFailure(Object error) {
  final parts = <String>[];
  if (error is! String && error is! num && error is! bool) {
    final stage = _stages[error];
    if (stage != null) parts.add('stage=$stage');
  }
  parts.add('type=${error.runtimeType}');
  if (error is PlatformException) {
    if (_safe.hasMatch(error.code)) parts.add('code=${error.code}');
    final details = error.details;
    if (details is int || (details is String && _safe.hasMatch(details))) {
      parts.add('detail=$details');
    }
  } else if (error is DriftRemoteException) {
    final cause = error.remoteCause;
    parts.add('remote=${cause.runtimeType}');
    if (cause is SqliteException) {
      parts.add('sqlite=${cause.resultCode}/${cause.extendedResultCode}');
    }
  } else if (error is SqliteException) {
    parts.add('sqlite=${error.resultCode}/${error.extendedResultCode}');
  }
  return parts.join(' ');
}
