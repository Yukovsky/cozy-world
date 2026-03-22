/// Область данных, для которой помечается устаревание.
enum DirtyScope { support, category }

/// Событие изменения состояния «грязности» кэша.
class DirtyEvent {
  final String key;
  final DirtyScope scope;

  /// Время фиксации события устаревания.
  final DateTime timeStamp;

  DirtyEvent({required this.key, required this.scope, required this.timeStamp});
}
