import 'package:cozy_world/domain/entities/category.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_all_categories.data.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_category_messages.data.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/queries/generated/get_today_message.data.gql.dart';
import 'package:cozy_world/data/datasources/remote/graphql/schema/generated/schema.schema.gql.dart';

/// Доменный [MessageType], сопоставленный из GraphQL-типа [gmessageType].
MessageType _toMessageType(Gmessage_type gmessageType) =>
    switch (gmessageType) {
      Gmessage_type.text => MessageType.text,
      Gmessage_type.audio => MessageType.audio,
      Gmessage_type.video => MessageType.video,
      _ => MessageType.unknown,
    };

/// Маппер GraphQL-ноды «сообщение дня» в доменную сущность.
extension TodayMessageMapper
    on GTodayMessageData_messagesCollection_edges_node {
  TodayMessage toDailyMessage() {
    return TodayMessage(
      id: message_id,
      date: on_day!.value,
      type: _toMessageType(type),
      content: content,
    );
  }
}

/// Маппер списка GraphQL-ребер сообщений категории в доменные сущности.
extension CategoryMessagiesMapper
    on Iterable<GCategoryMessagesData_messagesCollection_edges> {
  List<CategoryMessage> toCategoryMessageList() =>
      map((e) => e.node.toCategoryMessage()).toList();
}

/// Маппер GraphQL-ноды сообщения категории в доменную сущность.
extension CategoryMessageMapper
    on GCategoryMessagesData_messagesCollection_edges_node {
  CategoryMessage toCategoryMessage() {
    return CategoryMessage(
      id: message_id,
      type: _toMessageType(type),
      content: content,
      category: category,
    );
  }
}

/// Маппер GraphQL-ноды категории в доменную сущность.
extension CategoryMapper
    on GCategoriesData_unique_message_categoryCollection_edges_node {
  Category toCategory() {
    return Category(name: category, readStatus: is_read);
  }
}

/// Маппер коллекции GraphQL-ребер категорий в доменный список.
extension CategoriesMapper
    on Iterable<GCategoriesData_unique_message_categoryCollection_edges> {
  List<Category> toCategoryList() => map((e) => e.node.toCategory()).toList();
}
