import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/elapsed_entity.dart';
import 'package:cozy_world/domain/failures/elapsed_failure.dart';
import 'package:cozy_world/domain/usecases/compute_elapsed_usecase.dart';

/// Use case вычисления прошедшего времени для набора дат.
class ComputeAllElapsedUseCase {
  final ComputeElapsedUseCase _computeElapsedUseCase;

  ComputeAllElapsedUseCase(this._computeElapsedUseCase);

  /// Результат вычисления `Elapsed` для каждой даты из [dates].
  Result<Map<String, Elapsed>, ElapsedFailure> call(
    Map<String, DateTime> dates,
  ) {
    try {
      final Map<String, Elapsed> result = {};
      dates.forEach((key, date) {
        result[key] = _computeElapsedUseCase.call(date);
      });
      return Success(result);
    } catch (e) {
      return Failure(GetElapsedFailure(e.toString()));
    }
  }
}
