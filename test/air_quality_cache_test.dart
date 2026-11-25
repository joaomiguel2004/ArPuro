import 'dart:async';

import 'package:arpuro/features/home/data/air_quality_cache.dart';
import 'package:arpuro/features/home/data/air_quality_repository.dart';
import 'package:arpuro/features/home/data/home_location_service.dart';
import 'package:arpuro/features/home/domain/air_quality.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/test_app.dart';

class _HangingDataSource implements AirQualityDataSource {
  @override
  Future<HomeAirQuality> fetch(HomeLocation location) =>
      Completer<HomeAirQuality>().future;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Salva o índice e usa o cache marcado como desatualizado se a API falhar',
    () async {
      final source = FakeAirQualityDataSource(reading: fakeReading(index: 42));
      final repository = AirQualityRepository(
        source,
        cache: const AirQualityCache(),
      );

      final online = await repository.getCurrent(testLocation);
      expect(online.index, 42);
      expect(online.isStale, isFalse);

      source.error = Exception('sem internet');
      final offline = await repository.getCurrent(testLocation);
      expect(offline.index, 42);
      expect(offline.isStale, isTrue);
      expect(offline.risk, RespiratoryRisk.low);
      expect(offline.recommendations, hasLength(2));
    },
  );

  test('Sem cache, o erro da API é repassado', () async {
    final repository = AirQualityRepository(
      FakeAirQualityDataSource(error: Exception('sem internet')),
      cache: const AirQualityCache(),
    );
    expect(repository.getCurrent(testLocation), throwsException);
  });

  test('Timeout de 10 s cai para o cache', () async {
    await const AirQualityCache().save(fakeReading(index: 77));
    final repository = AirQualityRepository(
      _HangingDataSource(),
      cache: const AirQualityCache(),
    );
    expect(
      BackendAirQualityDataSource.requestTimeout,
      const Duration(seconds: 10),
    );
    final result = await repository
        .getCurrent(testLocation)
        .timeout(const Duration(seconds: 12));
    expect(result.index, 77);
    expect(result.isStale, isTrue);
  }, timeout: const Timeout(Duration(seconds: 20)));
}
