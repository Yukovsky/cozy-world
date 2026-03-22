import 'package:cozy_world/data/constants/graphql_config.dart';
import 'package:cozy_world/data/datasources/local/i_secure_storage_datasource.dart';
import 'package:cozy_world/domain/repositories/i_config_repository.dart';

/// Реализация [IConfigRepository] с кэшированием и fallback к `dart-define`.
class ConfigRepositoryImpl implements IConfigRepository {
  final ISecureStorageDataSource _secureDataSource;

  String? _apiKey;
  String? _endpoint;

  ConfigRepositoryImpl(this._secureDataSource);

  @override
  /// API-ключ из памяти, secure storage или `String.fromEnvironment`.
  Future<String> getApiKey() async {
    if (_apiKey != null && _apiKey!.isNotEmpty) return _apiKey!;

    final String? stored = await _secureDataSource.getApiKey();
    if (stored != null && stored.isNotEmpty) {
      _apiKey = stored;
      return stored;
    }

    final String defaultApiKey = const String.fromEnvironment(
      GraphQLConfig.apiKeyKey,
    );

    if (defaultApiKey.isNotEmpty) {
      await _secureDataSource.setApiKey(defaultApiKey);
    }
    _apiKey = defaultApiKey;
    return defaultApiKey;
  }

  @override
  /// Endpoint URL из памяти, secure storage или `String.fromEnvironment`.
  Future<String> getEndPoint() async {
    if (_endpoint != null && _endpoint!.isNotEmpty) return _endpoint!;

    final String? stored = await _secureDataSource.getEndPoint();
    if (stored != null && stored.isNotEmpty) {
      _endpoint = stored;
      return stored;
    }

    final String defaultEndPoint = const String.fromEnvironment(
      GraphQLConfig.endPointKey,
    );

    if (defaultEndPoint.isNotEmpty) {
      await _secureDataSource.setEndPoint(defaultEndPoint);
    }
    _endpoint = defaultEndPoint;
    return defaultEndPoint;
  }
}
