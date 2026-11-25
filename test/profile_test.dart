import 'package:arpuro/features/profile/domain/user_profile.dart';
import 'package:arpuro/features/profile/presentation/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Perfil novo começa como "Usuário" no nível 1', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final profile = await container.read(userProfileProvider.future);
    expect(profile.name, 'Usuário');
    expect(profile.initial, 'U');
    expect(profile.xp, 0);
    expect(profile.level.number, 1);
  });

  test(
    'Cada denúncia soma 50 XP e sobe de nível ao passar do limite',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(userProfileProvider.notifier);
      await container.read(userProfileProvider.future);

      final first = await notifier.registerReport();
      expect(first.gained, UserProfile.xpPerReport);
      expect(first.leveledUp, isFalse);

      final second = await notifier.registerReport();
      expect(second.after.xp, 100);
      expect(second.leveledUp, isTrue);
      expect(second.after.level.title, 'Vigilante do Ar');
      expect(second.after.reportCount, 2);
    },
  );

  test('Nome e XP ficam salvos no aparelho', () async {
    final first = ProviderContainer();
    await first.read(userProfileProvider.future);
    await first.read(userProfileProvider.notifier).rename('  Maria ');
    await first.read(userProfileProvider.notifier).registerReport();
    first.dispose();

    final second = ProviderContainer();
    addTearDown(second.dispose);
    final profile = await second.read(userProfileProvider.future);
    expect(profile.name, 'Maria');
    expect(profile.initial, 'M');
    expect(profile.xp, 50);
  });

  test('Nome vazio volta para o padrão', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(userProfileProvider.future);
    await container.read(userProfileProvider.notifier).rename('   ');
    expect(container.read(userProfileProvider).value?.name, 'Usuário');
  });
}
