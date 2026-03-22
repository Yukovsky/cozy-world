import 'package:cozy_world/domain/exceptions/domain_exception.dart';

/// Количество полных дней в составе прошедшего времени.
class Day implements TimeUnit {
  @override
  final int value;
  final String _daysLessThanZeroMessage;

  Day(this.value, {required String daysLessThanZeroMessage})
    : _daysLessThanZeroMessage = daysLessThanZeroMessage {
    if (value < 0) {
      throw InvalidValueException(_daysLessThanZeroMessage);
    }
  }

  @override
  String toString() {
    return "$value";
  }
}

/// Количество часов в диапазоне `0..23`.
class Hour implements TimeUnit {
  @override
  final int value;
  final String _hoursOutOfRangeMessage;

  Hour(this.value, {required String hoursOutOfRangeMessage})
    : _hoursOutOfRangeMessage = hoursOutOfRangeMessage {
    if (value < 0 || value > 23) {
      throw InvalidValueException(_hoursOutOfRangeMessage);
    }
  }

  @override
  String toString() {
    return "$value";
  }
}

/// Количество минут в диапазоне `0..59`.
class Minute implements TimeUnit {
  @override
  final int value;
  final String _minutesOutOfRangeMessage;

  Minute(this.value, {required String minutesOutOfRangeMessage})
    : _minutesOutOfRangeMessage = minutesOutOfRangeMessage {
    if (value < 0 || value > 59) {
      throw InvalidValueException(_minutesOutOfRangeMessage);
    }
  }

  @override
  String toString() {
    return "$value";
  }
}

/// Количество секунд в диапазоне `0..59`.
class Second implements TimeUnit {
  @override
  final int value;
  final String _secondsOutOfRangeMessage;

  Second(this.value, {required String secondsOutOfRangeMessage})
    : _secondsOutOfRangeMessage = secondsOutOfRangeMessage {
    if (value < 0 || value > 59) {
      throw InvalidValueException(_secondsOutOfRangeMessage);
    }
  }

  @override
  String toString() {
    return "$value";
  }
}

/// Полное представление прошедшего времени по единицам.
class Elapsed {
  final Day days;
  final Hour hours;
  final Minute minutes;
  final Second seconds;

  const Elapsed(this.days, this.hours, this.minutes, this.seconds);
}

/// Контракт единицы времени, имеющей целочисленное значение.
abstract interface class TimeUnit {
  int get value;
}
