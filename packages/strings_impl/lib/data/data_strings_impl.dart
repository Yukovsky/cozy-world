import 'package:strings_api/data_strings_repository.dart';

import 'errors/config/config_error_strings.dart';
import 'errors/requests/request_error_strings.dart';

/// Публичная реализация [DataStringsRepository] для внешнего релиза.
class DataStringsImpl implements DataStringsRepository {
  @override
  String get apiCredentialsNotConfigured =>
      PublicConfigErrorStrings.apiCredentialsNotConfigured;

  @override
  String get categoriesDataIsNull =>
      PublicRequestErrorStrings.categoriesDataIsNull;

  @override
  String get categoriesRequestError =>
      PublicRequestErrorStrings.categoriesRequestError;

  @override
  String get categoryMessagesDataIsNull =>
      PublicRequestErrorStrings.categoryMessagesDataIsNull;

  @override
  String get categoryMessagesRequestError =>
      PublicRequestErrorStrings.categoryMessagesRequestError;

  @override
  String get changeReadStatusRequestError =>
      PublicRequestErrorStrings.changeReadStatusRequestError;

  @override
  String get changeReadStatusRequestTimeout =>
      PublicRequestErrorStrings.changeReadStatusRequestTimeout;

  @override
  String get credentialsExceptionPrefix =>
      PublicConfigErrorStrings.credentialsExceptionPrefix;

  @override
  String get graphQlClientNotInitialized =>
      PublicConfigErrorStrings.graphQlClientNotInitialized;

  @override
  String idNotFound(String id) {
    return PublicRequestErrorStrings.idNotFound(id);
  }

  @override
  String get moreInfoPrefix => graphQlClientNotInitialized;

  @override
  String get requestErrorPrefix => PublicRequestErrorStrings.requestErrorPrefix;

  @override
  String get todayMessageDataIsNull =>
      PublicRequestErrorStrings.todayMessageDataIsNull;

  @override
  String get todayMessageRequestError =>
      PublicRequestErrorStrings.todayMessageRequestError;

  @override
  String get unknownIdPrefix => PublicRequestErrorStrings.unknownIdPrefix;
}
