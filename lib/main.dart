import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'features/backup/backup_section.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Leftover encrypted backup files from an interrupted share (best effort,
  // before any new share can start).
  unawaited(cleanupStaleShareFiles());
  runApp(const ProviderScope(child: DenezhnoApp()));
}
