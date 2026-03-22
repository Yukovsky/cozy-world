import 'package:flutter/material.dart';

/// Централизованные темы и палитра приложения.
class AppTheme {
  // 🎨 ОСНОВНЫЕ ЦВЕТА ПАЛИТРЫ
  // Эти цвета взяты из твоей дизайнерской палитры
  static const Color coralPink = Color(0xFFE57373); // Коралловый/розовый
  static const Color coralDark = Color(0xFFD32F2F); // Тёмно-красный
  static const Color oliveGreen = Color(0xFF689F38); // Зелёный оливковый
  static const Color oliveLight = Color(0xFF8BC34A); // Светло-зелёный
  static const Color dustyBlue = Color(0xff87B4C0); // Голубой пыльный
  static const Color softPeach = Color(0xFFFFCCBC); // Персиковый

  // 🌞 СВЕТЛАЯ ТЕМА (Light Theme)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Material 3 по умолчанию включен во Flutter 3.16+
    brightness: Brightness.light,

    // ✨ ЦВЕТОВАЯ СХЕМА
    // Определяем все цвета вручную для максимального контроля
    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      // ОСНОВНЫЕ АКЦЕНТНЫЕ ЦВЕТА
      primary:
          coralPink, // #E57373 - Главный цвет (FAB, кнопки, активные элементы)
      onPrimary: Colors.white, // Цвет текста/иконок НА primary
      primaryContainer: Color(0xFFFFDAD6), // Светлый контейнер с primary
      onPrimaryContainer: Color(0xFF410002), // Текст на primaryContainer

      secondary:
          oliveGreen, // #689F38 - Вторичный цвет (чипы, второстепенные элементы)
      onSecondary: Colors.white, // Цвет текста НА secondary
      secondaryContainer: Color(0xFFD8E8C9), // Светлый контейнер с secondary
      onSecondaryContainer: Color(0xFF1A3700), // Текст на secondaryContainer

      tertiary: dustyBlue, // #90A4AE - Третичный цвет (вспомогательные акценты)
      onTertiary: Colors.white, // Цвет текста НА tertiary
      tertiaryContainer: Color(0xFFCFE4F4), // Светлый контейнер с tertiary
      onTertiaryContainer: Color(0xFF001E2E), // Текст на tertiaryContainer
      // ФОНЫ И ПОВЕРХНОСТИ (замена устаревшим background/surfaceVariant)
      surface:
          Colors.white, // #FFFFFF - Основная поверхность (карточки, диалоги)
      onSurface: Color(0xFF212121), // Основной текст НА поверхностях
      // Новые роли для разных уровней поверхностей
      surfaceBright: Color(0xFFFDFBFF), // Самая яркая поверхность
      surfaceDim: Color(0xFFDED9E0), // Самая тусклая поверхность
      surfaceContainerLowest: Colors.white, // Самый низкий уровень контейнера
      surfaceContainerLow: Color(0xFFF8F5FA), // Низкий уровень
      surfaceContainer: Color(0xFFF2EFF4), // Средний уровень контейнера
      surfaceContainerHigh: Color(0xFFECE9EE), // Высокий уровень
      surfaceContainerHighest: Color(
        0xFFE6E3E8,
      ), // Самый высокий (замена surfaceVariant)

      onSurfaceVariant: Color(
        0xFF757575,
      ), // Второстепенный текст на поверхностях
      // ОШИБКИ
      error: Color(0xFFB3261E), // Цвет ошибок
      onError: Colors.white, // Текст на ошибке
      errorContainer: Color(0xFFF9DEDC), // Контейнер ошибки
      onErrorContainer: Color(0xFF410E0B), // Текст на контейнере ошибки
      // КОНТУРЫ И РАЗДЕЛИТЕЛИ
      outline: Color(0xFF79757F), // Границы элементов
      outlineVariant: Color(0xFFCAC4D0), // Второстепенные границы
      // ТЕНИ И СКРИМЫ
      shadow: Color(0xFF000000), // Тень
      scrim: Color(0xFF000000), // Для полупрозрачных оверлеев
      // ИНВЕРСНЫЕ ЦВЕТА (для контрастных элементов)
      inverseSurface: Color(0xFF313033), // Инверсная поверхность
      onInverseSurface: Color(0xFFF4EFF4), // Текст на инверсной поверхности
      inversePrimary: Color(0xFFFFB2B6), // Инверсный primary
      // FIXED ЦВЕТА (константные цвета, не меняются в светлой/тёмной теме)
      primaryFixed: Color(0xFFFFDAD6),
      primaryFixedDim: Color(0xFFFFB2B6),
      onPrimaryFixed: Color(0xFF410002),
      onPrimaryFixedVariant: Color(0xFF930006),

      secondaryFixed: Color(0xFFD8E8C9),
      secondaryFixedDim: Color(0xFFBCCCAE),
      onSecondaryFixed: Color(0xFF1A3700),
      onSecondaryFixedVariant: Color(0xFF335200),

