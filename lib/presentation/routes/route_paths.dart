/// Константы путей, используемых роутером приложения.
abstract class AppRoutes {
  static const String counter = '/counter';
  static const String history = '/history';
  static const String support = '/support';
  static const String unknown = '/404';
}

/// Константы query- и path-параметров маршрутов.
abstract class RouteParams {
  static const String category = 'category';
  static const String read = 'read';
}

/// Константы сегментов URL для сопоставления маршрутов.
abstract class RouteSegments {
  static const String counter = 'counter';
  static const String history = 'history';
  static const String support = 'support';
  static const String category = 'category';
}

/// Нормализованные имена поддерживаемых маршрутов.
enum RouteNames {
  counter(),
  history(),
  support(),
  unknown(),
  category();

  /// Имя маршрута, восстановленное из строкового сегмента пути.
  factory RouteNames.fromString(String value) => switch (value) {
    RouteSegments.counter => RouteNames.counter,
    RouteSegments.history => RouteNames.history,
    RouteSegments.support => RouteNames.support,
    RouteSegments.category => RouteNames.category,
    _ => RouteNames.unknown,
  };

  /// Объект пути для текущего имени маршрута и переданных параметров.
  RoutePaths toPath(Map<String, String> parameters) => switch (this) {
    RouteNames.counter => RoutePaths.counter(),
    RouteNames.history => RoutePaths.history(),
    RouteNames.support => RoutePaths.support(),
    RouteNames.category => RoutePaths.messageCategory(
      parameters[RouteParams.category]!,
      parameters[RouteParams.read]!,
    ),
    RouteNames.unknown => RoutePaths.unknown(),
  };
}

/// Значение маршрута, содержащее полный `location` и распарсенные параметры.
class RoutePaths {
  final String location;
  final Map<String, String> parameters;

  RoutePaths.counter() : location = AppRoutes.counter, parameters = {};
  RoutePaths.history() : location = AppRoutes.history, parameters = {};
  RoutePaths.support() : location = AppRoutes.support, parameters = {};
  RoutePaths.unknown() : location = AppRoutes.unknown, parameters = {};
  RoutePaths.messageCategory(String category, String read)
    : location = '${AppRoutes.support}/$category?${RouteParams.read}=$read',
      parameters = {RouteParams.category: category, RouteParams.read: read};

  /// Whether текущий путь указывает на страницу счетчика.
  bool get isCounter => location == AppRoutes.counter;

  /// Whether текущий путь указывает на страницу истории.
  bool get isHistory => location == AppRoutes.history;

  /// Whether текущий путь указывает на корневую страницу поддержки.
  bool get isSupport => location == AppRoutes.support;

  /// Whether текущий путь указывает на страницу категории поддержки.
  bool get isCategory =>
      location ==
      '${AppRoutes.support}/${getParameter(RouteParams.category)}?${RouteParams.read}=${getParameter(RouteParams.read)}';

  /// Whether текущий путь указывает на страницу 404.
  bool get isUnknown => location == AppRoutes.unknown;

  /// Значение параметра маршрута по его [key].
  String? getParameter(String key) => parameters[key];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoutePaths) return false;
    return location == other.location;
  }

  @override
  int get hashCode => location.hashCode;
}
