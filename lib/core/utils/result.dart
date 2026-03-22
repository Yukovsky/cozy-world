/// Контейнер результата операции: успешное значение или ошибка.
abstract class Result<S, F> {
  const Result();

  /// Обрабатывает результат через [success] или [failure].
  R when<R>({required R Function(S) success, required R Function(F) failure});
}

/// Успешный результат с полезным значением [value].
class Success<S, F> implements Result<S, F> {
  final S value;

  /// Создает успешный результат с [value].
  const Success(this.value);

  @override
  R when<R>({required R Function(S) success, required R Function(F) failure}) =>
      success(value);
}

/// Ошибочный результат с описанием ошибки [error].
class Failure<S, F> implements Result<S, F> {
  final F error;

  /// Создает ошибочный результат с [error].
  const Failure(this.error);

  @override
  R when<R>({required R Function(S) success, required R Function(F) failure}) =>
      failure(error);
}
