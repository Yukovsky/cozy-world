import 'package:flutter/material.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Виджет пустого состояния с иллюстрацией и текстом причины.
class EmptyDataWidget extends StatelessWidget {
  /// Текст пояснения пустого состояния.
  final String text;
  final PresentationStringsRepository strings;

  const EmptyDataWidget({super.key, required this.text, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        shadowColor: Theme.of(context).colorScheme.error,
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 25),
            Image.asset(strings.emptyStateSad, width: 200, height: 200),
            SizedBox(height: 15),
            Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
