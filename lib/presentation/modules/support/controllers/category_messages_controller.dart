import 'dart:async';

import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/dirty_event.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/usecases/get_category_messages_usecase.dart';
import 'package:get/get.dart';

/// Контроллер сообщений одной категории в рамках конкретной страницы (по [tag]).
class CategoryMessagesController extends GetxController {
  final GetCategoryMessagesUsecase getCategoryMessagesUsecase;
  final IDataStateRepository dataStateRepository;

  /// Категория, для которой запрашиваются сообщения.
  final String category;

  /// Whether нужно получать прочитанные (`true`) или непрочитанные (`false`) сообщения.
  final bool readStatus;

  /// Уникальный тег экземпляра контроллера в GetX.
  final String tag;

  /// Whether выполняется загрузка сообщений.
  final RxBool isLoading = true.obs;

  /// Текущий список сообщений категории.
  final RxList<CategoryMessage> categoryMessages = <CategoryMessage>[].obs;

  /// Текст ошибки последней попытки загрузки.
  final RxnString error = RxnString();

  StreamSubscription<DirtyEvent>? _dirtySub;
  DateTime? _lastAutoReloadAt;

  CategoryMessagesController({
    required this.getCategoryMessagesUsecase,
    required this.dataStateRepository,
    required this.category,
    required this.readStatus,
    required this.tag,
  });

  @override
  void onInit() {
    _dirtySub = dataStateRepository.events
        .where(
          (event) => event.scope == DirtyScope.category && event.key == tag,
        )
        .listen((_) => _autoReload());
    super.onInit();
  }

  @override
  void onReady() {
    // When controller is created per-page, auto-load its messages
    loadCategoryMessages();
    super.onReady();
  }

  Future<void> _autoReload() async {
    if (isLoading.value == true) {
      return;
    }
    final now = DateTime.now();
    if (_lastAutoReloadAt != null &&
        now.difference(_lastAutoReloadAt!).inMilliseconds < 1000) {
      return;
    }
    _lastAutoReloadAt = now;
    await loadCategoryMessages();
  }

  Future<void> _loadCategoryMessages([RefreshStrategy? policy]) async {
    isLoading.value = true;
    error.value = null;
    final Result<List<CategoryMessage>, QueryFailure> result;
    if (policy != null) {
      result = await getCategoryMessagesUsecase.call(
        categoryName: category,
        readStatus: readStatus,
        policy: policy,
      );
    } else {
      result = await getCategoryMessagesUsecase.call(
        categoryName: category,
        readStatus: readStatus,
      );
    }
    result.when(
      success: (messages) {
        categoryMessages.value = messages;
      },
      failure: (failure) {
        error.value = failure.message;
      },
    );
    isLoading.value = false;
  }

  /// Принудительно загружает сообщения категории, игнорируя кэш.
  Future<void> forceLoadCategoryMessages() async {
    await _loadCategoryMessages(RefreshStrategy.forceRefresh);
  }

  /// Загружает сообщения категории с политикой кэширования по умолчанию.
  Future<void> loadCategoryMessages() async {
    await _loadCategoryMessages();
  }

  @override
  void onClose() {
    _dirtySub?.cancel();
    super.onClose();
  }
}
