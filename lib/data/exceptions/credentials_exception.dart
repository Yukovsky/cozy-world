/// Исключение ошибки конфигурации учетных данных подключения.
class CredentialsException implements Exception {
  final String? message;

  /// Создает исключение с дополнительным текстом [message].
  CredentialsException([this.message]);

  @override
  String toString() {
    return message ?? '';
  }
}
