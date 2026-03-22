/// Контракт локализованных строк для data-слоя и сетевых ошибок.
abstract class DataStringsRepository {
  /// Сообщение о неинициализированном GraphQL-клиенте.
  String get graphQlClientNotInitialized;

  /// Сообщение о не заданных API-учетных данных.
  String get apiCredentialsNotConfigured;

  /// Префикс блока с дополнительной информацией.
  String get moreInfoPrefix;

  /// Префикс ошибки конфигурации учетных данных.
  String get credentialsExceptionPrefix;

  // Ошибки запросов

  /// Префикс ошибки выполнения запроса.
  String get requestErrorPrefix;

  /// Префикс ошибки неизвестного идентификатора.
  String get unknownIdPrefix;

  String get changeReadStatusRequestError;

  String get changeReadStatusRequestTimeout;

  String get categoriesRequestError;

  String get categoriesDataIsNull;

  String get categoryMessagesRequestError;

  String get categoryMessagesDataIsNull;

  String get todayMessageRequestError;

  String get todayMessageDataIsNull;

  /// Сообщение об отсутствии сущности с заданным [id].
  String idNotFound(String id);
}
