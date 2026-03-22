import 'package:strings_api/domain_strings_repository.dart';

import 'failures/failure_strings.dart';
import 'validation/validation_strings.dart';

/// Публичная реализация [DomainStringsRepository] для production-версии.
class DomainStringsImpl implements DomainStringsRepository {
  @override
  String get cannotChangeMessageReadStatus =>
      PublicFailureStrings.cannotChangeMessageReadStatus;

  @override
  String get datesNotSet => PublicFailureStrings.datesNotSet;

  @override
  String get daysLessThanZero => PublicValidationStrings.daysLessThanZero;

  @override
  String get emptyMessagesReceived =>
      PublicFailureStrings.emptyMessagesReceived;

  @override
  String get hoursOutOfRange => PublicValidationStrings.hoursOutOfRange;

  @override
  String get invalidValuePrefix => PublicFailureStrings.invalidValuePrefix;

  @override
  String invalidValueMessage(String? details) {
    if (details == null || details.isEmpty) {
      return invalidValuePrefix;
    }
    return '$invalidValuePrefix $moreInfoPrefix$details';
  }

  @override
  String get minutesOutOfRange => PublicValidationStrings.minutesOutOfRange;

  @override
  String get moreInfoPrefix => PublicFailureStrings.moreInfoPrefix;

  @override
  String get secondsOutOfRange => PublicValidationStrings.secondsOutOfRange;
}
