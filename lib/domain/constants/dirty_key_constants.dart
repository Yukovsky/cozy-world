/// Константы сериализации тега `DirtyKey`.
abstract class DirtyKeyConstants {
  /// Часть query-строки для хранения статуса прочтения.
  static const String readQuery = '?read=';

  /// Строковое представление булевого `true`.
  static const String trueLiteral = 'true';

  /// Строковое представление булевого `false`.
  static const String falseLiteral = 'false';
}
