/// Публичные тексты ошибок валидации domain-значений.
abstract class PublicValidationStrings {
  static const String daysLessThanZero =
      'Количество дней должно быть от 0 и выше';
  static const String hoursOutOfRange =
      'Часы должны быть в диапазоне от 0 до 23';
  static const String minutesOutOfRange =
      'Минуты должны быть в диапазоне от 0 до 59';
  static const String secondsOutOfRange =
      'Секунды должны быть в диапазоне от 0 до 59';
}
