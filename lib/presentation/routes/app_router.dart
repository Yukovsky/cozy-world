import 'package:cozy_world/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cozy_world/presentation/modules/support/bindings/category_bindings.dart';
import 'package:cozy_world/presentation/modules/support/controllers/category_effects_controller.dart';
import 'package:cozy_world/presentation/utils/page_id.dart';
import 'package:cozy_world/presentation/modules/support/controllers/support_effects_controller.dart';
import 'package:cozy_world/presentation/modules/support/bindings/support_bindings.dart';
import 'package:cozy_world/presentation/modules/counter/counter_page.dart';
import 'package:cozy_world/presentation/modules/history/history_page.dart';
import 'package:cozy_world/presentation/modules/support/support_category_page.dart';
import 'package:cozy_world/presentation/modules/support/support_page.dart';
import 'package:cozy_world/presentation/modules/unknown/unknown_page.dart';
import 'package:cozy_world/presentation/routes/route_paths.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Парсер `RouteInformation` в типобезопасные значения [RoutePaths].
class AppRouteInformationParser extends RouteInformationParser<RoutePaths> {
  @override
  /// Путь приложения, восстановленный из [routeInformation].
  Future<RoutePaths> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final segments = uri.pathSegments;

    if (uri.pathSegments.length == 1) {
      return RouteNames.fromString(uri.pathSegments[0]).toPath({});
    }
    if (segments.length > 1 && segments.first == RouteSegments.support) {
      final category = segments.last;
      final read = uri.queryParameters[RouteParams.read];
      return RouteNames.category.toPath({
        RouteParams.category: category,
        RouteParams.read: read!,
      });
    }
    return RoutePaths.unknown();
  }

  @override
  /// Объект `RouteInformation`, восстановленный из [configuration].
  RouteInformation? restoreRouteInformation(RoutePaths configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse(AppRoutes.unknown));
    }
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}

