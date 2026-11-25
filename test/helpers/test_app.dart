import 'package:arpuro/core/auth/anonymous_auth_service.dart';
import 'package:arpuro/features/home/data/air_quality_repository.dart';
import 'package:arpuro/features/home/data/home_location_service.dart';
import 'package:arpuro/features/home/domain/air_quality.dart';
import 'package:arpuro/features/home/presentation/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const testLocation = HomeLocation(
  latitude: -10.9472,
  longitude: -37.0731,
  isLastKnown: false,
  positionTime: null,
);

HomeAirQuality fakeReading({int index = 25, bool isStale = false}) =>
    HomeAirQuality(
      index: index,
      band: AirQualityBand.good,
      bandDescription: 'A qualidade do ar está satisfatória.',
      risk: RespiratoryRisk.low,
      riskGuidance: 'Aproveite as atividades ao ar livre.',
      dominantPollutant: 'PM2.5',
      observedAt: DateTime(2026, 11, 24, 10, 0),
      isStale: isStale,
      locationLabel: 'Localização atual',
      sourceLabel: 'Teste',
      forecast: const [],
      recommendations: const [
        AirQualityRecommendation(
          category: 'activity',
          title: 'Atividades Externas',
          description: 'Liberadas para todos.',
        ),
        AirQualityRecommendation(
          category: 'hydration',
          title: 'Atenção à Hidratação',
          description: 'Beba água ao longo do dia.',
        ),
      ],
    );

class FakeAirQualityDataSource implements AirQualityDataSource {
  HomeAirQuality? reading;
  Object? error;
  int calls = 0;

  FakeAirQualityDataSource({this.reading, this.error});

  @override
  Future<HomeAirQuality> fetch(HomeLocation location) async {
    calls++;
    if (error != null) throw error!;
    return reading ?? fakeReading();
  }
}

class FakeAuthService implements AnonymousAuthService {
  int calls = 0;

  @override
  Future<String?> ensureSignedIn() async {
    calls++;
    return 'anon-test-uid';
  }
}

/// Envolve [child] num ProviderScope sem rede, GPS nem Firebase.
Widget testApp(
  Widget child, {
  AirQualityDataSource? dataSource,
  AnonymousAuthService? auth,
  bool wrapInMaterialApp = true,
}) {
  SharedPreferences.setMockInitialValues({});
  return ProviderScope(
    overrides: [
      anonymousAuthServiceProvider.overrideWithValue(auth ?? FakeAuthService()),
      homeLocationProvider.overrideWith((ref) async => testLocation),
      airQualityDataSourceProvider.overrideWithValue(
        dataSource ?? FakeAirQualityDataSource(),
      ),
    ],
    child: wrapInMaterialApp ? MaterialApp(home: child) : child,
  );
}
