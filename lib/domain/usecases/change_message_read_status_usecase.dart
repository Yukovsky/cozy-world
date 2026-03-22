import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';
import 'package:strings_api/domain_strings_repository.dart';

/// Use case изменения статуса прочтения сообщения.
class ChangeMessageReadStatusUseCase {
  final ISupportRepository _repository;
  final IDataStateRepository _dirtyManagerRepository;
  final DomainStringsRepository _strings;

  ChangeMessageReadStatusUseCase(
    this._repository,
    this._dirtyManagerRepository,
    this._strings,
  );

  /// Изменяет статус чтения сообщения [messageId] в категории [categoryName].
  Future<Result<int, QueryFailure>> call({
    required int messageId,
    required String categoryName,
    required bool readStatus,
  }) async {
    final result = await _repository.changeReadStatus(
      messageId,
      !readStatus,
      categoryName,
    );

    return result.when(
      success: (affectedCount) {
        if (affectedCount != 1) {
          return Failure(
            ChangingMessageFailure(_strings.cannotChangeMessageReadStatus),
          );
        }
        _dirtyManagerRepository.markCategoryDataStale(
          categoryName,
          !readStatus,
        );
        _dirtyManagerRepository.markSupportDataStale();
        return Success(affectedCount);
      },
      failure: (failure) => Failure(failure),
    );
  }
}
