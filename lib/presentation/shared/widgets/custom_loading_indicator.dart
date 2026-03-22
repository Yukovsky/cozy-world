import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Виджет Lottie-индикатора загрузки, используемый в экранах приложения.
class CustomLoadingIndicator extends StatelessWidget {
  final PresentationStringsRepository strings;
  final bool fillScreen;

  const CustomLoadingIndicator({
    super.key,
    required this.strings,
    this.fillScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final loadingWidget = Lottie.asset(
      strings.loadingAnimation,
      width: 200,
      height: 200,
    );

    if (fillScreen) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(child: loadingWidget),
      );
    }

    return loadingWidget;
  }
}
