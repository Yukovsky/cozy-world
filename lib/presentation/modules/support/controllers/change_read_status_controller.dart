import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/usecases/change_message_read_status_usecase.dart';
import 'package:cozy_world/presentation/utils/page_id.dart';
import 'package:cozy_world/presentation/modules/support/controllers/category_messages_controller.dart';
import 'package:get/get.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Контроллер изменения статуса прочтения сообщения и локального UI-обновления.
class ChangeReadStatusController extends GetxController {
  final ChangeMessageReadStatusUseCase changeMessageReadStatusUseCase;
  final PresentationStringsRepository _strings;

  /// Whether выполняется запрос изменения статуса.
  final RxBool isLoading = false.obs;

  /// Результат последней операции для показа пользователю.
  final RxnString resultMessage = RxnString();

  ChangeReadStatusController({
    required this.changeMessageReadStatusUseCase,
    required PresentationStringsRepository strings,
  }) : _strings = strings;

  /// Изменяет статус чтения сообщения [messageId] категории [categoryName].
  ///
  /// После успешного ответа удаляет сообщение из текущего списка страницы,
  /// если соответствующий [CategoryMessagesController] зарегистрирован.
  Future<void> changeMessageReadStatus({
    required int messageId,
    required String categoryName,
    required bool readStatus,
  }) async {
    isLoading.value = true;
    resultMessage.value = null;
    try {
      final Result<int, QueryFailure> result =
          await changeMessageReadStatusUseCase.call(
            messageId: messageId,
            categoryName: categoryName,
            readStatus: readStatus,
          );

      result.when(
        success: (message) async {
          if (message == 1) {
            final String tag = PageId.getPageId(
              categoryName,
              readStatus.toString(),
            );
            if (Get.isRegistered<CategoryMessagesController>(tag: tag)) {
              final CategoryMessagesController messageController =
                  Get.find<CategoryMessagesController>(tag: tag);
              messageController.categoryMessages.removeWhere(
                (element) => element.id == messageId,
              );
              resultMessage.value = _strings.changeSuccess;
            } else {
              resultMessage.value = _strings.changeSuccessButNotUpdated;
            }
          } else {
            resultMessage.value = _strings.changeFailed;
          }
        },
        failure: (failure) {
          resultMessage.value = failure.message;
        },
      );
    } catch (_) {
      resultMessage.value = _strings.changeFailed;
    } finally {
      isLoading.value = false;
    }
  }
}
