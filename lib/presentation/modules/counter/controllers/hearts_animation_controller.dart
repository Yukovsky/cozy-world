import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Контроллер анимации сердечек для экрана счетчика.
class HeartsAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Whether слой анимации должен быть видим в UI.
  final RxBool isVisible = false.obs;

  /// Текущий [AnimationController] для управления воспроизведением.
  AnimationController? get animationController => _controller;

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hideAnimation();
      }
    });
  }

  void _hideAnimation() {
    isVisible.value = false;
    _controller.reset();
  }

  /// Запускает анимацию отображения сердечек.
  void playAnimation() {
    isVisible.value = true;
    _controller.forward();
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}
