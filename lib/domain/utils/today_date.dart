/// Утилита получения текущей даты в формате `YYYY-MM-DD`.
abstract class TodayDateModel {
  /// Текущая дата без времени в формате `YYYY-MM-DD`.
  static String getTodayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).toString().split(" ")[0];
  }
}
