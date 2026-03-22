/// Публичные тексты ошибок и префиксов domain-слоя.
abstract class PublicFailureStrings {
  static const String datesNotSet = 'Даты отношений пока не заданы';
  static const String emptyMessagesReceived =
      'Не удалось получить сообщения: список пуст';
  static const String cannotChangeMessageReadStatus =
      'Не удалось изменить статус прочтения сообщения';

  static const String invalidValuePrefix = 'Передано некорректное значение.';
  static const String moreInfoPrefix = 'Подробнее: ';
}
