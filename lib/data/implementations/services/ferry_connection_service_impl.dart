import 'package:cozy_world/data/exceptions/credentials_exception.dart';
import 'package:cozy_world/data/services/i_connection_service.dart';
import 'package:ferry/ferry.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:cozy_world/domain/repositories/i_config_repository.dart';
import 'package:strings_api/data_strings_repository.dart';
import 'package:cozy_world/data/datasources/remote/graphql/schema/generated/schema.schema.gql.dart'
    show possibleTypesMap;

/// Сервис инициализации и управления жизненным циклом Ferry GraphQL-клиента.
class FerryConnectionService implements IConnectionService {
  final IConfigRepository _configRepository;
  final DataStringsRepository _strings;
  late Client _client;

  @override
  /// Активный GraphQL-клиент.
  Client get getClient {
    if (!isReady) {
      throw Exception(_strings.graphQlClientNotInitialized);
    }
    return _client;
  }

  @override
  bool isReady = false;

  FerryConnectionService(this._configRepository, this._strings);

  /// Инициализация клиента при старте приложения
  @override
  Future<void> initClient() async {
    if (isReady) {
      return;
    }

    final apiKey = await _configRepository.getApiKey();
    final endpoint = await _configRepository.getEndPoint();

    if (apiKey.isEmpty || endpoint.isEmpty) {
      throw CredentialsException(_strings.apiCredentialsNotConfigured);
    }

    final link = HttpLink(
      endpoint,
      defaultHeaders: {'apikey': apiKey, 'Authorization': 'Bearer $apiKey'},
    );

    final cache = Cache(possibleTypes: possibleTypesMap);
    _client = Client(link: link, cache: cache);

    isReady = true;
  }

  /// Пересоздать клиент (когда обновляются конфиги)
  @override
  Future<void> reinitClient() async {
    isReady = false;
    await initClient();
  }

  @override
  /// Очищает GraphQL-кэш клиента, если клиент инициализирован.
  void clearCache() {
    if (isReady) {
      _client.cache.clear();
    }
  }
}
