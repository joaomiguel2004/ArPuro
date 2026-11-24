import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLocation {
  final double latitude;
  final double longitude;
  final bool isLastKnown;
  final DateTime? positionTime;
  final bool permissionPermanentlyDenied;

  const HomeLocation({
    required this.latitude,
    required this.longitude,
    required this.isLastKnown,
    required this.positionTime,
    this.permissionPermanentlyDenied = false,
  });

  HomeLocation withPermissionPermanentlyDenied() => HomeLocation(
    latitude: latitude,
    longitude: longitude,
    isLastKnown: isLastKnown,
    positionTime: positionTime,
    permissionPermanentlyDenied: true,
  );

  String get label =>
      isLastKnown ? 'Última localização conhecida' : 'Localização atual';
}

class NoHomeLocationException implements Exception {
  const NoHomeLocationException();

  @override
  String toString() =>
      'Não há uma localização conhecida. Ative a localização e tente novamente.';
}

/// Uses a fresh GPS fix when available and otherwise reuses the last position
/// saved by the operating system or by this app. It never substitutes a city.
class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();

  @override
  String toString() =>
      'Permita o acesso à localização para encontrar sua região.';
}

class LocationPermissionPermanentlyDeniedException implements Exception {
  const LocationPermissionPermanentlyDeniedException();

  @override
  String toString() =>
      'A permissão de localização foi bloqueada. Ative-a nas configurações do app.';
}

class HomeLocationService {
  static const _latitudeKey = 'home_location_latitude';
  static const _longitudeKey = 'home_location_longitude';
  static const _timeKey = 'home_location_time';

  const HomeLocationService();

  Future<HomeLocation> getLocation() async {
    final savedLocation = await _readSavedLocation();
    final platformLocation = await _readPlatformLastKnown();
    final fallback = _newerLocation(savedLocation, platformLocation);
    if (platformLocation != null && identical(fallback, platformLocation)) {
      await _saveLocation(platformLocation);
    }

    // Ask for app permission even when the device GPS toggle is off. The user
    // may still allow access now and turn location services on later.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      if (fallback != null) {
        return fallback.withPermissionPermanentlyDenied();
      }
      throw const LocationPermissionPermanentlyDeniedException();
    }
    if (permission == LocationPermission.denied) {
      return fallback ?? (throw const LocationPermissionDeniedException());
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      return fallback ?? (throw const NoHomeLocationException());
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
      final currentLocation = _fromPosition(position, isLastKnown: false);
      await _saveLocation(currentLocation);
      return currentLocation;
    } catch (_) {
      if (fallback != null) return fallback;
      throw const NoHomeLocationException();
    }
  }

  Future<HomeLocation?> _readPlatformLastKnown() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;
      return _fromPosition(position, isLastKnown: true);
    } catch (_) {
      return null;
    }
  }

  Future<HomeLocation?> _readSavedLocation() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final latitude = preferences.getDouble(_latitudeKey);
      final longitude = preferences.getDouble(_longitudeKey);
      if (latitude == null || longitude == null) return null;
      if (!_isValidCoordinate(latitude, longitude)) return null;

      final time = preferences.getInt(_timeKey);
      return HomeLocation(
        latitude: latitude,
        longitude: longitude,
        isLastKnown: true,
        positionTime: time == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(time),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveLocation(HomeLocation location) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setDouble(_latitudeKey, location.latitude);
      await preferences.setDouble(_longitudeKey, location.longitude);
      await preferences.setInt(
        _timeKey,
        (location.positionTime ?? DateTime.now()).millisecondsSinceEpoch,
      );
    } catch (_) {
      // The platform's last-known position remains available as a fallback.
    }
  }

  HomeLocation _fromPosition(Position position, {required bool isLastKnown}) {
    return HomeLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      isLastKnown: isLastKnown,
      positionTime: position.timestamp,
    );
  }

  HomeLocation? _newerLocation(HomeLocation? first, HomeLocation? second) {
    if (first == null) return second;
    if (second == null) return first;
    final firstTime =
        first.positionTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    final secondTime =
        second.positionTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    return secondTime.isAfter(firstTime) ? second : first;
  }

  bool _isValidCoordinate(double latitude, double longitude) =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}
