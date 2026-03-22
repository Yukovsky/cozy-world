import 'package:common_locale_data/ru.dart';
import 'package:cozy_world/domain/entities/elapsed_entity.dart';
import 'package:cozy_world/presentation/exceptions/presentation_exceptions.dart';

/// Расширение форматирования [TimeUnit] для отображения в UI.
extension TimeUnitUI on TimeUnit {
  /// Список токенов локализованной единицы времени для [ruCld].
  List<String> toFormatedList(CommonLocaleDataRu ruCld) {
    return switch (this) {
      Day() => ruCld.units.durationDay.long(value),
      Hour() => ruCld.units.durationHour.long(value),
      Minute() => ruCld.units.durationMinute.long(value),
      Second() => ruCld.units.durationSecond.long(value),
      _ => throw UnknownClassException(),
    }.split(" ");
  }
}
