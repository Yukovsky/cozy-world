/// Контракт доступа к датам, связанным с историей отношений.
abstract class IRelationshipDatesRepository {
  /// Все известные стартовые даты отношений по ключам.
  Future<Map<String, DateTime>> getStartDates();

  /// Дата по идентификатору [id].
  Future<DateTime> getDateById(String id);
}
