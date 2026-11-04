import 'dart:typed_data';

/// Encrypted, portable backup of all user data (see docs/backup.md).
abstract interface class BackupStore {
  /// Ciphertext of a complete backup protected by [password].
  Future<Uint8List> exportBackup(String password);

  /// Whether this app holds no financial data yet (restore is allowed only
  /// then, in the MVP).
  Future<bool> canRestore();

  /// Restores [file] atomically; throws a BackupError and leaves the
  /// database unchanged on any problem.
  Future<void> restoreBackup(Uint8List file, String password);
}
