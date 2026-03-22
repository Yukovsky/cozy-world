import 'dart:async';
import 'package:cozy_world/domain/failures/dates_failure.dart';
import 'package:cozy_world/domain/usecases/compute_all_elapsed_usecase.dart';
import 'package:cozy_world/domain/usecases/get_relationship_dates_usecase.dart';
import 'package:get/get.dart';
import 'package:cozy_world/domain/entities/elapsed_entity.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Контроллер экрана счетчика с периодическим пересчетом прошедшего времени.
class CounterController extends GetxController
    with StateMixin<Map<String, Elapsed>> {
  final ComputeAllElapsedUseCase _computeAllElapsedUseCase;
  final GetRelationshipDatesUseCase _getRelationshipDatesUseCase;
  final PresentationStringsRepository _strings;

  Timer? _timer;

  Map<String, DateTime> _startDates = {};
  Map<String, Elapsed> _elapsedInstances = <String, Elapsed>{};

  CounterController(
    this._computeAllElapsedUseCase,
    this._getRelationshipDatesUseCase,
    this._strings,
  );

  @override
  void onInit() {
    super.onInit();
    _loadAndStartTimer();
  }

  Future<void> _loadAndStartTimer() async {
    change(null, status: RxStatus.loading());

    final result = await _getRelationshipDatesUseCase.call();

    result.when(
      success: (dates) {
        _timer?.cancel(); // ✅ Отменяем старый таймер
        _startDates = dates;
        _updateElapsed();
        startTimer();
      },
      failure: (failure) {
        _timer?.cancel(); // ✅ Отменяем таймер при ошибке
        final String failureText;
        if (failure is DatesNotSetFailure) {
          failureText = _strings.counterDatesNotLoaded;
        } else if (failure is DatesLoadFailure) {
          failureText = _strings.counterErrorMessage(failure.message);
        } else {
          failureText = _strings.counterErrorMessage(
            _strings.counterUnknownError,
          );
        }
        change(null, status: RxStatus.error(failureText));
      },
    );
  }

  /// Запускает секундный таймер, который обновляет отображаемые значения.
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateElapsed();
    });
  }

  void _updateElapsed() {
    final result = _computeAllElapsedUseCase.call(_startDates);
    result.when(
      success: (elapsedInstances) {
        _elapsedInstances = elapsedInstances;
        change(_elapsedInstances, status: RxStatus.success());
      },
      failure: (failure) {
        change(
          null,
          status: RxStatus.error(_strings.counterErrorMessage(failure.message)),
        );
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
