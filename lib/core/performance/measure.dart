import 'dart:developer';

/// Fixed names only. No amounts, SQL, keys, paths or command payloads.
enum MeasuredOperation { storageOpen, settingsWrite }

Future<T> measure<T>(
  MeasuredOperation operation,
  Future<T> Function() work,
) async {
  final task = TimelineTask()..start('denezhno.${operation.name}');
  try {
    return await work();
  } finally {
    task.finish();
  }
}
