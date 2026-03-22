import 'package:cozy_world/domain/entities/category.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';

/// Контракт источника данных для экрана поддержки.
abstract class ISupportRepository {
  /// Сообщение дня с учетом стратегии обновления [fetchPolicy].
  Future<Result<TodayMessage, QueryFailure>> getTodayMessage(
    RefreshStrategy fetchPolicy,
  );

  /// Сообщения категории [category] со статусом [readStatus].
  Future<Result<List<CategoryMessage>, QueryFailure>> getCategoryMessages(
    RefreshStrategy fetchPolicy,
    String category,
    bool readStatus,
  );

  /// Список категорий поддержки с учетом [fetchPolicy].
  Future<Result<List<Category>, QueryFailure>> getCategories(
    RefreshStrategy fetchPolicy,
  );

  /// Результат изменения статуса чтения сообщения [messageId].
  Future<Result<int, QueryFailure>> changeReadStatus(
    int messageId,
    bool readStatus,
    String category,
  );
}
