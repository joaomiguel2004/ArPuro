enum AirQualityBand {
  good,
  moderate,
  poor,
  veryPoor,
  severe;

  String get label => switch (this) {
    AirQualityBand.good => 'Boa',
    AirQualityBand.moderate => 'Moderada',
    AirQualityBand.poor => 'Ruim',
    AirQualityBand.veryPoor => 'Muito Ruim',
    AirQualityBand.severe => 'Péssima',
  };

  int get colorValue => switch (this) {
    AirQualityBand.good => 0xFF009966,
    AirQualityBand.moderate => 0xFFE0B400,
    AirQualityBand.poor => 0xFFFF9933,
    AirQualityBand.veryPoor => 0xFFCC0033,
    AirQualityBand.severe => 0xFF660099,
  };

  static AirQualityBand fromApi(String value) => switch (value) {
    'good' => AirQualityBand.good,
    'moderate' => AirQualityBand.moderate,
    'poor' => AirQualityBand.poor,
    'veryPoor' => AirQualityBand.veryPoor,
    'severe' => AirQualityBand.severe,
    _ => throw FormatException('Faixa de IQAr desconhecida: $value'),
  };
}

enum RespiratoryRisk {
  low,
  moderate,
  high,
  critical;

  String get label => switch (this) {
    RespiratoryRisk.low => 'Baixo',
    RespiratoryRisk.moderate => 'Moderado',
    RespiratoryRisk.high => 'Alto',
    RespiratoryRisk.critical => 'Crítico',
  };

  String get title => 'Risco Respiratório $label';

  int get colorValue => switch (this) {
    RespiratoryRisk.low => 0xFF059669,
    RespiratoryRisk.moderate => 0xFFD97706,
    RespiratoryRisk.high => 0xFFEA580C,
    RespiratoryRisk.critical => 0xFFDC2626,
  };

  int get backgroundColorValue => switch (this) {
    RespiratoryRisk.low => 0xFFECFDF5,
    RespiratoryRisk.moderate => 0xFFFFFBEB,
    RespiratoryRisk.high => 0xFFFFF7ED,
    RespiratoryRisk.critical => 0xFFFEF2F2,
  };

  static RespiratoryRisk fromApi(String value) => switch (value) {
    'low' => RespiratoryRisk.low,
    'moderate' => RespiratoryRisk.moderate,
    'high' => RespiratoryRisk.high,
    'critical' => RespiratoryRisk.critical,
    _ => throw FormatException('Risco respiratório desconhecido: $value'),
  };
}

class AirQualityForecastPoint {
  final DateTime time;
  final int index;
  final AirQualityBand band;

  const AirQualityForecastPoint({
    required this.time,
    required this.index,
    required this.band,
  });
}

class HomeAirQuality {
  final int index;
  final AirQualityBand band;
  final String bandDescription;
  final RespiratoryRisk risk;
  final String riskGuidance;
  final String dominantPollutant;
  final DateTime observedAt;
  final bool isStale;
  final String locationLabel;
  final String sourceLabel;
  final List<AirQualityForecastPoint> forecast;
  final List<AirQualityRecommendation> recommendations;

  const HomeAirQuality({
    required this.index,
    required this.band,
    required this.bandDescription,
    required this.risk,
    required this.riskGuidance,
    required this.dominantPollutant,
    required this.observedAt,
    required this.isStale,
    required this.locationLabel,
    required this.sourceLabel,
    required this.forecast,
    required this.recommendations,
  });

  String get qualityDescription => bandDescription;

  HomeAirQuality copyWith({bool? isStale, String? locationLabel}) {
    return HomeAirQuality(
      index: index,
      band: band,
      bandDescription: bandDescription,
      risk: risk,
      riskGuidance: riskGuidance,
      dominantPollutant: dominantPollutant,
      observedAt: observedAt,
      isStale: isStale ?? this.isStale,
      locationLabel: locationLabel ?? this.locationLabel,
      sourceLabel: sourceLabel,
      forecast: forecast,
      recommendations: recommendations,
    );
  }
}

class AirQualityRecommendation {
  final String category;
  final String title;
  final String description;

  const AirQualityRecommendation({
    required this.category,
    required this.title,
    required this.description,
  });
}
