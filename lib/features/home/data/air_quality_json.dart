import '../domain/air_quality.dart';

/// Conversão entre o JSON do backend e o modelo da Home. O mesmo formato é
/// usado para guardar o último índice no cache local.
HomeAirQuality parseHomeAirQuality(
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

Map<String, dynamic> homeAirQualityToJson(HomeAirQuality reading) => {
  'index': reading.index,
  'band': reading.band.name,
  'bandDescription': reading.bandDescription,
  'risk': reading.risk.name,
  'riskGuidance': reading.riskGuidance,
  'dominantPollutant': reading.dominantPollutant,
  'observedAt': reading.observedAt.toIso8601String(),
  'isStale': reading.isStale,
  'sourceLabel': reading.sourceLabel,
  'forecast': [
    for (final point in reading.forecast)
      {
        'time': point.time.toIso8601String(),
        'index': point.index,
        'band': point.band.name,
      },
  ],
  'recommendations': [
    for (final item in reading.recommendations)
      {
        'category': item.category,
        'title': item.title,
        'description': item.description,
      },
  ],
};
