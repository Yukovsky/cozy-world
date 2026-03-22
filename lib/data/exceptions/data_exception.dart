/// Исключение обращения к неизвестному идентификатору сущности.
class UnknownIdException implements Exception {
  String? message;

  /// Создает исключение с дополнительным текстом [message].
  UnknownIdException([this.message]);

  @override
  String toString() {
    return message ?? '';
  }
}
