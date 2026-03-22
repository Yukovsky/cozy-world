/// Доменные идентификаторы ключевых дат отношений.
abstract class RelationshipIds {
  /// Идентификатор даты начала отношений.
  static const String relationship = "relationship";

  /// Идентификатор даты знакомства.
  static const String acquaintance = "acquaintance";

  /// Полный список поддерживаемых идентификаторов.
  static const List<String> all = [relationship, acquaintance];
}
