import 'package:cozy_world/domain/entities/elapsed_entity.dart';
import 'package:strings_api/domain_strings_repository.dart';

/// Use case вычисления прошедшего времени относительно заданной даты.
class ComputeElapsedUseCase {
  final DomainStringsRepository _strings;

  ComputeElapsedUseCase(this._strings);

  /// Прошедшее время с момента [date] до текущего времени.
  Elapsed call(DateTime date) {
    Duration difference = DateTime.now().difference(date);
    return Elapsed(
      Day(
        difference.inDays,
        daysLessThanZeroMessage: _strings.invalidValueMessage(
          _strings.daysLessThanZero,
        ),
      ),
      Hour(
        difference.inHours % 24,
        hoursOutOfRangeMessage: _strings.invalidValueMessage(
          _strings.hoursOutOfRange,
        ),
      ),
      Minute(
        difference.inMinutes % 60,
        minutesOutOfRangeMessage: _strings.invalidValueMessage(
          _strings.minutesOutOfRange,
        ),
      ),
      Second(
        difference.inSeconds % 60,
        secondsOutOfRangeMessage: _strings.invalidValueMessage(
          _strings.secondsOutOfRange,
        ),
      ),
    );
  }
}
