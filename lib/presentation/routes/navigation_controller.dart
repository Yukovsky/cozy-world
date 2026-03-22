import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cozy_world/presentation/services/i_app_router_service.dart';
import 'package:cozy_world/presentation/extensions/route_paths_to_int_ext.dart';

/// Контроллер нижней навигации и синхронизации с текущим маршрутом.
class NavigationController extends GetxController {
  /// Индекс активной вкладки в нижней панели.
  final Rx<int> selectedIndex = 1.obs;
  final IAppRouterService appNavigator;

  NavigationController({required this.appNavigator});

  @override
  void onInit() {
    ever(
      appNavigator.currentRoute,
      (path) => selectedIndex.value = path.toInt(),
    );
    super.onInit();
  }

  /// Переключает вкладку [index] и выполняет соответствующую навигацию.
  void selectTab(int index, BuildContext context) {
    if (selectedIndex.value == index) return;
    switch (index) {
      case 0:
        appNavigator.goReplaceToHistory();
      case 1:
        appNavigator.goReplaceToCounter();
      case 2:
        appNavigator.goReplaceToSupport();
    }
  }
}
