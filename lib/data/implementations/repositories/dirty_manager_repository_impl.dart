import 'dart:async';

import 'package:cozy_world/domain/entities/dirty_event.dart';
import 'package:cozy_world/domain/entities/dirty_key.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';

/// Реализация in-memory реестра устаревших данных и событий invalidation.
class DirtyManagerRepositoryImpl implements IDataStateRepository {
  final List<String> _dirtyPages = [];

  final StreamController<DirtyEvent> _eventsController =
      StreamController<DirtyEvent>.broadcast();

  @override
  Stream<DirtyEvent> get events => _eventsController.stream;

  DirtyEvent? _lastEvent;

  @override
  /// Снимает флаг устаревания для категории [key] и статуса [readStatus].
  void clearCategoryStaleness(String key, bool? readStatus) {
    final String pageId = DirtyKey(key, readStatus).toTag();
    if (_dirtyPages.contains(pageId)) {
      _dirtyPages.remove(pageId);
    }
  }

  @override
  /// Снимает флаг устаревания для данных экрана поддержки.
  void clearSupportStaleness() {
    clearCategoryStaleness("support", null);
  }

  @override
  /// Полностью очищает внутренний реестр устаревших страниц.
  void clearAllStaleness() {
    _dirtyPages.clear();
  }

  @override
  /// Whether категория [key] со статусом [readStatus] помечена как устаревшая.
  bool isCategoryDataStale(String key, bool? readStatus) {
    if (_dirtyPages.contains(DirtyKey(key, readStatus).toTag())) {
      return true;
    }
    return false;
  }

  @override
  /// Whether данные экрана поддержки помечены как устаревшие.
  bool isSupportDataStale() {
    return isCategoryDataStale("support", null);
  }

  @override
  /// Помечает категорию [key] со статусом [readStatus] как устаревшую.
  void markCategoryDataStale(String key, bool? readStatus) {
    final String pageId = DirtyKey(key, readStatus).toTag();
    _dirtyPages.add(pageId);
    _emit(
      DirtyEvent(
        key: pageId,
        scope: DirtyScope.category,
        timeStamp: DateTime.now(),
      ),
    );
  }

  @override
  /// Помечает данные экрана поддержки как устаревшие.
  void markSupportDataStale() {
    markCategoryDataStale("support", null);
    _emit(
      DirtyEvent(
        key: DirtyKey("support", null).toTag(),
        scope: DirtyScope.support,
        timeStamp: DateTime.now(),
      ),
    );
  }

  void _emit(DirtyEvent event) {
    final DirtyEvent? prevEvent = _lastEvent;
    final bool isDuplicate =
        prevEvent != null &&
        prevEvent.key == event.key &&
        prevEvent.scope == event.scope &&
        event.timeStamp.difference(prevEvent.timeStamp).inMilliseconds < 500;
    if (isDuplicate) {
      return;
    }
    _lastEvent = event;
    _eventsController.add(event);
  }

  /// Закрывает поток событий invalidation.
  void dispose() {
    _eventsController.close();
  }
}

// Previously helper _getDataIndentifier — now centralized in `DirtyKey` value object.
