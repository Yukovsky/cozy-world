import 'package:get/get.dart';
import 'package:cozy_world/presentation/routes/route_paths.dart';

/// Интерфейс навигации между экранами приложения.
abstract class IAppRouterService {
  /// Реактивное значение текущего маршрута.
  Rx<RoutePaths> get currentRoute;

  /// Переходит на страницу счетчика.
  void goToCounter();

  /// Переходит на страницу истории.
  void goToHistory();

  /// Переходит на страницу поддержки.
  void goToSupport();

  /// Переходит на страницу «не найдено».
  void goTo404();

  /// Переходит к категории [category] с фильтром [read].
  void goToCategory(String category, String read);

  /// Полностью заменяет стек страницей счетчика.
  void goReplaceToCounter();

  /// Полностью заменяет стек страницей истории.
  void goReplaceToHistory();

  /// Полностью заменяет стек страницей поддержки.
  void goReplaceToSupport();
}
