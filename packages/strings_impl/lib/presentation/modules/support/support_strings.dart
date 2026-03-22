/// Strings for the Support module (public)
abstract class SupportStrings {
  static const String pageTitle = 'Твоя поддержка';

  static const String todayMessageHeading = 'Послание на сегодня';
  static const String openWhenHeading = 'Открой, когда...';
  static const String readMessagesHeading = 'Уже прочитанные';

  static const String noMessageToday = 'На сегодня сообщение не найдено';
  static const String emptyCategory = 'Здесь пока ничего нет';
  static const String todayMessageLoadError =
      'Не удалось загрузить сегодняшнее сообщение';
  static const String categoriesLoadError =
      'Не удалось загрузить список категорий';
  static const String categoriesEmpty = 'Пока нет доступных категорий';

  static const String markAsRead = 'Отметить как прочитанное';
  static const String removeFromRead = 'Вернуть в непрочитанные';

  static const String dataLoadError = 'Не получилось загрузить данные';

  /// Сообщение ошибки операции с деталями [error].
  static String operationError(String error) => 'Произошла ошибка: $error';

  static const String changeSuccess = 'Статус сообщения успешно обновлен';
  static const String changeSuccessButNotUpdated =
      'Статус изменен, но экран не обновился автоматически';
  static const String changeFailed = 'Не получилось изменить статус сообщения';
}
