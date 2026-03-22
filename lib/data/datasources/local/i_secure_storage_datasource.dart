/// Контракт безопасного хранения конфигурации подключения.
abstract class ISecureStorageDataSource {
  /// Сохраняет API-ключ [apiKey].
  Future<void> setApiKey(String apiKey);

  /// API-ключ, если он ранее был сохранен.
  Future<String?> getApiKey();

  /// Сохраняет URL endpoint [endPoint].
  Future<void> setEndPoint(String endPoint);

  /// URL endpoint, если он ранее был сохранен.
  Future<String?> getEndPoint();
}
