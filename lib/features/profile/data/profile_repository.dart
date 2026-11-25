import 'package:shared_preferences/shared_preferences.dart';

import '../domain/user_profile.dart';

/// Salva nome, XP e número de denúncias só no aparelho (`shared_preferences`).
/// Nada disso é enviado ao Firebase.
class ProfileRepository {
  static const _nameKey = 'profile_name';
  static const _xpKey = 'profile_xp';
  static const _reportCountKey = 'profile_report_count';

  const ProfileRepository();

  Future<UserProfile> load() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString(_nameKey)?.trim();
    return UserProfile(
      name: name == null || name.isEmpty ? UserProfile.defaultName : name,
      xp: preferences.getInt(_xpKey) ?? 0,
      reportCount: preferences.getInt(_reportCountKey) ?? 0,
    );
  }

  Future<void> save(UserProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, profile.name);
    await preferences.setInt(_xpKey, profile.xp);
    await preferences.setInt(_reportCountKey, profile.reportCount);
  }
}
