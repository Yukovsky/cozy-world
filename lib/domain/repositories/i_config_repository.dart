/// Контракт источника конфигурации подключения к API.
abstract class IConfigRepository {
  /// API-ключ клиента.
  Future<String> getApiKey();

  /// URL endpoint для сетевых запросов.
  Future<String> getEndPoint();
}
