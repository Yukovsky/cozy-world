import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/domain/utils/today_date.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';

/// Use case получения актуального сообщения дня.
class GetTodayMessageUsecase {
  final ISupportRepository _repository;

  GetTodayMessageUsecase(this._repository);

  /// Сообщение дня с учетом [policy] и проверки устаревания кэша.
  Future<Result<TodayMessage, QueryFailure>> call({
    RefreshStrategy? policy,
  }) async {
    final initialResult = await _repository.getTodayMessage(
      RefreshStrategy.refreshWithCache,
    );

    return initialResult.when(
      success: (todayMessage) {
        // If cached message already belongs to today, keep it even for forceRefresh.
        if (todayMessage.date == TodayDateModel.getTodayDate()) {
          return Success(todayMessage);
        }

        // Cached message is stale: fetch fresh data from network.
        return _repository.getTodayMessage(RefreshStrategy.forceRefresh);
      },
      failure: (failure) {
        // If user explicitly requested force refresh, retry from network on cache failure.
        if (policy == RefreshStrategy.forceRefresh) {
          return _repository.getTodayMessage(RefreshStrategy.forceRefresh);
        }

        return Failure(failure);
      },
    );
  }
}
