import 'package:cozy_world/domain/constants/dirty_key_constants.dart';

class DirtyKey {
  final String key;
  final bool? readStatus;

  const DirtyKey(this.key, [this.readStatus]);

  /// Сериализует в строковый тег, совместимый с существующей логикой проекта.
  String toTag() => readStatus == null
      ? key
      : '$key${DirtyKeyConstants.readQuery}$readStatus';

  /// Парсит строковый тег обратно в объект.
  static DirtyKey parse(String tag) {
    if (tag.contains(DirtyKeyConstants.readQuery)) {
      final parts = tag.split(DirtyKeyConstants.readQuery);
      final read =
          parts.length > 1 &&
          parts[1].toLowerCase() == DirtyKeyConstants.trueLiteral;
      return DirtyKey(parts[0], read);
    }
    return DirtyKey(tag, null);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DirtyKey &&
            other.key == key &&
            other.readStatus == readStatus);
  }

  @override
  int get hashCode => Object.hash(key, readStatus);
}
