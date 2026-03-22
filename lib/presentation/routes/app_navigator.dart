import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:cozy_world/presentation/services/i_app_router_service.dart';
import 'package:cozy_world/presentation/routes/app_router.dart';
import 'package:cozy_world/presentation/routes/route_paths.dart';

/// Адаптер интерфейса [IAppRouterService] поверх [AppRouterDelegate].
class AppNavigator implements IAppRouterService {
  final Rx<RoutePaths> _currentRoute = RoutePaths.counter().obs;

  @override
  /// Реактивный текущий маршрут из делегата Router 2.0.
  Rx<RoutePaths> get currentRoute => _currentRoute;

  final AppRouterDelegate delegate;

  AppNavigator({required this.delegate}) {
    delegate.addListener(
      () => _currentRoute.value = delegate.currentConfiguration!,
    );
    _currentRoute.value = delegate.currentConfiguration!;
  }

  @override
  /// Переходит на страницу счетчика.
  void goToCounter() {
    delegate.goToCounter();
  }

  @override
  /// Переходит на страницу истории.
  void goToHistory() {
    delegate.goToHistory();
  }

  @override
  /// Переходит на страницу поддержки.
  void goToSupport() {
    delegate.goToSupport();
  }

  @override
  /// Переходит на страницу «не найдено».
  void goTo404() {
    delegate.goTo404();
  }

  @override
  /// Переходит к категории [category] с фильтром [read].
  void goToCategory(String category, String read) {
    delegate.goToCategory(category, read);
  }

  @override
  /// Полностью заменяет стек страницей счетчика.
  void goReplaceToCounter() {
    delegate.goReplaceToCounter();
  }

  @override
  /// Полностью заменяет стек страницей истории.
  void goReplaceToHistory() {
    delegate.goReplaceToHistory();
  }

  @override
  /// Полностью заменяет стек страницей поддержки.
  void goReplaceToSupport() {
    delegate.goReplaceToSupport();
  }
}
