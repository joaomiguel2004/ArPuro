import 'package:camera/camera.dart' show XFile;

class CapturedPhoto {
  final XFile file;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;

  const CapturedPhoto({
    required this.file,
    required this.capturedAt,
    this.latitude,
    this.longitude,
  });

  bool get hasLocation => latitude != null && longitude != null;

  /// Ex.: "10.9472° S, 37.0731° W"
  String get coordinatesLabel {
    if (!hasLocation) return 'Localização indisponível';
    final lat = latitude!;
    final lng = longitude!;
    final latText = '${lat.abs().toStringAsFixed(4)}° ${lat < 0 ? 'S' : 'N'}';
    final lngText = '${lng.abs().toStringAsFixed(4)}° ${lng < 0 ? 'W' : 'E'}';
    return '$latText, $lngText';
  }

  /// Ex.: "09:32 (Agora)"
  String timeLabel([DateTime? now]) {
    final hh = capturedAt.hour.toString().padLeft(2, '0');
    final mm = capturedAt.minute.toString().padLeft(2, '0');
    final elapsed = (now ?? DateTime.now()).difference(capturedAt);
    return elapsed.inMinutes < 5 ? '$hh:$mm (Agora)' : '$hh:$mm';
  }
}
