import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/category.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';

/// Use case получения категорий поддержки с учетом stale-флагов.
class GetCategoriesUsecase {
  final ISupportRepository _repository;
  final IDataStateRepository _dirtyManagerRepository;

  GetCategoriesUsecase(this._repository, this._dirtyManagerRepository);

  /// Список категорий, полученный по политике [policy].
  Future<Result<List<Category>, QueryFailure>> call({
    RefreshStrategy policy = RefreshStrategy.refreshWithCache,
  }) async {
    final RefreshStrategy finalPolicy =
        _dirtyManagerRepository.isSupportDataStale()
        ? RefreshStrategy.forceRefresh
        : policy;
    final result = await _repository.getCategories(finalPolicy);

    return result.when(
      success: (categories) {
        _dirtyManagerRepository.clearSupportStaleness();
        return Success(categories);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
