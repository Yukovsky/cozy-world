import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_assets/app_assets.dart';
import 'package:strings_api/presentation_strings_repository.dart';

/// Контроллер экрана истории со свайп-карточками и предзагрузкой изображений.
class HistoryController extends GetxController {
  final PresentationStringsRepository strings;

  HistoryController(this.strings);

  /// Полный набор путей к изображениям истории.
  late final List<String> allPhotos = List.generate(
    HistoryPhotoAssets.totalPhotos,
    (index) => HistoryPhotoAssets.getPhotoPath(index + 1),
  );

  var cards = <String>[].obs;
  var swiperKey = UniqueKey().obs;

  /// Whether колода фотографий полностью просмотрена пользователем.
  var isFinished = false.obs;

  // НОВОЕ: Флаг готовности, пока картинки кэшируются
  /// Whether изображения текущей колоды уже декодированы и готовы к показу.
  RxBool isReady = false.obs;
  bool _isDisposed = false;

  @override
  void onReady() {
    super.onReady();
    preloadImages();
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _prepareCardsData();
  }

  // Только подготавливаем списки (без контекста)
  void _prepareCardsData() {
    isFinished.value = false;
    var shuffled = List<String>.from(allPhotos)..shuffle();
    cards.assignAll(shuffled);
    swiperKey.value = UniqueKey();
  }

  // НОВОЕ: Метод, который кэширует картинки в память
  /// Предзагружает изображения текущей колоды в память для плавного свайпа.
  Future<void> preloadImages() async {
    isReady.value = false; // Показываем лоадер
    final config = ImageConfiguration();

    // Проходимся по всем картинкам и декодируем их заранее
    for (final String path in cards) {
      if (_isDisposed) {
        break;
      }
      final provider = AssetImage(path, package: 'app_assets');
      final stream = provider.resolve(config);
      final completer = Completer<void>();
      final ImageStreamListener listener = ImageStreamListener(
        (ImageInfo info, bool syncCall) {
          if (!completer.isCompleted) completer.complete();
        },
        onError: (dynamic error, StackTrace? stack) {
          if (completer.isCompleted) completer.complete();
        },
      );
      stream.addListener(listener);
      try {
        await completer.future;
      } catch (_) {
        stream.removeListener(listener);
      }
      if (!_isDisposed) isReady.value = true;
    }
  }

  // Обновленный метод обновления (нужен контекст для кэширования)
  /// Пересоздает колоду и повторно предзагружает изображения.
  Future<void> refreshCards() async {
    _prepareCardsData();
    await preloadImages();
  }

  /// Помечает текущую колоду как завершенную.
  void setFinished() {
    isFinished.value = true;
  }
}
