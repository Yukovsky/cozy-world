import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/usecases/get_category_messages_usecase.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:cozy_world/presentation/modules/support/controllers/category_effects_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/category_messages_controller.dart';
import 'package:get/get.dart';

class CategoryBinding implements Bindings {
  final String category;
  final bool readStatus;
  final String tag;

  CategoryBinding({
    required this.category,
    required this.readStatus,
    required this.tag,
  });

  @override
  void dependencies() {
    if (!Get.isRegistered<CategoryMessagesController>(tag: tag)) {
      Get.lazyPut<CategoryMessagesController>(
        () => CategoryMessagesController(
          getCategoryMessagesUsecase: Get.find<GetCategoryMessagesUsecase>(),
          dataStateRepository: Get.find<IDataStateRepository>(),
          category: category,
          readStatus: readStatus,
          tag: tag,
        ),
        tag: tag,
      );
    }
    if (!Get.isRegistered<CategoryEffectsController>()) {
      Get.put<CategoryEffectsController>(
        CategoryEffectsController(
          categoryMessagesController: Get.find<CategoryMessagesController>(
            tag: tag,
          ),
          strings: Get.find<PresentationStringsRepository>(),
        ),
      );
    }
  }
}
