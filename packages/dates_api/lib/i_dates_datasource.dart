/// Контракт источника дат отношений.
abstract class IDatesDatasource {
  /// Карта стартовых дат, индексированная доменными ключами.
  Future<Map<String, DateTime>> fetchDates();
}
