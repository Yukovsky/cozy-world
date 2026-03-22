import 'package:cozy_world/presentation/routes/route_paths.dart';

/// Расширение преобразования маршрута в индекс нижней навигации.
extension RoutePathsToIntExt on RoutePaths {
  /// Индекс вкладки для текущего маршрута.
  int toInt() {
    if (isHistory) {
      return 0;
    } else if (isCounter) {
      return 1;
    } else if (isSupport) {
      return 2;
    } else {
      return 1;
    }
  }
}
