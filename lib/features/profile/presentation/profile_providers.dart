import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../domain/user_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const ProfileRepository(),
);

/// Resultado do ganho de XP de uma denúncia, usado no modal de sucesso.
class XpGain {
  final UserProfile before;
  final UserProfile after;

  const XpGain({required this.before, required this.after});

  int get gained => after.xp - before.xp;
  bool get leveledUp => after.level.number > before.level.number;
}

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<UserProfile> build() async {
    try {
      return await _repository.load();
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<UserProfile> _current() async => state.asData?.value ?? await future;

  Future<void> rename(String name) async {
    final trimmed = name.trim();
    final updated = (await _current()).copyWith(
      name: trimmed.isEmpty ? UserProfile.defaultName : trimmed,
    );
    state = AsyncData(updated);
    await _persist(updated);
  }

  /// Soma o XP de uma denúncia enviada e devolve o antes/depois.
  Future<XpGain> registerReport() async {
    final before = await _current();
    final after = before.copyWith(
      xp: before.xp + UserProfile.xpPerReport,
      reportCount: before.reportCount + 1,
    );
    state = AsyncData(after);
    await _persist(after);
    return XpGain(before: before, after: after);
  }

  Future<void> _persist(UserProfile profile) async {
    try {
      await _repository.save(profile);
    } catch (_) {
      // Mantém o valor em memória se o armazenamento local falhar.
    }
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );
