import 'package:ferry/ferry.dart';

/// Контракт жизненного цикла GraphQL-клиента и доступа к нему.
abstract class IConnectionService {
  bool get isReady;

  IConnectionService();

  /// Инициализация клиента при старте приложения
  Future<void> initClient();

  /// Пересоздать клиент (когда обновляются конфиги)
  Future<void> reinitClient();

  /// Получить сущность клиента
  Client get getClient;

  void clearCache();
}
