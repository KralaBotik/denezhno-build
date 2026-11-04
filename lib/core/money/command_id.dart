/// Persistent identity of a logical command, never an amount/date fingerprint.
/// The writer must persist this ID before retrying an operation (R2).
final class CommandId {
  factory CommandId(String value) {
    if (!RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    ).hasMatch(value)) {
      throw ArgumentError('Expected a canonical UUID');
    }
    return CommandId._(value);
  }
  const CommandId._(this.value);
  final String value;
  @override
  bool operator ==(Object other) => other is CommandId && value == other.value;
  @override
  int get hashCode => value.hashCode;
}
