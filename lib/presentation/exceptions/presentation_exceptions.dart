/// Исключение для неподдерживаемого типа или класса в presentation-слое.
class UnknownClassException implements Exception {
  String? message;

  /// Создает исключение с дополнительным сообщением [message].
  UnknownClassException([this.message]);

  @override
  String toString() => message ?? 'Unknown class';
}
