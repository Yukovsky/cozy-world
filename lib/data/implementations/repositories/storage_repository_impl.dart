import 'package:cozy_world/data/datasources/local/i_storage_datasource.dart';
import 'package:cozy_world/domain/repositories/i_storage_repository.dart';

class StorageRepositoryImpl implements IStorageRepository {
  final IStorageDatasource _dataSource;

  StorageRepositoryImpl(this._dataSource);

  @override
  T? read<T>(String key) {
    return _dataSource.read(key);
  }

  @override
  Future<void> remove(String key) async {
    _dataSource.remove(key);
  }

  @override
  Future<void> write(String key, value) async {
    _dataSource.write(key, value);
  }
}
