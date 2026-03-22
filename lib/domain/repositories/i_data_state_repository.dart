import 'package:cozy_world/domain/entities/dirty_event.dart';

/// Репозиторий флагов устаревания кэша и событий инвалидации данных.
abstract class IDataStateRepository {
  /// Поток событий об изменении состояния «грязности» данных.
  Stream<DirtyEvent> get events;

  /// Whether данные категории с [key] и [readStatus] требуют обновления.
  bool isCategoryDataStale(String key, bool? readStatus);

  /// Whether данные экрана поддержки требуют обновления.
  bool isSupportDataStale();

  /// Помечает категорию с [key] и [readStatus] как устаревшую.
  void markCategoryDataStale(String key, bool? readStatus);

  /// Помечает данные экрана поддержки как устаревшие.
  void markSupportDataStale();

  /// Снимает флаг устаревания для категории с [key] и [readStatus].
  void clearCategoryStaleness(String key, bool? readStatus);

  /// Снимает флаг устаревания для экрана поддержки.
  void clearSupportStaleness();

  /// Снимает все флаги устаревания данных.
  void clearAllStaleness();
}
