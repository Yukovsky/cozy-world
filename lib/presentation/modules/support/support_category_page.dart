import 'package:auto_size_text/auto_size_text.dart';
import 'package:cozy_world/domain/entities/message.dart';
import 'package:cozy_world/presentation/modules/support/controllers/category_messages_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/change_read_status_controller.dart';
import 'package:cozy_world/presentation/shared/widgets/custom_loading_indicator.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cozy_world/presentation/shared/widgets/empty_data_widget.dart';

/// Страница сообщений выбранной категории поддержки.
class CategoryPage extends StatelessWidget {
  /// Название категории сообщений.
  final String category;

  /// Whether отображаются прочитанные (`true`) или непрочитанные (`false`) сообщения.
  final bool read;

  /// Тег страницы для получения корректного экземпляра контроллера.
  final String pageId;
  final PresentationStringsRepository strings;

  const CategoryPage({
    super.key,
    required this.category,
    required this.read,
    required this.pageId,
    required this.strings,
  });

  /// Принудительно обновляет список сообщений текущей категории.
  Future<void> refreshCategoryMessages() async {
    final controller = Get.find<CategoryMessagesController>(tag: pageId);
    await controller.forceLoadCategoryMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Color.fromRGBO(211, 47, 47, 100),
              ],
            ),
          ),
        ),
        title: AutoSizeText(
          category,
          maxLines: 2,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshCategoryMessages,
        child: Obx(() {
          final controller = Get.find<CategoryMessagesController>(tag: pageId);
          if (controller.isLoading.value) {
            return Center(
              child: CustomLoadingIndicator(strings: strings, fillScreen: true),
            );
          }
          if (controller.error.value != null) {
            return Text(controller.error.value!);
          }
          final messages = controller.categoryMessages;
          if (messages.isEmpty) {
            return EmptyView(strings: strings);
          }
          return SuccessView(messages: messages, read: read, strings: strings);
        }),
      ),
    );
  }
}

class SuccessView extends StatelessWidget {
  final PresentationStringsRepository strings;

  const SuccessView({
    super.key,
    required this.messages,
    required this.read,
    required this.strings,
  });

  final List<CategoryMessage> messages;
  final bool read;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return FlipCard(
          key: ValueKey(message.id),
          fill: Fill.fillBack,
          front: _FrontCardSide("${index + 1}", strings: strings),
          // Заменить функцией
          back: _BackCardSide(
            message: message,
            readStatus: read,
            buttonTile: read == false
                ? strings.markAsRead
                : strings.removeFromRead,
          ),
        );
      },
    );
  }
}

class EmptyView extends StatelessWidget {
  final PresentationStringsRepository strings;

  const EmptyView({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: EmptyDataWidget(
                text: strings.emptyCategory,
                strings: strings,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FrontCardSide extends StatelessWidget {
  final String text;
  final PresentationStringsRepository strings;

  const _FrontCardSide(this.text, {required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _MessageCardContainer(
      align: AlignmentGeometry.center,
      child: Column(
        children: [
          Lottie.asset(strings.supportHeartAnimation, width: 100, height: 100),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackCardSide extends GetView<ChangeReadStatusController> {
  final CategoryMessage message;
  final bool readStatus;
  final String buttonTile;

  const _BackCardSide({
    required this.message,
    required this.buttonTile,
    required this.readStatus,
  });
  Future<void> _handleChangeStatus(BuildContext context) async {
    if (controller.isLoading.value) return;
    await controller.changeMessageReadStatus(
      messageId: message.id,
      readStatus: readStatus,
      categoryName: message.category!,
    );
    final res = controller.resultMessage.value;
    if (res != null && res.isNotEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _MessageCardContainer(
      align: AlignmentGeometry.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                message.content,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => _handleChangeStatus(context),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(buttonTile, maxLines: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCardContainer extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry align;

  const _MessageCardContainer({required this.child, required this.align});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(15),
      ),
      constraints: const BoxConstraints(minHeight: 100),
      alignment: align,
      padding: const EdgeInsets.all(15.0),
      child: child,
    );
  }
}
