import 'package:cozy_world/presentation/modules/support/controllers/categories_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/today_message_controller.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:get/get.dart';

/// Контроллер побочных эффектов экрана поддержки (snackbar по ошибкам).
class SupportEffectsController extends GetxController {
  final TodayMessageController todayMessageController;
  final CategoriesController categoriesController;
  final PresentationStringsRepository _strings;

  Worker? _todayErrorWorker;
  Worker? _categoriesErrorWorker;

  String? _lastTodayError;
  String? _lastCategoriesError;

  SupportEffectsController({
    required this.todayMessageController,
    required this.categoriesController,
    required PresentationStringsRepository strings,
  }) : _strings = strings;

  @override
  void onInit() {
    super.onInit();
    _todayErrorWorker = ever<String?>(
      todayMessageController.error,
      (message) => _showErrorOnce(
        title: _strings.snackbarErrorTitle,
        message: message,
        setLastError: (value) => _lastTodayError = value,
        lastError: _lastTodayError,
      ),
    );
    _categoriesErrorWorker = ever<String?>(
      categoriesController.error,
      (message) => _showErrorOnce(
        title: _strings.snackbarErrorTitle,
        message: message,
        setLastError: (value) => _lastCategoriesError = value,
        lastError: _lastCategoriesError,
      ),
    );
  }

  void _showErrorOnce({
    required String title,
    required String? message,
    required String? lastError,
    required void Function(String?) setLastError,
  }) {
    if (message == null || message.isEmpty) {
      setLastError(null);
      return;
    }

    if (message == lastError) {
      return;
    }

    setLastError(message);
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    _todayErrorWorker?.dispose();
    _categoriesErrorWorker?.dispose();
    super.onClose();
  }
}
