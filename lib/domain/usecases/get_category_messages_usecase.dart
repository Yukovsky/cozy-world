import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';

/// Use case получения сообщений выбранной категории.
class GetCategoryMessagesUsecase {
  final ISupportRepository _repository;
  final IDataStateRepository _dirtyManagerRepository;

  GetCategoryMessagesUsecase(this._repository, this._dirtyManagerRepository);

  /// Сообщения категории [categoryName] со статусом [readStatus].
  Future<Result<List<CategoryMessage>, QueryFailure>> call({
    required String categoryName,
    required bool readStatus,
    RefreshStrategy policy = RefreshStrategy.refreshWithCache,
  }) async {
    final RefreshStrategy finalPolicy =
        _dirtyManagerRepository.isCategoryDataStale(categoryName, readStatus)
        ? RefreshStrategy.forceRefresh
        : policy;
    final result = await _repository.getCategoryMessages(
      finalPolicy,
      categoryName,
      readStatus,
    );

    return result.when(
      success: (categoryMessage) {
        _dirtyManagerRepository.clearCategoryStaleness(
          categoryName,
          readStatus,
        );
        return Success(categoryMessage);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
