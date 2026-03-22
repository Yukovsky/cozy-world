/// Базовый контракт ошибки, возникшей при загрузке или изменении данных.
abstract class QueryFailure {
  String get message;
}

/// Ошибка подключения клиента к источнику данных.
class ClientConnectionFailure implements QueryFailure {
  @override
  final String message;

  ClientConnectionFailure(this.message);
}

/// Ошибка загрузки сообщений.
class MessageLoadFailure implements QueryFailure {
  @override
  final String message;

  MessageLoadFailure(this.message);
}

/// Ошибка пустого результата при ожидаемых сообщениях.
class EmptyMessagesFailure implements QueryFailure {
  @override
  final String message;

  EmptyMessagesFailure(this.message);
}

/// Ошибка изменения статуса сообщения.
class ChangingMessageFailure implements QueryFailure {
  @override
  final String message;

  ChangingMessageFailure(this.message);
}