      tertiaryFixed: Color(0xFFCFE4F4),
      tertiaryFixedDim: Color(0xFFB3C8D8),
      onTertiaryFixed: Color(0xFF001E2E),
      onTertiaryFixedVariant: Color(0xFF003549),

      // ОТТЕНКИ ПОВЕРХНОСТИ (для элеваций)
      surfaceTint: coralPink, // Оттенок для показа элевации в M3
    ),

    // 📱 ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ
    scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Фон всего приложения
    // 🎭 НАСТРОЙКА КОМПОНЕНТОВ
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: coralPink,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 28,
        fontWeight: FontWeight.w300,
        letterSpacing: 1,
        color: Colors.white,
      ),
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Colors.white,
      elevation: 4,
      shadowColor: Color(0x0D000000),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: coralPink,
      foregroundColor: Colors.white,
      elevation: 4,
      hoverColor: coralDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x1A000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    // 📝 ТИПОГРАФИКА
    textTheme: const TextTheme(
      // Большие заголовки
      displayLarge: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: Color(0xFF212121),
      ),
      displayMedium: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: Color(0xFF212121),
      ),
      displaySmall: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 35,
        fontWeight: FontWeight.w400,
        color: coralPink,
      ),

      // Заголовки
      headlineLarge: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      headlineMedium: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      headlineSmall: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      // Подзаголовки
      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Color(0xFF212121),
      ),
      titleMedium: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Color(0xFF212121),
      ),

      // Основной текст
      bodyLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Color(0xFF212121),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Color(0xFF212121),
      ),
      bodySmall: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 12,
        color: Color(0xB4212121),
      ),

      // Лейблы
      labelLarge: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
        color: Color(0xB4212121), // onSurface с альфой ~180
      ),
      labelMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: Color(0xFF757575),
      ),
      labelSmall: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Color(0xB4212121),
      ),
    ),
  );

  // 🌙 ТЁМНАЯ ТЕМА (Dark Theme)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      // ОСНОВНЫЕ ЦВЕТА (адаптированы для тёмной темы)
      primary: Color(0xFFFFB2B6), // Светлее для тёмного фона
      onPrimary: Color(0xFF680005), // Тёмный текст на primary
      primaryContainer: Color(0xFF930006),
      onPrimaryContainer: Color(0xFFFFDAD6),

      secondary: Color(0xFFBCCCAE), // Светло-зелёный для тёмного фона
      onSecondary: Color(0xFF253800),
      secondaryContainer: Color(0xFF335200),
      onSecondaryContainer: Color(0xFFD8E8C9),

      tertiary: Color(0xFFB3C8D8), // Светло-голубой для тёмного фона
      onTertiary: Color(0xFF00344B),
      tertiaryContainer: Color(0xFF003549),
      onTertiaryContainer: Color(0xFFCFE4F4),

      // ПОВЕРХНОСТИ
      surface: Color(0xFF1C1B1F), // Тёмный фон
      onSurface: Color(0xFFE6E1E5), // Светлый текст

      surfaceBright: Color(0xFF3B383E),
      surfaceDim: Color(0xFF1C1B1F),
      surfaceContainerLowest: Color(0xFF0F0D13),
      surfaceContainerLow: Color(0xFF1D1B20),
      surfaceContainer: Color(0xFF211F26),
      surfaceContainerHigh: Color(0xFF2B2930),
      surfaceContainerHighest: Color(0xFF36343B),

      onSurfaceVariant: Color(0xFFCAC4D0),

      // ОШИБКИ
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFF9DEDC),

      // КОНТУРЫ
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),

      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      // ИНВЕРСНЫЕ
      inverseSurface: Color(0xFFE6E1E5),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFFE57373),

      // FIXED (те же, что в светлой теме)
      primaryFixed: Color(0xFFFFDAD6),
      primaryFixedDim: Color(0xFFFFB2B6),
      onPrimaryFixed: Color(0xFF410002),
      onPrimaryFixedVariant: Color(0xFF930006),

      secondaryFixed: Color(0xFFD8E8C9),
      secondaryFixedDim: Color(0xFFBCCCAE),
      onSecondaryFixed: Color(0xFF1A3700),
      onSecondaryFixedVariant: Color(0xFF335200),

      tertiaryFixed: Color(0xFFCFE4F4),
      tertiaryFixedDim: Color(0xFFB3C8D8),
      onTertiaryFixed: Color(0xFF001E2E),
      onTertiaryFixedVariant: Color(0xFF003549),

      surfaceTint: Color(0xFFFFB2B6),
    ),

    scaffoldBackgroundColor: const Color(0xFF1C1B1F),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF930006),
      foregroundColor: Color(0xFFFFDAD6),
    ),

    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Color(0xFF211F26),
      elevation: 4,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFFFFB2B6),
      foregroundColor: const Color(0xFF680005),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF211F26),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    // Типографика та же, только цвета адаптированы
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: Color(0xFFE6E1E5),
      ),
      // ... (остальные стили с цветом для тёмной темы)
      bodyMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Color(0xFFE6E1E5),
      ),
    ),
  );
}
