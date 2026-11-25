/// Perfil do usuário guardado apenas no aparelho (RNF02 — privacidade).
class UserProfile {
  static const defaultName = 'Usuário';
  static const xpPerReport = 50;

  final String name;
  final int xp;
  final int reportCount;

  const UserProfile({
    this.name = defaultName,
    this.xp = 0,
    this.reportCount = 0,
  });

  String get initial {
    final trimmed = name.trim();
    return trimmed.isEmpty
        ? 'U'
        : String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  UserLevel get level => UserLevel.forXp(xp);

  /// XP acumulado dentro do nível atual.
  int get xpInLevel => xp - level.minXp;

  /// XP necessário para sair do nível atual (ou o total do último nível).
  int get xpForLevel => level.span;

  UserProfile copyWith({String? name, int? xp, int? reportCount}) =>
      UserProfile(
        name: name ?? this.name,
        xp: xp ?? this.xp,
        reportCount: reportCount ?? this.reportCount,
      );
}

class UserLevel {
  final int number;
  final String title;
  final int minXp;
  final int span;

  const UserLevel._(this.number, this.title, this.minXp, this.span);

  static const levels = [
    UserLevel._(1, 'Observador', 0, 100),
    UserLevel._(2, 'Vigilante do Ar', 100, 200),
    UserLevel._(3, 'Guardião do Bairro', 300, 300),
    UserLevel._(4, 'Protetor Ambiental', 600, 400),
    UserLevel._(5, 'Embaixador do Ar Puro', 1000, 500),
  ];

  bool get isLast => number == levels.last.number;

  static UserLevel forXp(int xp) {
    var result = levels.first;
    for (final level in levels) {
      if (xp >= level.minXp) result = level;
    }
    return result;
  }
}
