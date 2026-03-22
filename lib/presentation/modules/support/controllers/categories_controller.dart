import 'dart:async';

import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/category.dart';
import 'package:cozy_world/domain/entities/dirty_event.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/usecases/get_categories_usecase.dart';
import 'package:get/get.dart';

/// Контроллер загрузки категорий поддержки и автообновления по событиям stale.
class CategoriesController extends GetxController {
  /// Use case получения списка категорий поддержки.
  final GetCategoriesUsecase getCategoriesUsecase;

  /// Репозиторий состояния устаревания данных.
  final IDataStateRepository dataStateRepository;

  /// Whether выполняется загрузка категорий.
  final RxBool isLoading = true.obs;

  /// Текущий список категорий для отображения.
  final RxList<Category> categories = <Category>[].obs;

  /// Текст ошибки последней попытки загрузки.
  final RxnString error = RxnString();

  StreamSubscription<DirtyEvent>? _dirtySub;
  DateTime? _lastAutoReloadAt;

  CategoriesController({
    required this.getCategoriesUsecase,
    required this.dataStateRepository,
  });

  @override
  void onInit() {
    _dirtySub = dataStateRepository.events
        .where((event) => event.scope == DirtyScope.support)
        .listen((_) => _autoReload());
    super.onInit();
  }

  @override
  void onReady() {
    loadCategories();
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
    await loadCategories();
  }

  Future<void> _loadCategories([RefreshStrategy? policy]) async {
    isLoading.value = true;
    error.value = null;
    final Result<List<Category>, QueryFailure> result;
    if (policy != null) {
      result = await getCategoriesUsecase.call(policy: policy);
    } else {
      result = await getCategoriesUsecase.call();
    }
    result.when(
      success: (categoryList) {
        categories.value = categoryList;
      },
      failure: (failure) {
        error.value = failure.message;
      },
    );
    isLoading.value = false;
  }

  /// Принудительно загружает категории, игнорируя кэш.
  Future<void> forceLoadCategories() async {
    await _loadCategories(RefreshStrategy.forceRefresh);
  }

  /// Загружает категории с политикой кэширования по умолчанию.
  Future<void> loadCategories() async {
    await _loadCategories();
  }

  @override
  void onClose() {
    _dirtySub?.cancel();
    super.onClose();
  }
}
