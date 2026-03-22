import 'package:common_locale_data/ru.dart';
import 'package:strings_api/presentation_strings_repository.dart';
import 'package:cozy_world/presentation/modules/counter/controllers/hearts_animation_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cozy_world/domain/constants/relationship_ids.dart';
import 'package:cozy_world/domain/entities/elapsed_entity.dart';
import 'package:cozy_world/presentation/shared/widgets/bottom_app_scaffold.dart';
import 'package:cozy_world/presentation/extensions/time_unit_ui_ext.dart';
import 'package:cozy_world/presentation/shared/widgets/custom_loading_indicator.dart';
import 'controllers/counter_controller.dart';

class CounterPage extends GetView<CounterController> {
  final PresentationStringsRepository strings;

  const CounterPage({super.key, required this.strings});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomAppScaffold(
      title: strings.counterPageTitle,
      strings: strings,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          controller.obx(
            (dates) => _SuccessView(dates: dates!, strings: strings),
            onLoading: Center(
              child: CustomLoadingIndicator(
                strings: strings,
                fillScreen: false,
              ),
            ),
            onError: (error) => Center(
              child: Text(
                strings.counterErrorMessage(error ?? ''),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),

          _PositionedMouse(
            asset: strings.counterMouseCurious,
            color: theme.colorScheme.primary.withAlpha(50),
            width: 100,
            height: 100,
            bottom: -50,
            left: -50,
          ),

          _PositionedMouse(
            asset: strings.counterMouseGirlSuspicious,
            color: theme.colorScheme.tertiary.withAlpha(70),
            width: 100,
            height: 100,
            turns: -1,
            top: -5,
            right: -21,
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
  final int turns;
  final double? width, height;

  const _PositionedMouse({
    required this.asset,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.color,
    this.turns = 0,
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
      child: RotatedBox(
        quarterTurns: turns,
        child: IgnorePointer(
          child: Image.asset(asset, width: width, height: height, color: color),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final Map<String, Elapsed> dates;
  final PresentationStringsRepository strings;

  const _SuccessView({required this.dates, required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Сделать смену изображения при загрузке
            _ClickableAnimation(
              controller: Get.find<HeartsAnimationController>(),
              strings: strings,
            ),

            Text(
              strings.daysSinceAcquaintance,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 15),
            _CounterContainerWrapper(
              headingText: strings.acquaintanceHeading,
              iconPath: strings.counterMouseSleep,
              iconColor: theme.colorScheme.secondary.withAlpha(40),
              iconSize: 70,
              child: _ElapsedContent(
                elapsed: dates[RelationshipIds.acquaintance]!,
                strings: strings,
              ),
            ),

            const SizedBox(height: 15),
            _CounterContainerWrapper(
              headingText: strings.relationshipHeading,
              iconPath: strings.counterMouseKiss,
              iconColor: theme.colorScheme.primary.withAlpha(40),
              iconSize: 90,
              child: _ElapsedContent(
                elapsed: dates[RelationshipIds.relationship]!,
                strings: strings,
              ),
            ),

            const SizedBox(height: 15),
            _CounterContainerWrapper(
              headingText: strings.happyMomentsHeading,
              iconPath: strings.counterMouseHappy,
              iconColor: theme.colorScheme.tertiary.withAlpha(40),
              iconSize: 70,
              child: _AlternativeContent(
                caption: strings.happyMomentsCaption,
                mainValue: strings.infinityValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClickableAnimation extends StatelessWidget {
  final HeartsAnimationController controller;
  final PresentationStringsRepository strings;

  const _ClickableAnimation({required this.controller, required this.strings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.playAnimation,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              Text(
                strings.counterGreeting,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 15.0),
              Lottie.asset(
                strings.counterCatsAnimation,
                width: 150,
                height: 150,
              ),
            ],
          ),
          Obx(() {
            if (controller.isVisible.value) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
                child: Lottie.asset(
                  strings.counterHeartsAnimation,
                  controller: controller.animationController,
                  onLoaded: (composition) {
                    controller.animationController?.duration =
                        composition.duration;
                  },
                  width: 150,
                  height: 150,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}

class _CounterContainerWrapper extends StatelessWidget {
  const _CounterContainerWrapper({
    required this.headingText,
    required this.iconPath,
    required this.iconSize,
    required this.iconColor,
    required this.child,
  });

  final String headingText;
  final String iconPath;
  final double iconSize;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(headingText, style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              child,
            ],
          ),

          Positioned.fill(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ImageIcon(
                  AssetImage(iconPath),
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ElapsedContent extends StatelessWidget {
  final Elapsed elapsed;
  final PresentationStringsRepository strings;

  const _ElapsedContent({required this.elapsed, required this.strings});

  @override
  Widget build(BuildContext context) {
    final CommonLocaleDataRu ruCld = Get.find<CommonLocaleDataRu>();
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          elapsed.days.value.toString(),
          style: theme.textTheme.displaySmall,
        ),

        Text(
          '${elapsed.days.toFormatedList(ruCld)[1]}${strings.dayUnitsContinuation}',
          style: theme.textTheme.bodySmall,
        ),

        const SizedBox(height: 10),
        Center(child: _DetailedCounterRow(elapsedDate: elapsed)),
      ],
    );
  }
}

class _AlternativeContent extends StatelessWidget {
  final String caption;
  final String mainValue;

  const _AlternativeContent({required this.caption, required this.mainValue});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mainValue, style: theme.textTheme.displaySmall),

        Text(caption, style: theme.textTheme.bodySmall),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _DetailedCounterRow extends StatelessWidget {
  final Elapsed elapsedDate;

  const _DetailedCounterRow({required this.elapsedDate});

  @override
  Widget build(BuildContext context) {
    final CommonLocaleDataRu ruCld = Get.find<CommonLocaleDataRu>();

    final List<String> hours = elapsedDate.hours.toFormatedList(ruCld);

    final List<String> minutes = elapsedDate.minutes.toFormatedList(ruCld);

    final List<String> seconds = elapsedDate.seconds.toFormatedList(ruCld);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DatePartColumn(part: hours),
        SizedBox(width: 10),
        _DatePartColumn(part: minutes),
        SizedBox(width: 10),
        _DatePartColumn(part: seconds),
      ],
    );
  }
}

class _DatePartColumn extends StatelessWidget {
  const _DatePartColumn({required this.part});

  final List<String> part;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          part[0].padLeft(2, '0'),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        Text(part[1].toUpperCase(), style: theme.textTheme.labelSmall),
      ],
    );
  }
}
