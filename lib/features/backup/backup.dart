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

/// The database on the phone is from an older version and has not been
/// migrated yet: the person is offered a verified backup first.
final class UpgradeRequired implements Exception {
  const UpgradeRequired(this.fromVersion);
  final int fromVersion;
}

/// Before migrating the real database (owner requirement R3).
abstract interface class UpgradeStore {
  /// A complete backup made from the database as it is now (older schema),
  /// already verified: decrypted and checked like a restore would.
  Future<VerifiedBackup> exportBeforeUpgrade(String password);

  /// The person chose to update; the next open migrates (an encrypted copy
  /// of the old database is still kept next to it).
  void allowUpgrade();
}

/// A backup file checked right after it was made.
final class VerifiedBackup {
  const VerifiedBackup(
    this.file, {
    required this.ownAccounts,
    required this.entries,
  });
  final Uint8List file;
  final int ownAccounts;
  final int entries;
}
