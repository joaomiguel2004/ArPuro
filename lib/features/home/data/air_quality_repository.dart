import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/air_quality.dart';
import 'home_location_service.dart';

abstract interface class AirQualityDataSource {
  Future<HomeAirQuality> fetch(HomeLocation location);
}

/// The mobile app only consumes normalized IQAr data from the backend.
/// Open-Meteo, the Brazilian scale, risk rules and recommendations stay server-side.
class BackendAirQualityDataSource implements AirQualityDataSource {
  static const _requestTimeout = Duration(seconds: 12);

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
        .timeout(_requestTimeout);
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
    return _parseResponse(decoded, location.label);
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

  HomeAirQuality _parseResponse(
    Map<String, dynamic> json,
    String locationLabel,
  ) {
    final forecastData = json['forecast'];
    final recommendationsData = json['recommendations'];
    if (forecastData is! List || recommendationsData is! List) {
      throw const FormatException(
        'A resposta do backend não contém previsão e recomendações.',
      );
    }

    final index = _requiredInt(json, 'index');
    if (index < 0 || index > 400) {
      throw const FormatException('O backend retornou um IQAr fora da escala.');
    }

    return HomeAirQuality(
      index: index,
      band: AirQualityBand.fromApi(_requiredString(json, 'band')),
      bandDescription: _requiredString(json, 'bandDescription'),
      risk: RespiratoryRisk.fromApi(_requiredString(json, 'risk')),
      riskGuidance: _requiredString(json, 'riskGuidance'),
      dominantPollutant: _requiredString(json, 'dominantPollutant'),
      observedAt: DateTime.parse(_requiredString(json, 'observedAt')),
      isStale: json['isStale'] == true,
      locationLabel: locationLabel,
      sourceLabel: _requiredString(json, 'sourceLabel'),
      forecast: [
        for (final item in forecastData)
          if (item is Map<String, dynamic>)
            AirQualityForecastPoint(
              time: DateTime.parse(_requiredString(item, 'time')),
              index: _requiredInt(item, 'index'),
              band: AirQualityBand.fromApi(_requiredString(item, 'band')),
            ),
      ],
      recommendations: [
        for (final item in recommendationsData)
          if (item is Map<String, dynamic>)
            AirQualityRecommendation(
              category: _requiredString(item, 'category'),
              title: _requiredString(item, 'title'),
              description: _requiredString(item, 'description'),
            ),
      ],
    );
  }

  String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Campo "$key" ausente na resposta do backend.');
    }
    return value;
  }

  int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num || !value.isFinite) {
      throw FormatException('Campo "$key" inválido na resposta do backend.');
    }
    return value.round();
  }
}

class AirQualityRepository {
  final AirQualityDataSource _dataSource;

  const AirQualityRepository(this._dataSource);

  Future<HomeAirQuality> getCurrent(HomeLocation location) =>
      _dataSource.fetch(location);
}
