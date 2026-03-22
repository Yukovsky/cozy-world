# Cozy World

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

# Cozy World

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**Cozy World** — это Flutter-приложение для управления важными датами, ежедневными сообщениями поддержки, категоризированным контентом и воспоминаниями. Проект демонстрирует best practices чистой архитектуры (Clean Architecture), работу с GraphQL, управление состоянием и локальное хранилище в Flutter.


## Содержание

1. [О проекте](#о-проекте)
2. [Что уже реализовано](#что-уже-реализовано)
3. [Технологии](#технологии)
4. [Архитектура](#архитектура)
5. [Структура репозитория](#структура-репозитория)
6. [Требования](#требования)
7. [Быстрый старт](#быстрый-старт)
8. [Установка и разработка](#установка-и-разработка)
9. [Конфигурация и секреты](#конфигурация-и-секреты)
10. [GraphQL и генерация кода](#graphql-и-генерация-кода)
11. [Тесты и качество кода](#тесты-и-качество-кода)
12. [Сборка релиза](#сборка-релиза)
13. [Вклад в проект](#вклад-в-проект)
14. [Безопасность](#безопасность)
15. [Лицензия](#лицензия)

## О проекте

Приложение построено как Android-first Flutter-проект и использует:

- Router 2.0 для декларативной навигации.
- GetX для DI и управления состоянием контроллеров.
- Ferry (GraphQL client) для запросов и мутаций к Supabase GraphQL.
- flutter_secure_storage + get_storage для хранения конфигурации и локального состояния.

Точка входа: `lib/main.dart`.

## Что уже реализовано

- Экран счетчика: расчет прошедшего времени от опорных дат (знакомство/отношения).
- Экран поддержки: сообщение дня + сетка категорий сообщений.
- Экран категории: карточки сообщений с переворотом и изменением статуса прочитано/непрочитано.
- Экран истории: свайп-карточки фото с предзагрузкой и пустыми состояниями.
- Обработка ошибок и локализованные строки в слоях data/domain/presentation.
- Инициализация зависимостей по слоям (`setupDataLayer`, `setupDomainLayer`, `setupPresentationLayer`).

## Технологии

- Язык: Dart
- Фреймворк: Flutter
- State Management / DI: GetX
- Сеть: GraphQL (Ferry + gql_http_link)
- Хранилище: flutter_secure_storage, get_storage
- UI: Lottie, flip_card, flutter_card_swiper, auto_size_text
- Линтинг: flutter_lints
- Генерация: build_runner + ferry_generator

## Архитектура

Проект организован по слоям:

- `lib/data`:
  - источники данных (локальные/статические/GraphQL),
  - реализации репозиториев,
  - сервис подключения GraphQL-клиента.
- `lib/domain`:
  - сущности,
  - интерфейсы репозиториев,
  - use-case классы.
- `lib/presentation`:
  - страницы,
  - контроллеры,
  - маршрутизация (Router 2.0),
  - общие UI-компоненты.

Особенность конфигурации: API-ключ и endpoint берутся через `String.fromEnvironment` (ключи `apiKey` и `endPointUrl`) с fallback в flutter_secure_storage.

## Структура репозитория

```text
lib/
  config/                 # DI и конфигурация зависимостей
  core/                   # тема, утилиты, расширения
  data/                   # Data Layer
    constants/            # GraphQL конфиг
    datasources/          # интерфейсы и реализации источников данных
    exceptions/           # исключения слоя данных
    implementations/       # реализации репозиториев и сервисов
    mappers/              # маппинг между слоями
    services/             # сервисы (GraphQL подключение)
    strings/              # централизованные строки данных
  domain/                 # Domain Layer
    constants/            # бизнес-константы
    entities/             # сущности (value objects)
    exceptions/           # исключения
    failures/             # типы ошибок/результатов
    repositories/         # интерфейсы репозиториев
    strings/              # строки domain слоя
    usecases/             # бизнес-логика (use cases)
  presentation/           # Presentation Layer
    exceptions/           # ошибки UI
    extensions/           # расширения (enum utils, etc)
    modules/              # экраны (по feature: counter, support, history)
    routes/               # маршрутизация
    services/             # сервисы UI (навигация)
    shared/               # переиспользуемые виджеты и утилиты
    strings/              # строки интерфейса
    utils/                # вспомогательные классы UI
  main.dart               # точка входа

packages/
  app_assets/             # централизованные ассеты и константы
  dates_api/              # интерфейс API для работы с датами
  dates_impl/             # реализация работы с датами
  strings_api/            # интерфейс API для строк
  strings_impl/           # реализация (все строки приложения)
  private_*/              # приватные пакеты (не для публикации)

assets/                   # Lottie анимации, иконки, иллюстрации

test/
  widget_test.dart        # smoke-тесты инициализации приложения

android/
  key.properties.example  # шаблон локального файла подписи
  .gitignore              # Android-специфичные игнорления

.github/
  workflows/              # GitHub Actions CI/CD

.pre-commit-config.yaml   # Pre-commit hooks для локальной разработки

analysis_options.yaml     # Dart анализ и linting правила
pubspec.yaml              # дефиниции зависимостей и метаданные
build.yaml                # конфигурация build_runner для генерации кода
```

## Требования

- Flutter SDK с поддержкой Dart `^3.10.3`.
- Android SDK (проект ориентирован на Android).
- Установленные зависимости Flutter toolchain (`flutter doctor` без критичных ошибок).

## Быстрый старт

### Предварительные условия

- Flutter SDK 3.10.3 или выше (`flutter doctor` должен пройти без критичных ошибок)
- Dart 3.10.3 или выше
- Android SDK (minSdk 21 по умолчанию)
- Git

### Клонирование и инициализация

```bash
git clone https://github.com/Yukovsky/cozy-world
cd cozy_world
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Локальная разработка

```bash
flutter run
```

### С debug-конфигурацией GraphQL

```bash
flutter run \
  --dart-define=apiKey=YOUR_SUPABASE_ANON_KEY \
  --dart-define=endPointUrl=https://your-project.supabase.co/graphql/v1
```

### Проверка качества кода

```bash
# Статический анализ
flutter analyze

# Запуск тестов
flutter test

# Форматирование кода
dart format .
```

## Установка и разработка

Подробную инструкцию см. в [INSTALL.md](INSTALL.md), которая включает:

- Установку зависимостей
- Конфигурацию локальной разработки
- Настройку подписей Android
- Инструкции по pre-commit hooks
- Типичные ошибки и их решение

**Быстро:** Если у вас уже установлены Flutter и Android SDK:

```bash
git clone https://github.com/Yukovsky/cozy-world
cd cozy_world
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Конфигурация и секреты

### Переменные окружения

API-ключ и endpoint для GraphQL можно передать тремя способами (в порядке приоритета):

1. **IDE/командная строка** (разработка):
   ```bash
   flutter run \
     --dart-define=apiKey=YOUR_KEY \
     --dart-define=endPointUrl=https://...
   ```

2. **Файл конфигурации** (`lib/config/.env`, не коммитить):
   ```
   apiKey=YOUR_SUPABASE_ANON_KEY
   endPointUrl=https://your-project.supabase.co/graphql/v1
   ```

3. **Secure storage** (fallback при запуске):
   Приложение сохраняет конфиг в защищённое хранилище `flutter_secure_storage`.

### Подписание Android

Для сборки release-версии:

1. Скопируйте [android/key.properties.example](android/key.properties.example) в `android/key.properties`.
2. Заполните реальными значениями:
   - `storePassword` — пароль keystore файла
   - `keyPassword` — пароль приватного ключа
   - `keyAlias` — alias ключа в keystore
   - `storeFile` — абсолютный путь к `keystore.jks`

3. **НИКОГДА** не коммитьте реальный `android/key.properties`.

⚠️ **Безопасность**: Если какой-либо ключ попал в публичный репозиторий, немедленно:
- Ротируйте ключ у провайдера (Supabase, и т.д.)
- Выпустите новый release
- Сообщите об инциденте в SECURITY.md

## GraphQL и генерация кода

Схема GraphQL: `lib/data/datasources/remote/graphql/schema/schema.graphql`.

Запросы и мутации:

- `lib/data/datasources/remote/graphql/queries/*.graphql`
- `lib/data/datasources/remote/graphql/mutations/*.graphql`

Генерация (`build.yaml` уже настроен):

```bash
dart run build_runner build --delete-conflicting-outputs
```

При активной разработке:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Тесты и качество кода

Проверка проекта перед commit или push:

```bash
flutter analyze
flutter test
dart format . --set-exit-if-changed
```

На данный момент в [test/widget_test.dart](test/widget_test.dart) есть smoke-test инициализации приложения.

### Pre-commit hooks

Для автоматической проверки перед каждым коммитом установите [pre-commit](https://pre-commit.com):

```bash
pip install pre-commit
pre-commit install
```

Это установит hooks для проверки:
- Форматирования Dart кода
- Статического анализа Flutter
- Утечек секретов (trufflehog, gitleaks)
- Git конфликтов и других проблем

Подробнее: [PRE_COMMIT_SETUP.md](PRE_COMMIT_SETUP.md)

### CI/CD

На каждый push и pull request:
- Запускается `flutter analyze`
- Запускаются все тесты
- Проверяется форматирование
- Сканируются потенциальные секреты
- Собирается debug APK

Workflows находятся в [.github/workflows/](.github/workflows/).

## Сборка релиза

Перед релизом Android:

1. Создать локальный `android/key.properties` по шаблону.
2. Убедиться, что keystore-файл доступен по пути `storeFile`.
3. Передать production-конфиг через `--dart-define`.

Команда сборки APK:

```bash
flutter build apk --release \
  --dart-define=apiKey=YOUR_SUPABASE_ANON_KEY \
  --dart-define=endPointUrl=https://YOUR_PROJECT.supabase.co/graphql/v1
```

Команда сборки App Bundle:

```bash
flutter build appbundle --release \
  --dart-define=apiKey=YOUR_SUPABASE_ANON_KEY \
  --dart-define=endPointUrl=https://YOUR_PROJECT.supabase.co/graphql/v1
```

## Вклад в проект

Спасибо за интерес к проекту! Инструкции для контрибьюторов описаны в [CONTRIBUTING.md](CONTRIBUTING.md).

**Быстро:**

1. Форкните репо и создайте ветку: `git checkout -b feature/ваша-фишка`
2. Убедитесь что локально работает:
   ```bash
   flutter analyze
   flutter test
   dart format . --set-exit-if-changed
   ```
3. Создайте Pull Request с описанием изменений

**Важно:** Перед PR убедитесь что нет утечек секретов:
```bash
# Pre-commit hooks проверят автоматически, или вручную:
git diff HEAD — ':(exclude)*.example' | grep -E "password|apiKey|token|secret"
```

## Безопасность

Если вы обнаружили уязвимость, **не публикуйте ее в открытом issue**.

Процесс ответственного раскрытия (responsible disclosure) описан в [SECURITY.md](SECURITY.md).

**Краткая инструкция:**
1. Отправьте приватное сообщение с описанием уязвимости
2. Укажите шаги для воспроизведения
3. Предоставьте рекомендации по исправлению

Спасибо за помощь в улучшении безопасности проекта!

## Лицензия

Проект распространяется по лицензии MIT. Подробности: [LICENSE](LICENSE).

---

### Дополнительная документация

- [INSTALL.md](INSTALL.md) — пошаговая установка и настройка
- [CONTRIBUTING.md](CONTRIBUTING.md) — как контрибьютить в проект
- [SECURITY.md](SECURITY.md) — как сообщить об уязвимостях
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — правила поведения в сообществе
- [PRE_COMMIT_SETUP.md](PRE_COMMIT_SETUP.md) — настройка pre-commit hooks
- [PRE_RELEASE_CHECKLIST.md](PRE_RELEASE_CHECKLIST.md) — чеклист перед релизом
