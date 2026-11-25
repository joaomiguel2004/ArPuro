import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/air_quality.dart';
import 'air_quality_json.dart';

/// Guarda o último índice recebido para exibir quando o backend não responde.
class AirQualityCache {
  static const _key = 'air_quality_last_reading';

  const AirQualityCache();

  Future<void> save(HomeAirQuality reading) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        _key,
        jsonEncode(homeAirQualityToJson(reading)),
      );
    } catch (_) {
      // Sem cache disponível; a próxima leitura tenta salvar de novo.
    }
  }

  Future<HomeAirQuality?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return parseHomeAirQuality(decoded, 'Último índice salvo');
    } catch (_) {
      return null;
    }
  }
}
