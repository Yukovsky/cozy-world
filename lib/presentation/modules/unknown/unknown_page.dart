import 'package:flutter/material.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:cozy_world/presentation/shared/widgets/bottom_app_scaffold.dart';

/// Страница, показываемая при неизвестном маршруте.
class UnknownPage extends StatelessWidget {
  final PresentationStringsRepository strings;

  const UnknownPage({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return BottomAppScaffold(
      title: strings.errorTitle,
      strings: strings,
      child: Center(child: Text(strings.pageNotFound)),
    );
  }
}
