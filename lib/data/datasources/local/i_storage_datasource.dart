/// Контракт локального key-value хранилища в data-слое.
abstract class IStorageDatasource {
  /// Значение по ключу [key], приведенное к типу [T].
  T? read<T>(String key);

  /// Сохраняет [value] по ключу [key].
  Future<void> write(String key, dynamic value);

  /// Удаляет значение по ключу [key].
  Future<void> remove(String key);
}
