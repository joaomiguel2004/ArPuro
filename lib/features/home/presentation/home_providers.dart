import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/air_quality_repository.dart';
import '../data/home_location_service.dart';
import '../domain/air_quality.dart';

final homeLocationServiceProvider = Provider<HomeLocationService>(
  (ref) => const HomeLocationService(),
);

final homeLocationProvider = FutureProvider<HomeLocation>(
  (ref) => ref.watch(homeLocationServiceProvider).getLocation(),
);

final airQualityHttpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final airQualityDataSourceProvider = Provider<AirQualityDataSource>(
  (ref) => BackendAirQualityDataSource(
    client: ref.watch(airQualityHttpClientProvider),
    endpoint: const String.fromEnvironment('AIR_QUALITY_API_URL'),
  ),
);

final airQualityRepositoryProvider = Provider<AirQualityRepository>(
  (ref) => AirQualityRepository(ref.watch(airQualityDataSourceProvider)),
);

final homeAirQualityProvider = FutureProvider<HomeAirQuality>((ref) async {
  final location = await ref.watch(homeLocationProvider.future);
  return ref.watch(airQualityRepositoryProvider).getCurrent(location);
});
