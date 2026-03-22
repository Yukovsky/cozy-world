/// Категория сообщений поддержки с признаком прочтения.
class Category {
  final String name;

  /// Whether категория отображает прочитанные сообщения.
  final bool readStatus;

  Category({required this.name, required this.readStatus});
}
