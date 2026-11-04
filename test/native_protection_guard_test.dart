import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Swift cannot run in Linux, so this is a SOURCE-LEVEL guard, not a behavioural
/// test: it fails if the owner-approved simulator-only exception in
/// ios/Runner/AppDelegate.swift is widened or the strict device check is removed.
/// Real behaviour is covered by the iOS Simulator CI job (exception path) and by
/// the still-pending on-device run (strict path).
void main() {
  final source = File('ios/Runner/AppDelegate.swift').readAsStringSync();

  test('simulator exception exists once, only for an absent attribute', () {
    final assignments = RegExp(r'let simulatorWithoutProtection = (.+)')
        .allMatches(source)
        .map((m) => m.group(1)!.trim())
        .toList();
    expect(assignments, ['raw == nil', 'false']);
    expect(source, contains('#if targetEnvironment(simulator)'));
    expect(
      RegExp(r'#if targetEnvironment\(simulator\)').allMatches(source).length,
      1,
    );
  });
  test('device branch is false and the strict comparison stays', () {
    final match = RegExp(
      r'#if targetEnvironment\(simulator\)\n(.*?)#else\n(.*?)#endif',
      dotAll: true,
    ).firstMatch(source)!;
    expect(match.group(1), contains('raw == nil'));
    expect(match.group(2)!.trim(), 'let simulatorWithoutProtection = false');
    expect(
      source,
      contains('raw as? String == FileProtectionType.complete.rawValue'),
    );
    // The exception is a disjunction in the guard, never a bypass of it.
    expect(source, contains('guard simulatorWithoutProtection\n'));
  });
  test('protection is still requested and backup exclusion still required', () {
    expect(source, contains('[.protectionKey: FileProtectionType.complete]'));
    expect(source, contains('isExcludedFromBackup == true'));
    expect(source, contains('isProtectedDataAvailable'));
  });
  test('privacy cover stays opaque (no blur or transparency)', () {
    final scene = File('ios/Runner/SceneDelegate.swift').readAsStringSync();
    expect(scene, contains('cover.backgroundColor = .systemBackground'));
    expect(scene, contains('sceneWillResignActive'));
    expect(scene, isNot(contains('UIVisualEffectView')));
    expect(scene, isNot(contains('UIBlurEffect')));
    expect(scene, isNot(contains('alpha')));
    expect(scene, isNot(contains('.clear')));
  });
}
