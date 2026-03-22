import 'package:cozy_world/presentation/modules/support/controllers/categories_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/support_effects_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/today_message_controller.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:get/get.dart';

class SupportBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SupportEffectsController>()) {
      Get.put<SupportEffectsController>(
        SupportEffectsController(
          todayMessageController: Get.find<TodayMessageController>(),
          categoriesController: Get.find<CategoriesController>(),
          strings: Get.find<PresentationStringsRepository>(),
        ),
      );
    }
  }
}
