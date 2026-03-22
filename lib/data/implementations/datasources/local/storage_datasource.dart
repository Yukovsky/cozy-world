import 'package:cozy_world/data/datasources/local/i_storage_datasource.dart';
import 'package:get_storage/get_storage.dart';

/// Реализация локального хранилища на базе [GetStorage].
class StorageDatasource implements IStorageDatasource {
  final GetStorage _box;

  StorageDatasource(this._box);

  @override
  T? read<T>(String key) => _box.read(key);

  @override
  Future<void> remove(String key) async => _box.remove(key);

  @override
  Future<void> write(String key, value) async => _box.write(key, value);
}
