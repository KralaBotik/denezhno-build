import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/sodium.dart';

Uint8List hexBytes(String hex) => Uint8List.fromList([
  for (var i = 0; i < hex.length; i += 2)
    int.parse(hex.substring(i, i + 2), radix: 16),
]);

void main() {
  late Sodium sodium;
  setUpAll(() async {
    sodium = await SodiumInit.init();
  });

  test('Ed25519 matches RFC 8032 section 7.1 test vector 1', () {
    // Public test vector: https://www.rfc-editor.org/rfc/rfc8032#section-7.1
    final seed = sodium.secureCopy(
      hexBytes(
        '9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60',
      ),
    );
    final pair = sodium.crypto.sign.seedKeyPair(seed);
    addTearDown(seed.dispose);
    addTearDown(pair.secretKey.dispose);
    expect(
      pair.publicKey,
      hexBytes(
        'd75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a',
      ),
    );
    final message = Uint8List(0);
    final signature = sodium.crypto.sign.detached(
      message: message,
      secretKey: pair.secretKey,
    );
    expect(
      signature,
      hexBytes(
        'e5564300c360ac729086e2cc806e828a84877f1eb8e5d974d873e065224901555fb8821590a33bacc61e39701cf9b46bd25bf5f0595bbe24655141438e7a100b',
      ),
    );
    expect(
      sodium.crypto.sign.verifyDetached(
        message: message,
        signature: signature,
        publicKey: pair.publicKey,
      ),
      true,
    );
    expect(
      sodium.crypto.sign.verifyDetached(
        message: Uint8List.fromList([1]),
        signature: signature,
        publicKey: pair.publicKey,
      ),
      false,
    );
  });

  test('XChaCha20-Poly1305 roundtrip, tampering and associated data', () {
    final aead = sodium.crypto.aeadXChaCha20Poly1305IETF;
    final key = aead.keygen();
    addTearDown(key.dispose);
    expect(aead.nonceBytes, 24);
    final nonce = sodium.randombytes.buf(aead.nonceBytes);
    final message = Uint8List.fromList([1, 2, 3]);
    final aad = Uint8List.fromList([4, 5]);
    final cipher = aead.encrypt(
      message: message,
      nonce: nonce,
      key: key,
      additionalData: aad,
    );
    expect(
      aead.decrypt(
        cipherText: cipher,
        nonce: nonce,
        key: key,
        additionalData: aad,
      ),
      message,
    );
    expect(
      () => aead.decrypt(
        cipherText: cipher,
        nonce: nonce,
        key: key,
        additionalData: Uint8List.fromList([6]),
      ),
      throwsA(isA<SodiumException>()),
    );
    cipher[0] ^= 1;
    expect(
      () => aead.decrypt(
        cipherText: cipher,
        nonce: nonce,
        key: key,
        additionalData: aad,
      ),
      throwsA(isA<SodiumException>()),
    );
  });

  test('sealed box opens only for the intended recipient', () {
    final box = sodium.crypto.box;
    final recipient = box.keyPair();
    final stranger = box.keyPair();
    addTearDown(recipient.secretKey.dispose);
    addTearDown(stranger.secretKey.dispose);
    final message = Uint8List.fromList([7, 8, 9]);
    final cipher = box.seal(message: message, publicKey: recipient.publicKey);
    expect(
      box.sealOpen(
        cipherText: cipher,
        publicKey: recipient.publicKey,
        secretKey: recipient.secretKey,
      ),
      message,
    );
    expect(
      () => box.sealOpen(
        cipherText: cipher,
        publicKey: stranger.publicKey,
        secretKey: stranger.secretKey,
      ),
      throwsA(isA<SodiumException>()),
    );
  });
}
