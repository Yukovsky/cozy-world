// ignore: depend_on_referenced_packages
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cozy_world/config/dependencies.dart';
import 'package:cozy_world/presentation/routes/app_router.dart';
import 'package:cozy_world/presentation/routes/route_paths.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'core/theme/theme.dart';

/// Запускает приложение и инициализирует граф зависимостей.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp(strings: Get.find<PresentationStringsRepository>()));
  //runApp(DevicePreview(builder: (context) => MyApp()));
}

/// Корневой виджет приложения с конфигурацией Router 2.0.
class MyApp extends StatelessWidget {
  final PresentationStringsRepository strings;

  const MyApp({super.key, required this.strings});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    // final ThemeData theme = brightness == Brightness.light
    //     ? AppTheme.lightTheme
    //     : AppTheme.darkTheme;
    return MaterialApp.router(
      title: strings.appTitle,
      key: Get.key,
      //theme: theme,
      theme: AppTheme.lightTheme,
      routerConfig: RouterConfig(
        routerDelegate: Get.find<AppRouterDelegate>(),
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(AppRoutes.counter),
          ),
        ),
        routeInformationParser: AppRouteInformationParser(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
