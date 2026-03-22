/// Базовый контракт ошибки, связанной с датами отношений.
abstract class DatesFailure {
  String get message;
}

/// Ошибка отсутствия сохраненных дат отношений.
class DatesNotSetFailure implements DatesFailure {
  @override
  final String message;

  DatesNotSetFailure(this.message);
}

/// Ошибка загрузки дат отношений из источника.
class DatesLoadFailure implements DatesFailure {
  @override
  final String message;
  DatesLoadFailure(this.message);
}
