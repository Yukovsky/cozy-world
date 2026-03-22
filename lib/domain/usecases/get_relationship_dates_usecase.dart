import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/failures/dates_failure.dart';
import 'package:cozy_world/domain/repositories/i_relationship_dates_repository.dart';
import 'package:strings_api/domain_strings_repository.dart';

/// Use case получения дат отношений из репозитория.
class GetRelationshipDatesUseCase {
  final IRelationshipDatesRepository _repository;
  final DomainStringsRepository _strings;

  GetRelationshipDatesUseCase(this._repository, this._strings);

  /// Набор дат отношений или доменная ошибка их получения.
  Future<Result<Map<String, DateTime>, DatesFailure>> call() async {
    try {
      final dates = await _repository.getStartDates();
      if (dates.isEmpty) {
        return Failure(DatesNotSetFailure(_strings.datesNotSet));
      }
      return Success(dates);
    } catch (e) {
      return Failure(DatesLoadFailure(e.toString()));
    }
  }
}
