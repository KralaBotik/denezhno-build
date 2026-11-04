import 'dart:convert';
import 'dart:io' show gzip;
import 'dart:typed_data';

import 'package:sodium/sodium_sumo.dart';

/// Portable encrypted backup container, format version 1.
///
/// Layout (all integers big-endian):
///
///     magic         8  "DENEZHNO"
///     format        2  container version (1)
///     kdf           1  2 = Argon2id v1.3 (libsodium crypto_pwhash)
///     opsLimit      4
///     memLimit      4  bytes
///     salt         16  random
///     nonce        24  random, XChaCha20-Poly1305-IETF
///     ciphertext    …  AEAD(gzip(UTF-8 JSON payload)), header = associated data
///
/// The whole header is authenticated: changing any byte (including the
/// version or KDF parameters) makes decryption fail. Nothing is written to
/// disk by this code; callers get bytes.
const backupMagic = 'DENEZHNO';
const backupFormatVersion = 1;
const kdfArgon2id = 2;
const _headerLength = 8 + 2 + 1 + 4 + 4 + 16 + 24;

/// Default work factors: libsodium «moderate» passes with the «interactive»
/// memory size (64 MiB), safe for older iPhones.
const defaultOpsLimit = 3;
const defaultMemLimit = 64 * 1024 * 1024;

/// Bounds accepted when reading a file, so a crafted file cannot make the
/// phone allocate gigabytes or spin for minutes.
const _maxOpsLimit = 10;
const _minMemLimit = 8 * 1024 * 1024;
const _maxMemLimit = 256 * 1024 * 1024;

/// Minimum password length for a new backup.
const minBackupPasswordLength = 8;

sealed class BackupError implements Exception {
  const BackupError();
}

/// Not a «Денежно» backup at all.
final class NotABackup extends BackupError {
  const NotABackup();
}

/// A container or payload version this app does not understand.
final class UnsupportedBackupVersion extends BackupError {
  const UnsupportedBackupVersion();
}

/// Wrong password or damaged file (authenticated encryption cannot tell
/// them apart, by design).
final class WrongPasswordOrDamaged extends BackupError {
  const WrongPasswordOrDamaged();
}

/// Decrypted fine, but data is missing or inconsistent.
final class IncompleteBackup extends BackupError {
  const IncompleteBackup();
}

/// The target is not empty (MVP restores only into an empty app).
final class RestoreTargetNotEmpty extends BackupError {
  const RestoreTargetNotEmpty();
}

final class WeakPassword extends BackupError {
  const WeakPassword();
}

SodiumSumo? _sodium;
SodiumSumo get _lib {
  final cached = _sodium;
  if (cached != null) return cached;
  // Synchronous on native platforms (FFI); the web variant is not supported.
  final init = SodiumSumoInit.init();
  if (init is! SodiumSumo) throw StateError('libsodium unavailable');
  return _sodium = init;
}

Uint8List _header({
  required int opsLimit,
  required int memLimit,
  required Uint8List salt,
  required Uint8List nonce,
  int format = backupFormatVersion,
  int kdf = kdfArgon2id,
}) {
  final b = BytesBuilder();
  b.add(ascii.encode(backupMagic));
  b.add((ByteData(2)..setUint16(0, format)).buffer.asUint8List());
  b.addByte(kdf);
  b.add((ByteData(4)..setUint32(0, opsLimit)).buffer.asUint8List());
  b.add((ByteData(4)..setUint32(0, memLimit)).buffer.asUint8List());
  b.add(salt);
  b.add(nonce);
  return b.toBytes();
}

SecureKey _deriveKey(String password, Uint8List salt, int ops, int mem) {
  final pw = Int8List.fromList(utf8.encode(password));
  try {
    return _lib.crypto.pwhash.callRaw(
      outLen: _lib.crypto.aeadXChaCha20Poly1305IETF.keyBytes,
      password: pw,
      salt: salt,
      opsLimit: ops,
      memLimit: mem,
      alg: CryptoPwhashAlgorithm.argon2id13,
    );
  } finally {
    pw.fillRange(0, pw.length, 0);
  }
}

/// Encrypts [payload] (already-serialized JSON) with [password].
Uint8List encryptBackup(
  Uint8List payload,
  String password, {
  int opsLimit = defaultOpsLimit,
  int memLimit = defaultMemLimit,
  int format = backupFormatVersion,
}) {
  if (password.length < minBackupPasswordLength) throw const WeakPassword();
  final aead = _lib.crypto.aeadXChaCha20Poly1305IETF;
  final salt = _lib.randombytes.buf(16);
  final nonce = _lib.randombytes.buf(aead.nonceBytes);
  final header = _header(
    opsLimit: opsLimit,
    memLimit: memLimit,
    salt: salt,
    nonce: nonce,
    format: format,
  );
  final key = _deriveKey(password, salt, opsLimit, memLimit);
  try {
    final compressed = Uint8List.fromList(gzip.encode(payload));
    final cipher = aead.encrypt(
      message: compressed,
      nonce: nonce,
      key: key,
      additionalData: header,
    );
    compressed.fillRange(0, compressed.length, 0);
    return (BytesBuilder()
          ..add(header)
          ..add(cipher))
        .toBytes();
  } finally {
    key.dispose();
  }
}

/// Checks the container and returns the decrypted payload bytes.
Uint8List decryptBackup(Uint8List file, String password) {
  final aead = _lib.crypto.aeadXChaCha20Poly1305IETF;
  if (file.length < 8 ||
      ascii.decode(file.sublist(0, 8), allowInvalid: true) != backupMagic) {
    throw const NotABackup();
  }
  if (file.length < _headerLength + aead.aBytes) {
    throw const WrongPasswordOrDamaged();
  }
  final view = ByteData.sublistView(file);
  final format = view.getUint16(8);
  final kdf = view.getUint8(10);
  if (format != backupFormatVersion || kdf != kdfArgon2id) {
    throw const UnsupportedBackupVersion();
  }
  final ops = view.getUint32(11);
  final mem = view.getUint32(15);
  if (ops < 1 ||
      ops > _maxOpsLimit ||
      mem < _minMemLimit ||
      mem > _maxMemLimit) {
    throw const WrongPasswordOrDamaged();
  }
  final salt = Uint8List.sublistView(file, 19, 35);
  final nonce = Uint8List.sublistView(file, 35, _headerLength);
  final header = Uint8List.sublistView(file, 0, _headerLength);
  final key = _deriveKey(password, salt, ops, mem);
  try {
    final compressed = aead.decrypt(
      cipherText: Uint8List.sublistView(file, _headerLength),
      nonce: nonce,
      key: key,
      additionalData: header,
    );
    try {
      return Uint8List.fromList(gzip.decode(compressed));
    } on Object {
      throw const WrongPasswordOrDamaged();
    }
  } on SodiumException {
    throw const WrongPasswordOrDamaged();
  } finally {
    key.dispose();
  }
}
