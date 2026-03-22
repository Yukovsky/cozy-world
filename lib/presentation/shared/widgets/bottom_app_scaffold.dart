import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:cozy_world/presentation/routes/navigation_controller.dart';

/// Базовый `Scaffold` приложения с AppBar и нижней навигацией.
class BottomAppScaffold extends GetView<NavigationController> {
  /// Контент активной страницы.
  final Widget child;

  /// Заголовок текущей страницы.
  final String title;
  final PresentationStringsRepository strings;

  const BottomAppScaffold({
    required this.child,
    required this.title,
    required this.strings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.favorite, color: theme.colorScheme.onPrimary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                Color.fromRGBO(211, 47, 47, 100),
              ],
            ),
          ),
        ),
        title: AutoSizeText(
          title,
          maxLines: 2,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),

      backgroundColor: theme.colorScheme.surface,
      body: child,
      bottomNavigationBar: AppBottomNavBar(strings: strings),
    );
  }
}

/// Нижняя панель навигации приложения.
class AppBottomNavBar extends GetView<NavigationController> {
  final PresentationStringsRepository strings;

  const AppBottomNavBar({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurfaceVariant,

      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          tooltip: strings.historyTooltip,
          label: strings.historyLabel,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.timelapse_rounded),
          tooltip: strings.counterTooltip,
          label: strings.counterLabel,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          tooltip: strings.supportTooltip,
          label: strings.supportLabel,
        ),
      ],

      currentIndex: controller.selectedIndex.value,
      onTap: (index) => controller.selectTab(index, context),
    );
  }
}
