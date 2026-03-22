import 'dart:async';
import 'package:cozy_world/data/exceptions/credentials_exception.dart';
import 'package:cozy_world/data/services/i_connection_service.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:ferry/ferry.dart';

import 'package:cozy_world/core/utils/result.dart';

import 'package:cozy_world/data/datasources/remote/graphql/mutations/generated/change_read_type.req.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_all_categories.req.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_category_messages.req.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_today_message.req.gql.dart';
import 'package:cozy_world/data/exceptions/request_exception.dart';
import 'package:strings_api/data_strings_repository.dart';
import 'package:cozy_world/data/mappers/messages_mapper.dart';
import 'package:cozy_world/data/mappers/refresh_strategy_mapper.dart';

import 'package:cozy_world/domain/entities/category.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';
import 'package:cozy_world/domain/utils/today_date.dart';

/// Реализация [ISupportRepository] на базе GraphQL-клиента Ferry.
class FerrySupportRepositoryImpl implements ISupportRepository {
  final IConnectionService clientService;
  final DataStringsRepository _strings;

  FerrySupportRepositoryImpl({
    required this.clientService,
    required DataStringsRepository strings,
  }) : _strings = strings;

  @override
  /// Изменяет статус прочтения сообщения [messageId].
  Future<Result<int, QueryFailure>> changeReadStatus(
    int messageId,
    bool readStatus,
    String category,
  ) async {
    try {
      final client = clientService.getClient;
      final mutation = GChangeReadTypeReq(
        (b) => b
          ..executeOnListen = true
          ..fetchPolicy = FetchPolicy.NoCache
          ..vars.id = messageId
          ..vars.read = readStatus,
      );

      final response = await client
          .request(mutation)
          .firstWhere((res) => !res.loading)
          .timeout(const Duration(seconds: 15));

      if (response.hasErrors) {
        throw RequestException(_strings.changeReadStatusRequestError);
      }

      final affectedCount =
          response.data?.updatemessagesCollection.affectedCount ?? 0;
      return Success(affectedCount);
    } on TimeoutException {
      return Failure(
        MessageLoadFailure(
          RequestException(_strings.changeReadStatusRequestTimeout).toString(),
        ),
      );
    } on RequestException catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    } on CredentialsException catch (e) {
      return Failure(ClientConnectionFailure(e.toString()));
    } catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    }
  }

  @override
  /// Список категорий поддержки с политикой обновления [fetchPolicy].
  Future<Result<List<Category>, QueryFailure>> getCategories(
    RefreshStrategy fetchPolicy,
  ) async {
    try {
      final FetchPolicy policy = fetchPolicy.toFerryPolicy();
      final client = clientService.getClient;
      final categoriesReq = GCategoriesReq((b) => b..fetchPolicy = policy);

      final response = await client
          .request(categoriesReq)
          .firstWhere((res) => !res.loading);

      if (response.hasErrors) {
        throw RequestException(_strings.categoriesRequestError);
      }

      if (response.data == null ||
          response.data!.unique_message_categoryCollection == null) {
        throw RequestException(_strings.categoriesDataIsNull);
      }

      return Success(
        response.data!.unique_message_categoryCollection!.edges
            .toCategoryList(),
      );
    } on RequestException catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    } catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    }
  }

  @override
  /// Сообщения категории [category] со статусом [readStatus].
  Future<Result<List<CategoryMessage>, QueryFailure>> getCategoryMessages(
    RefreshStrategy fetchPolicy,
    String category,
    bool readStatus,
  ) async {
    try {
      final FetchPolicy policy = fetchPolicy.toFerryPolicy();
      final client = clientService.getClient;
      final categoryMessagesReq = GCategoryMessagesReq(
        (b) => b
          ..vars.category = category
          ..vars.read = readStatus
          ..fetchPolicy = policy,
      );

      final response = await client
          .request(categoryMessagesReq)
          .firstWhere((res) => !res.loading);

      if (response.hasErrors) {
        throw RequestException(_strings.categoryMessagesRequestError);
      }

      if (response.data == null || response.data!.messagesCollection == null) {
        throw RequestException(_strings.categoryMessagesDataIsNull);
      }

      return Success(
        response.data!.messagesCollection!.edges.toCategoryMessageList(),
      );
    } on RequestException catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    } catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    }
  }

  @override
  /// Сообщение дня по текущей дате и политике [fetchPolicy].
  Future<Result<TodayMessage, QueryFailure>> getTodayMessage(
    RefreshStrategy fetchPolicy,
  ) async {
    try {
      final FetchPolicy policy = fetchPolicy.toFerryPolicy();
      final client = clientService.getClient;

      final todayMessageReq = GTodayMessageReq(
        (b) => b
          ..vars.day.value = TodayDateModel.getTodayDate()
          ..fetchPolicy = policy,
      );

      final response = await client
          .request(todayMessageReq)
          .firstWhere((res) => !res.loading);

      if (response.hasErrors) {
        throw RequestException(_strings.todayMessageRequestError);
      }

      if (response.data == null || response.data!.messagesCollection == null) {
        throw RequestException(_strings.todayMessageDataIsNull);
      }

      return Success(
        response.data!.messagesCollection!.edges.first.node.toDailyMessage(),
      );
    } on RequestException catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    } catch (e) {
      return Failure(MessageLoadFailure(e.toString()));
    }
  }
}
