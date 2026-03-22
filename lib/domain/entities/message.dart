/// Тип сообщения, поддерживаемый доменной моделью.
enum MessageType { text, video, audio, unknown }

/// Общий контракт полей сообщения в доменной модели.
mixin Message {
  int get id;
  MessageType get type;
  String get content;
}

/// Сообщение дня с датой публикации.
class TodayMessage with Message {
  @override
  final int id;

  final String date;

  @override
  final MessageType type;

  @override
  final String content;

  TodayMessage({
    required this.id,
    required this.date,
    required this.type,
    required this.content,
  });
}

/// Сообщение категории поддержки.
class CategoryMessage with Message {
  @override
  final int id;

  @override
  final MessageType type;

  @override
  final String content;

  final String? category;

  const CategoryMessage({
    required this.id,
    required this.type,
    required this.content,
    this.category,
  });
}
