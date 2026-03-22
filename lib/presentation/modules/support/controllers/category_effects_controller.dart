import 'package:cozy_world/presentation/modules/support/controllers/category_messages_controller.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:get/get.dart';

/// Контроллер побочных эффектов страницы категории (snackbar по ошибкам).
class CategoryEffectsController extends GetxController {
  final CategoryMessagesController categoryMessagesController;
  final PresentationStringsRepository _strings;

  Worker? _categoryMessagesWorker;

  String? _lastCategoryMessagesError;

  CategoryEffectsController({
    required this.categoryMessagesController,
    required PresentationStringsRepository strings,
  }) : _strings = strings;

  @override
  void onInit() {
    _categoryMessagesWorker = ever<String?>(
      categoryMessagesController.error,
      (message) => _showErrorOnce(
        title: _strings.snackbarErrorTitle,
        message: message,
        setLastError: (value) => _lastCategoryMessagesError = value,
        lastError: _lastCategoryMessagesError,
      ),
    );
    super.onInit();
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
    _categoryMessagesWorker?.dispose();
    super.onClose();
  }
}