/// Делегат Router 2.0, управляющий стеком экранов приложения.
class AppRouterDelegate extends RouterDelegate<RoutePaths> with ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;
  final PresentationStringsRepository _strings;

  DateTime? _lastBackPressTime;

  List<RoutePaths> _navigationStack = [RoutePaths.counter()];

  AppRouterDelegate(this._strings)
    : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  /// Текущий активный маршрут на вершине стека навигации.
  RoutePaths? get currentConfiguration => peek();

  /// Добавляет [path] в конец стека и уведомляет `Navigator`.
  void push(RoutePaths path) {
    _navigationStack.add(path);
    notifyListeners();
  }

  /// Удаляет верхний маршрут из стека и очищает связанные GetX-контроллеры.
  void pop() {
    if (_navigationStack.length > 1) {
      RoutePaths page = _navigationStack.removeLast();
      if (page.isSupport && Get.isRegistered<SupportEffectsController>()) {
        Get.delete<SupportEffectsController>();
      }
      if (page.isCategory) {
        final category = page.getParameter(RouteParams.category)!;
        final readStr = page.getParameter(RouteParams.read)!;
        final pageId = PageId.getPageId(category, readStr);
        Get.delete(tag: pageId);
        if (Get.isRegistered<CategoryEffectsController>()) {
          Get.delete<CategoryEffectsController>();
        }
      }
      notifyListeners();
    }
  }

  /// Заменяет верхний маршрут на [path], сохраняя остальную историю.
  void replaceTop(RoutePaths path) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.last = path;
    } else {
      _navigationStack.add(path);
    }
    notifyListeners();
  }

  /// Полностью заменяет стек одним маршрутом [path].
  void replaceWholly(RoutePaths path) {
    if (path.isUnknown) return;
    _navigationStack = [path];
    notifyListeners();
  }

  /// Удаляет верхние маршруты, пока на вершине не окажется [path].
  void popUntil(RoutePaths path) {
    while (_navigationStack.last != path && _navigationStack.length > 1) {
      pop();
    }
  }

  /// Маршрут на вершине стека навигации.
  RoutePaths peek() {
    return _navigationStack.last;
  }

  @override
  /// Обрабатывает системную кнопку «назад» и двойное нажатие для выхода.
  Future<bool> popRoute() async {
    // Если в нашем стэке больше 1 страницы — просто уходим назад
    if (_navigationStack.length > 1) {
      pop();
      return true; // Блокируем выход из приложения
    }

    // Если страница последняя — проверяем двойное нажатие
    final now = DateTime.now();
    final isDoublePress =
        _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2);

    if (isDoublePress) {
      // Разрешаем системе закрыть приложение
      return false;
    } else {
      _lastBackPressTime = now;

      // Используем GlobalKey для показа SnackBar (это надежнее контекста в Delegate)
      messengerKey.currentState?.removeCurrentSnackBar();
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(_strings.backPressConfirmation),
          duration: Duration(seconds: 2),
        ),
      );

      return true; // Блокируем выход после первого нажатия
    }
  }

  @override
  Widget build(BuildContext context) {
    // В Router 2.0 PopScope здесь больше не нужен,
    // так как мы перехватили управление в popRoute.
    return Navigator(
      key: _navigatorKey,
      pages: _buildPages(),
      onDidRemovePage: (page) {
        // Это сработает при нажатии кнопки "Назад" в AppBar
        pop();
        notifyListeners();
      },
    );
  }

  List<Page> _buildPages() {
    int index = 0;
    return _navigationStack.map((route) {
      index++;
      if (route.isCounter) {
        return MaterialPage(
          key: ValueKey('counter/$index'),
          child: CounterPage(strings: _strings),
        );
      } else if (route.isHistory) {
        return MaterialPage(
          key: ValueKey('history/$index'),
          child: HistoryPage(strings: _strings),
        );
      } else if (route.isSupport) {
        SupportBinding().dependencies();
        return MaterialPage(
          key: ValueKey('support/$index'),
          child: SupportPage(strings: _strings),
        );
      } else if (route.isCategory) {
        final category = route.getParameter(RouteParams.category)!;
        final readStr = route.getParameter(RouteParams.read)!;
        final read = bool.parse(readStr);
        final pageId = PageId.getPageId(category, readStr);
        CategoryBinding(
          category: category,
          readStatus: read,
          tag: pageId,
        ).dependencies();
        return MaterialPage(
          key: ValueKey(
            'category/${route.getParameter(RouteParams.category)}?${route.getParameter(RouteParams.read)}/$index',
          ),
          child: CategoryPage(
            category: route.getParameter(RouteParams.category)!,
            read: bool.parse(route.getParameter(RouteParams.read)!),
            pageId: pageId,
            strings: _strings,
          ),
        );
      } else {
        return MaterialPage(
          key: ValueKey('404/$index'),
          child: UnknownPage(strings: _strings),
        );
      }
    }).toList();
  }

  @override
  /// Полностью заменяет стек навигации входящей конфигурацией [configuration].
  Future<void> setNewRoutePath(RoutePaths configuration) async {
    replaceWholly(configuration);
  }

  /// Переходит на страницу счетчика.
  void goToCounter() {
    push(RoutePaths.counter());
  }

  /// Переходит на страницу истории.
  void goToHistory() {
    push(RoutePaths.history());
  }

  /// Переходит на страницу поддержки.
  void goToSupport() {
    push(RoutePaths.support());
  }

  /// Переходит на страницу «не найдено».
  void goTo404() {
    push(RoutePaths.unknown());
  }

  /// Переходит к категории поддержки [category] с фильтром [read].
  void goToCategory(String category, String read) {
    push(RoutePaths.messageCategory(category, read));
  }

  /// Полностью заменяет стек страницей поддержки.
  void goReplaceToSupport() {
    replaceWholly(RoutePaths.support());
  }

  /// Полностью заменяет стек страницей истории.
  void goReplaceToHistory() {
    replaceWholly(RoutePaths.history());
  }

  /// Полностью заменяет стек страницей счетчика.
  void goReplaceToCounter() {
    replaceWholly(RoutePaths.counter());
  }
}
