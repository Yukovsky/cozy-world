# Руководство по настройке Pre-Commit

## Что такое Pre-Commit?

Pre-commit - это фреймворк, который запускает проверки качества перед каждым коммитом, перехватывая:
- Секреты/учётные данные
- Проблемы форматирования кода
- Синтаксические ошибки
- Большие файлы
- Конфликты Git
- Проблемы, специфичные для Dart/Flutter

## Установка

### Шаг 1: Установить Python (если ещё не установлен)

```bash
# macOS с Homebrew
brew install python3

# Linux (Debian/Ubuntu)
sudo apt-get install python3 python3-pip

# Windows (PowerShell)
# Загрузить с python.org или используйте Windows Store
python --version
```

### Шаг 2: Установить pre-commit

```bash
pip3 install pre-commit
# или
pip install pre-commit

# Проверить
pre-commit --version
```

### Шаг 3: Установить Git Hooks

```bash
cd cozy_world
pre-commit install
```

Это создаст `.git/hooks/pre-commit` на основе `.pre-commit-config.yaml`.

### Шаг 4: Проверить установку

```bash
# Тестировать все hooks на всех файлах
pre-commit run --all-files

# Ожидаемый результат: проверки форматирования, секретов, синтоксических ошибок и т.д.
```

## Использование Pre-Commit

### Автоматический режим (рекомендуется)

Hooks запускаются автоматически перед каждым коммитом:

```bash
git add .
git commit -m "feat: add feature"
# Pre-commit hooks запускаются автоматически здесь
```

Если какой-либо hook не пройдёт, коммит заблокируется. Исправьте проблемы и повторите попытку.

### Ручные триггеры

```bash
# Запустить все hooks на всех файлах
pre-commit run --all-files

# Запустить конкретный hook
pre-commit run flutter-analyze --all-files
# пока отключено - pre-commit run trufflehog --all-files
pre-commit run detect-private-key --all-files

# Запустить только на подготовленных файлах (как при коммите)
pre-commit run
```

## Обработка ошибок

### Проблемы форматирования кода

Если `flutter-format` не пройдёт:

```bash
# Автоматически исправить форматирование
dart format .

# Попробовать коммит снова
git add lib/
git commit -m "feat: message"
```

### Обнаружены секреты

Если `detect-private-key` или `trufflehog` не пройдут:

```bash
# Удалить секрет из подготовленных изменений
git reset HEAD lib/config/.env

# Удалить файл секрета (никогда не коммитте его)
rm lib/config/.env

# Использовать шаблон вместо этого
cp lib/config/.env.example lib/config/.env

# Обновить .gitignore при необходимости
git add .gitignore
```

### Dart Analysis не пройдена

Если `flutter-analyze` не пройдёт:

```bash
# Посмотреть вывод анализа Flutter
flutter analyze

# Исправить выявленные проблемы вручную, затем:
git add lib/
git commit -m "fix: address lint issues"
```

## Пропуск Hooks (используйте осторожно)

Иногда нужно пропустить проверки:

```bash
# Пропустить ВСЕ проверки
git commit --no-verify

# Или селективно отключить при следующем редактировании .pre-commit-config.yaml
# (отметьте hook с 'stages: [manual]')
```

⚠️ **Внимание**: Пропускайте только если абсолютно необходимо. Секреты могут утечь!

## Обновление Hooks

Обновляйте версии hooks периодически:

```bash
pre-commit autoupdate
git add .pre-commit-config.yaml
git commit -m "chore: update pre-commit hooks"
```

## Удаление Pre-Commit

Если вы хотите удалить hooks:

```bash
pre-commit uninstall

# Чтобы переустановить позже
pre-commit install
```

## Устранение проблем

### Hooks не запускаются

```bash
# Проверить установку
ls -la .git/hooks/pre-commit

# Переустановить
pre-commit uninstall
pre-commit install
```

### Ошибки "command not found"

```bash
# Проверить что Python и pre-commit в PATH
which python3
which pre-commit

# Или используйте полные пути
/usr/local/bin/python3 -m pre-commit run --all-files
```

### Hooks запускаются очень медленно

Некоторые проверки (Trivy, Gitleaks) могут быть медленными на первом запуске:

```bash
# Кеш построен, будет быстрее в следующий раз
# Или запустите сначала специфичные быстрые hooks
pre-commit run trailing-whitespace mixed-line-ending --all-files
```

### Файл `.env` проверяется несмотря на суффикс .example

Убедитесь что `.pre-commit-config.yaml` содержит:
```yaml
exclude: \.example$
```

## Интеграция с CI

GitHub Actions workflows также запускают эти проверки, поэтому:
- Локальные ошибки pre-commit = вероятно ошибки CI тоже
- Исправьте локально сначала с `pre-commit run --all-files`
- Затем push чтобы сэкономить CI минуты

## Координация команды

Убедитесь что все члены команды:

```bash
# Установить ту же версию
pip install pre-commit==3.5.0

# Установить hooks
pre-commit install

# Запустить чтобы проверить одинаковое поведение
pre-commit run --all-files
```

Коммитить `.pre-commit-config.yaml` чтобы обеспечить согласованность.

---

Подробнее: https://pre-commit.com
