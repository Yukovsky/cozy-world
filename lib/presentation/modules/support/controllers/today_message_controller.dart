import 'package:cozy_world/core/utils/result.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/domain/failures/query_failure.dart';
import 'package:cozy_world/domain/entities/refresh_strategy.dart';
import 'package:cozy_world/domain/usecases/get_today_message_usecase.dart';
import 'package:get/get.dart';

/// Контроллер загрузки и обновления «сообщения дня».
class TodayMessageController extends GetxController {
  /// Use case получения сообщения дня.
  final GetTodayMessageUsecase getTodayMessageUsecase;

  /// Whether выполняется загрузка сообщения дня.
  final RxBool isLoading = true.obs;

  /// Текущее сообщение дня.
  final Rxn<TodayMessage> todayMessage = Rxn<TodayMessage>();

  /// Текст ошибки последней попытки загрузки.
  final RxnString error = RxnString();

  TodayMessageController({required this.getTodayMessageUsecase});

  @override
  void onReady() {
    _loadTodayMessage();
    super.onReady();
  }

  Future<void> _loadTodayMessage([RefreshStrategy? policy]) async {
    isLoading.value = true;
    error.value = null;
    final Result<TodayMessage, QueryFailure> result =
        await getTodayMessageUsecase.call(policy: policy);
    result.when(
      success: (message) {
        todayMessage.value = message;
      },
      failure: (failure) {
        error.value = failure.message;
      },
    );
    isLoading.value = false;
  }

  /// Загружает сообщение дня с политикой кэширования по умолчанию.
  Future<void> loadTodayMessage() async {
    await _loadTodayMessage();
  }

  /// Принудительно загружает сообщение дня, игнорируя кэш.
  Future<void> forceLoadTodayMessage() async {
    await _loadTodayMessage(RefreshStrategy.forceRefresh);
  }
}
