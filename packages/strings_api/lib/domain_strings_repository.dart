/// Контракт строк domain-слоя для валидации и ошибок бизнес-логики.
abstract class DomainStringsRepository {
  /// Текст ошибки, когда количество дней меньше нуля.
  String get daysLessThanZero;

  /// Текст ошибки, когда часы выходят за допустимый диапазон.
  String get hoursOutOfRange;

  /// Текст ошибки, когда минуты выходят за допустимый диапазон.
  String get minutesOutOfRange;

  /// Текст ошибки, когда секунды выходят за допустимый диапазон.
  String get secondsOutOfRange;

  /// Текст ошибки, когда даты отношений не заданы.
  String get datesNotSet;

  /// Текст ошибки, когда сообщения не удалось получить.
  String get emptyMessagesReceived;

  /// Текст ошибки, когда не удалось изменить статус сообщения.
  String get cannotChangeMessageReadStatus;

  /// Префикс сообщения о невалидном значении.
  String get invalidValuePrefix;

  /// Префикс блока с дополнительными деталями.
  String get moreInfoPrefix;

  /// Полный текст ошибки невалидного значения с [details].
  String invalidValueMessage(String? details);
}
