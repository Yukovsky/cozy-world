/// Strings for the Counter module (public)
abstract class CounterStrings {
  static const String pageTitle = 'Счетчик';

  static const String daysSinceAcquaintance = 'А ты знаешь, что уже прошло:';
  static const String acquaintanceHeading = 'С НАШЕЙ ПЕРВОЙ ВСТРЕЧИ';
  static const String relationshipHeading = 'С МОМЕНТА, КОГДА МЫ ВМЕСТЕ';
  static const String happyMomentsHeading = 'СЧАСТЛИВЫХ МОМЕНТОВ';

  static const String happyMomentsCaption = 'и впереди еще больше!';
  static const String greeting = 'Привет!';

  static const String datesNotLoaded = 'Не удалось загрузить даты';
  static const String unknownError = 'Произошла неизвестная ошибка';
  static String errorMessage(String error) => 'Ошибка: $error';

  static const String dayUnitsContinuation = ', а еще';
  static const String infinityValue = '∞';
}
