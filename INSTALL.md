# Установка и настройка разработки

## Требования

- **Flutter SDK**: 3.10.3 или новее ([установить](https://flutter.dev/docs/get-started/install))
- **Dart**: 3.10.3+ (входит в Flutter)
- **Android SDK**: minSdk 21+ (для разработки Android)
- **Git**: 2.30+
- **Python**: 3.8+ (для pre-commit hooks)

Проверить установку:
```bash
flutter doctor
```

## Клонирование репозитория

```bash
git clone https://github.com/Yukovsky/cozy-world
cd cozy_world
```

## Установка зависимостей

```bash
# Получить Flutter/Dart пакеты
flutter pub get

# Генерировать код (Firebase, GraphQL и т.д.)
dart run build_runner build --delete-conflicting-outputs
```

## Конфигурирование локальных секретов

### 1. Конфигурация Supabase

Скопировать шаблон `.env`:
```bash
cp lib/config/.env.example lib/config/.env
```

Отредактировать `lib/config/.env` с реальными учётными данными Supabase (никогда не коммитить):
```
apiKey=YOUR_ACTUAL_SUPABASE_ANON_KEY
endPointUrl=https://your-project.supabase.co/graphql/v1
```

### 2. Подпись Android приложения (для релиз-сборок)

Скопировать шаблон конфигурации keystore:
```bash
cp android/key.properties.example android/key.properties
```

Отредактировать `android/key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=/absolute/path/to/your/keystore.jks
```

⚠️ **ВНИМАНИЕ**: Никогда не коммитте `lib/config/.env` или `android/key.properties`. Они указаны в `.gitignore`.

## Настройка Pre-Commit Hooks

Pre-commit hooks автоматически проверяют ваш код перед каждым коммитом, перехватывая типичные ошибки:

### Установить pre-commit фреймворк

```bash
# macOS / Linux
$ pip3 install pre-commit
# или с помощью homebrew
$ brew install pre-commit

# Windows (PowerShell)
$ pip install pre-commit
```

### Установить git hooks из конфигурации

```bash
pre-commit install
```

Это прочитает `.pre-commit-config.yaml` и установит hooks в `.git/hooks/`.

### Тестировать hooks вручную

```bash
# Запустить все hooks на всех файлах
pre-commit run --all-files

# Запустить конкретный hook
pre-commit run flutter-format --all-files
```

### Пропустить hooks (не рекомендуется)

```bash
git commit --no-verify
```

## Рабочий процесс разработки

### Запустить приложение

```bash
# Отладочный запуск
flutter run

# С пользовательским endpoint GraphQL
flutter run \
  --dart-define=apiKey=YOUR_TEST_KEY \
  --dart-define=endPointUrl=https://your-project.supabase.co/graphql/v1

# если настроили .env файл
flutter run --dart-define-from-file=lib/config/.env
```

### Проверки качества кода

```bash
# Статический анализ (linting)
flutter analyze

# Форматировать код
dart format .

# Запустить тесты
flutter test

# Сгенерировать отчёт покрытия
flutter test --coverage
```

### Режим наблюдения при разработке

Держите генерирование кода запущенным при редактировании:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Сборка релизов

### Android APK

```bash
flutter build apk --release \
  --dart-define=apiKey=PROD_SUPABASE_KEY \
  --dart-define=endPointUrl=https://your-project.supabase.co/graphql/v1
```

Выход: `build/app/outputs/apk/release/app-release.apk`

### Android App Bundle (для Google Play)

```bash
flutter build appbundle --release \
  --dart-define=apiKey=PROD_SUPABASE_KEY \
  --dart-define=endPointUrl=https://your-project.supabase.co/graphql/v1
```

Выход: `build/app/outputs/bundle/release/app-release.aab`

## Структура проекта

Смотрите [README.md](README.md#структура-репозитория) для полных деталей структуры проекта.

## Устранение проблем

### Проблемы с кешем сборки

```bash
# Очистить всё
flutter clean

# Перегенерировать pubspec.lock
flutter pub get

# Пересобрать сгенерированные файлы
dart run build_runner build --delete-conflicting-outputs
```

### Проблемы Gradle (Android)

```bash
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Проблемы Dart Analyzer

```bash
# Сбросить анализ Dart
rm -rf .dart_tool
flutter pub get
flutter analyze
```

### Проблемы с Pre-Commit

```bash
# Удалить hooks
pre-commit uninstall

# Переустановить
pre-commit install
```

## Участие в разработке

Смотрите [CONTRIBUTING.md](CONTRIBUTING.md) для руководства по отправке PR.

## Безопасность

Никогда не коммитте секреты! Смотрите [SECURITY.md](SECURITY.md) для отчётов об уязвимостях.

## Поддержка

Если вы столкнулись с проблемами:

1. Проверьте существующие [GitHub Issues](https://github.com/YOUR_USERNAME/cozy_world/issues)
2. Убедитесь что `flutter doctor` проходит успешно
3. Попробуйте `flutter clean && flutter pub get`
4. Проверьте логи CI при падении PR сборок
