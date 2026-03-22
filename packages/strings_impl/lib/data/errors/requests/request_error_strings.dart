/// Request and API error messages (public)
abstract class PublicRequestErrorStrings {
  /// Message formatting
  static const String requestErrorPrefix = 'Запрос завершился ошибкой.';
  static const String unknownIdPrefix = 'Неизвестный id.';
  static const String moreInfoPrefix = 'Больше информации тут: ';

  /// Request error messages
  static const String changeReadStatusRequestError =
      'Запрос на изменение статуса сообщение завершился ошибкой.';
  static const String changeReadStatusRequestTimeout =
      'Таймаут при запроса на измениние статуса сообщения. Ответ сервера занял слишком много времени.';
  static const String categoriesRequestError =
      'Запрос на получение категорий завершился ошибкой.';
  static const String categoriesDataIsNull =
      'Данные о категориях невалидны или же коллекция пуста';
  static const String categoryMessagesRequestError =
      'Запрос на получение сообщений по категориям завершился ошибкой.';
  static const String categoryMessagesDataIsNull =
      'Данные о сообщениях по категориям невалидны или же коллекция сообщений пуста';
  static const String todayMessageRequestError =
      'Запрос на получение сегодняшнего сообщения завершился ошибкой.';
  static const String todayMessageDataIsNull =
      'Данные о сегодняшнем сообщении невалидны';

  /// Helper method for formatting not-found errors
  static String idNotFound(String id) => 'ID "$id" не было найдено';
}
