import 'package:dates_api/dates_api.dart';

/// Публичная реализация [IDatesDatasource] с фиксированными датами для демонстрационного режима.
class HardcodedDatesDataSource implements IDatesDatasource {
  @override
  /// Набор хардкод-дат по ключам отношений.
  Future<Map<String, DateTime>> fetchDates() async {
    DateTime relationshipDate = DateTime(2025, 01, 14, 10, 30).toUtc();
    DateTime acquaintanceshipDate = DateTime(2025, 01, 01, 22, 34).toUtc();
    return {
      'relationship': relationshipDate,
      'acquaintance': acquaintanceshipDate,
    };
  }
}
