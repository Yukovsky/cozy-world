import 'package:cozy_world/domain/entities/category.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:cozy_world/presentation/modules/support/controllers/categories_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/today_message_controller.dart';
import 'package:cozy_world/presentation/shared/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cozy_world/presentation/services/i_app_router_service.dart';
import 'package:cozy_world/presentation/shared/widgets/bottom_app_scaffold.dart';
import 'package:cozy_world/presentation/shared/widgets/empty_data_widget.dart';

/// Страница поддержки с сообщением дня и списком категорий.
class SupportPage extends StatelessWidget {
  final PresentationStringsRepository strings;

  const SupportPage({super.key, required this.strings});

  /// Принудительно обновляет сообщение дня и категории.
  Future<void> _refreshPage() async {
    final CategoriesController categoriesController =
        Get.find<CategoriesController>();
    final TodayMessageController todayMessageController =
        Get.find<TodayMessageController>();
    categoriesController.forceLoadCategories();
    todayMessageController.forceLoadTodayMessage();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppScaffold(
      title: strings.supportPageTitle,
      strings: strings,
      child: RefreshIndicator(
        onRefresh: _refreshPage, // Делегируем в контроллер
        child: SuccessView(strings: strings),
      ),
    );
  }
}

class SuccessView extends StatelessWidget {
  final PresentationStringsRepository strings;

  const SuccessView({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(15.0),
          sliver: SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                strings.todayMessageHeading,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          sliver: SliverToBoxAdapter(child: _TodayMessage(strings: strings)),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          sliver: SliverToBoxAdapter(child: SizedBox(height: 50)),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          sliver: SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                strings.openWhenHeading,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(15.0),
          sliver: SliverToBoxAdapter(
            child: _CategoriesGridView(strings: strings),
          ),
        ),
      ],
    );
  }
}

class _TodayMessage extends GetView<TodayMessageController> {
  final PresentationStringsRepository strings;

  const _TodayMessage({required this.strings});

  @override
  Widget build(BuildContext context) {
    // Оборачиваем всё в Obx, чтобы реагировать на очистку кэша
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CustomLoadingIndicator(strings: strings, fillScreen: true),
        );
      }
      if (controller.error.value != null) {
        return _ErrorMessageText(
          strings.todayMessageLoadError,
          strings: strings,
        );
      }
      final todayMessage = controller.todayMessage.value;
      if (todayMessage == null) {
        return _ErrorMessageText(strings.noMessageToday, strings: strings);
      }
      return _TodayMessageContainer(
        child: _SuccessfulMessage(message: todayMessage.content),
      );
    });
  }
}

class _SuccessfulMessage extends StatelessWidget {
  const _SuccessfulMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      message,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _TodayMessageContainer extends StatelessWidget {
  final Widget child;

  const _TodayMessageContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      constraints: BoxConstraints(minHeight: 100, minWidth: double.infinity),
      child: child,
    );
  }
}

class _ErrorMessageText extends StatelessWidget {
  final String errorText;
  final PresentationStringsRepository strings;

  const _ErrorMessageText(this.errorText, {required this.strings});

  @override
  Widget build(BuildContext context) {
    return _TodayMessageContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(errorText)),
          Image.asset(strings.supportMouseGirlSad, width: 50, height: 50),
        ],
      ),
    );
  }
}

class _CategoriesGridView extends GetView<CategoriesController> {
  final PresentationStringsRepository strings;

  const _CategoriesGridView({required this.strings});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CustomLoadingIndicator(strings: strings, fillScreen: true),
        );
      }
      if (controller.error.value != null) {
        return EmptyDataWidget(
          text: strings.categoriesLoadError,
          strings: strings,
        );
      }
      final categories = controller.categories;

      if (categories.isEmpty) {
        return EmptyDataWidget(text: strings.categoriesEmpty, strings: strings);
      }

      final List<Category> unreadCategories = categories
          .where((element) => element.readStatus == false)
          .toList();

      final List<Category> readCategories = categories
          .where((element) => element.readStatus == true)
          .toList();

      return Column(
        children: [
          _MessagesGrid(
            categories: unreadCategories,
            messageContainerColor: Theme.of(
              context,
            ).colorScheme.secondaryContainer.withAlpha(80),
          ),
          Text(
            strings.readMessagesHeading,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
          ),
          _MessagesGrid(
            categories: readCategories,
            containerTextOpacity: 150,
            messageContainerColor: Theme.of(
              context,
            ).colorScheme.tertiaryContainer.withAlpha(80),
          ),
        ],
      );
    });
  }
}

class _MessagesGrid extends StatelessWidget {
  final int containerTextOpacity;
  final List<Category> categories;
  final Color messageContainerColor;

  const _MessagesGrid({
    required this.categories,
    this.containerTextOpacity = 255,
    required this.messageContainerColor,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _MessageCategoryContainer(
          category: categories[index].name,
          read: categories[index].readStatus.toString(),
          textOpacity: containerTextOpacity,
          containerColor: messageContainerColor,
        );
      },
    );
  }
}

class _MessageCategoryContainer extends StatelessWidget {
  final String category;
  final String read;
  final int textOpacity;
  final Color containerColor;

  const _MessageCategoryContainer({
    required this.category,
    required this.read,
    this.textOpacity = 255,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final navigator = Get.find<IAppRouterService>();

    return InkWell(
      onTap: () => navigator.goToCategory(category, read),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: containerColor,
        ),
        child: Center(
          child: Text(
            category,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer.withAlpha(
                textOpacity,
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
        ),
      ),
    );
  }
}
