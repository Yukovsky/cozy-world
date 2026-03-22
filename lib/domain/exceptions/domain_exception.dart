/// Исключение невалидного значения в domain-слое.
class InvalidValueException implements Exception {
  String? message;

  /// Создает исключение с дополнительным сообщением [message].
  InvalidValueException([this.message]);

  @override
  String toString() => message ?? 'Invalid value';
}
