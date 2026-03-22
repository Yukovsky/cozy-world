/// Исключение сетевого запроса в data-слое.
class RequestException implements Exception {
  String? message;

  /// Создает исключение с дополнительным текстом [message].
  RequestException([this.message]);

  @override
  String toString() {
    return message ?? '';
  }
}
