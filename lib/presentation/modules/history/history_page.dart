import 'dart:math' as math;
import 'dart:ui';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:flutter/material.dart';
import 'package:cozy_world/presentation/shared/widgets/bottom_app_scaffold.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:cozy_world/presentation/shared/widgets/custom_loading_indicator.dart';
import 'package:cozy_world/presentation/shared/widgets/empty_data_widget.dart';
import 'package:cozy_world/presentation/modules/history/history_controller.dart';

/// Страница истории со свайп-карточками фотографий.
class HistoryPage extends StatelessWidget {
  final PresentationStringsRepository strings;

  const HistoryPage({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return BottomAppScaffold(
      title: strings.historyPageTitle,
      strings: strings,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PhotoSwipeScreen(
            swiperController: Get.find<CardSwiperController>(),
            strings: strings,
          ),

          _PositionedMouse(
            asset: strings.historyCatPrint,
            color: Theme.of(context).colorScheme.primary.withAlpha(60),
            width: 75,
            height: 75,
            right: -30,
            top: 150,
            angle: -math.pi / 4,
          ),

          _PositionedMouse(
            asset: strings.historyCatCouple,
            color: Theme.of(context).colorScheme.secondary.withAlpha(50),
            bottom: -15,
            left: 20,
            width: 80,
            height: 80,
          ),

          _PositionedMouse(
            asset: strings.historyCatPaw,
            color: Theme.of(context).colorScheme.tertiary.withAlpha(70),
            top: 15,
            left: 25,
            width: 65,
            height: 65,
            angle: -math.pi / 1.4,
          ),
        ],
      ),
    );
  }
}

class _PositionedMouse extends StatelessWidget {
  final String asset;
  final double? top, bottom, left, right;
  final Color color;
  final double angle;
  final double? width, height;

  const _PositionedMouse({
    required this.asset,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.color,
    this.angle = 0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      bottom: bottom,
      left: left,
      child: Transform.rotate(
        angle: angle,
        child: IgnorePointer(
          child: Image.asset(asset, width: width, height: height, color: color),
        ),
      ),
    );
  }
}

class PhotoSwipeScreen extends GetView<HistoryController> {
  final CardSwiperController swiperController;
  final PresentationStringsRepository strings;

  const PhotoSwipeScreen({
    super.key,
    required this.swiperController,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshCards(),
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Обязательно для работы RefreshIndicator
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    // Устанавливаем минимальную высоту равной высоте доступного пространства
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            strings.historyMessage,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            strings.historyInstructionText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // СЛОЙ С КАРТОЧКАМИ
          Obx(() {
            // НОВОЕ: Если картинки еще кэшируются, показываем экран загрузки
            if (!controller.isReady.value && !controller.isFinished.value) {
              return Center(
                child: CustomLoadingIndicator(
                  strings: strings,
                  fillScreen: true,
                ),
              );
            }

            if (!controller.isFinished.value && controller.cards.isEmpty) {
              return EmptyDataWidget(
                text: strings.historyEmptyStateMessage,
                strings: strings,
              );
            }

            if (controller.isFinished.value && controller.cards.isEmpty) {
              return const SizedBox.shrink();
            }

            return Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 20,
                ),
                child: CardSwiper(
                  key: controller.swiperKey.value,
                  controller: swiperController,
                  cardsCount: controller.cards.length,
                  isLoop: false,
                  allowedSwipeDirection: const AllowedSwipeDirection.all(),
                  scale: 0.9,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                        return SmartPhotoCard(
                          imagePath: controller.cards[index],
                        );
                      },
                  onEnd: () {
                    controller.setFinished();
                  },
                  onSwipe: (previousIndex, currentIndex, direction) {
                    return true;
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SmartPhotoCard extends StatelessWidget {
  final String imagePath;

  const SmartPhotoCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Закругленные углы карточки
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                package: 'app_assets',
              ),
            ),
          ),
          // Затемнение
          Positioned.fill(child: Container(color: Colors.black.withAlpha(20))),

          // СЛОЙ 2: Основное фото (вписывается в границы, не обрезаясь)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, // Важно: сохраняет пропорции
              package: 'app_assets',
            ),
          ),
        ],
      ),
    );
  }
}
