import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/air_quality.dart';
import 'air_quality_cache.dart';
import 'air_quality_json.dart';
import 'home_location_service.dart';

abstract interface class AirQualityDataSource {
  Future<HomeAirQuality> fetch(HomeLocation location);
}

/// The mobile app only consumes normalized IQAr data from the backend.
/// Open-Meteo, the Brazilian scale, risk rules and recommendations stay server-side.
class BackendAirQualityDataSource implements AirQualityDataSource {
  /// Tempo máximo de espera antes de usar o último índice salvo.
  static const requestTimeout = Duration(seconds: 10);

  final http.Client _client;
  final String _endpoint;

  const BackendAirQualityDataSource({
    required this._client,
    required String endpoint,
  }) : _endpoint = endpoint;

  @override
  Future<HomeAirQuality> fetch(HomeLocation location) async {
    final uri = _requestUri(location);
    final response = await _client
        .get(uri, headers: const {'Accept': 'application/json'})
        .timeout(requestTimeout);
    if (response.statusCode != 200) {
      throw StateError(
        'O backend de qualidade do ar respondeu com HTTP ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Resposta inválida do backend de qualidade do ar.',
      );
    }
    return parseHomeAirQuality(decoded, location.label);
  }

  Uri _requestUri(HomeLocation location) {
    final configuredEndpoint = _endpoint.trim();
    if (configuredEndpoint.isEmpty) {
      throw StateError(
        'Backend não configurado. Informe AIR_QUALITY_API_URL ao iniciar o app.',
      );
    }

    final endpoint = Uri.tryParse(configuredEndpoint);
    if (endpoint == null ||
        !endpoint.hasAuthority ||
        (endpoint.scheme != 'https' && endpoint.scheme != 'http')) {
      throw StateError(
        'AIR_QUALITY_API_URL precisa ser uma URL HTTP ou HTTPS.',
      );
    }

    return endpoint.replace(
      queryParameters: {
        ...endpoint.queryParameters,
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
      },
    );
  }
}

class AirQualityRepository {
  final AirQualityDataSource _dataSource;
  final AirQualityCache? _cache;

  const AirQualityRepository(this._dataSource, {this._cache});

  /// Busca o índice no backend e salva no cache. Se a consulta falhar ou
  /// passar de 10 s, devolve o último índice salvo marcado como desatualizado.
  Future<HomeAirQuality> getCurrent(HomeLocation location) async {
    try {
      final reading = await _dataSource
          .fetch(location)
          .timeout(BackendAirQualityDataSource.requestTimeout);
      await _cache?.save(reading);
      return reading;
    } catch (error) {
      final cached = await _cache?.load();
      if (cached == null) rethrow;
      return cached.copyWith(
        isStale: true,
        locationLabel: 'Último índice salvo',
      );
    }
  }
}
