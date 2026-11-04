import 'dart:io';

/// Short-lived bootstrap result. Never log or persist [keyHex] outside Keychain.
final class StorageLocation {
  const StorageLocation(this.file, this.keyHex, this.verifyProtection);
  final File file;
  final String keyHex;
  final Future<void> Function() verifyProtection;
}
