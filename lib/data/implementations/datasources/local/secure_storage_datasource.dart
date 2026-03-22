import 'package:cozy_world/data/constants/graphql_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cozy_world/data/datasources/local/i_secure_storage_datasource.dart';

/// Реализация безопасного хранения конфигурации на базе [FlutterSecureStorage].
class SecureStorageDatasource implements ISecureStorageDataSource {
  final FlutterSecureStorage _storage;

  SecureStorageDatasource(this._storage);

  @override
  Future<String?> getApiKey() => _storage.read(key: GraphQLConfig.apiKeyKey);

  @override
  Future<String?> getEndPoint() =>
      _storage.read(key: GraphQLConfig.endPointKey);

  @override
  Future<void> setApiKey(String apiKey) =>
      _storage.write(key: GraphQLConfig.apiKeyKey, value: apiKey);

  @override
  Future<void> setEndPoint(String endPoint) =>
      _storage.write(key: GraphQLConfig.endPointKey, value: endPoint);
}
