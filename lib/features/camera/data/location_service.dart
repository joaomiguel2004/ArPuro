import 'package:geolocator/geolocator.dart';

typedef GeoPoint = ({double latitude, double longitude});

/// Obtém a posição atual do dispositivo para anexar à denúncia.
/// Retorna `null` se o GPS estiver desligado ou a permissão for negada.
class LocationService {
  const LocationService();

  Future<GeoPoint?> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      return null;
    }
  }
}
