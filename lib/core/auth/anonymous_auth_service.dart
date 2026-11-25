import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Garante uma sessão anônima no Firebase, sem tela de login.
///
/// Se não houver conexão, o app continua funcionando: a sessão é criada na
/// próxima abertura com internet. O UID anônimo fica salvo pelo próprio
/// Firebase Auth no aparelho e é reaproveitado entre aberturas.
abstract interface class AnonymousAuthService {
  /// Retorna o UID da sessão anônima ou `null` se não foi possível criá-la.
  Future<String?> ensureSignedIn();
}

class FirebaseAnonymousAuthService implements AnonymousAuthService {
  static const _timeout = Duration(seconds: 8);

  final FirebaseAuth _auth;

  FirebaseAnonymousAuthService([FirebaseAuth? auth])
    : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String?> ensureSignedIn() async {
    try {
      final current = _auth.currentUser;
      if (current != null) return current.uid;
      final credential = await _auth.signInAnonymously().timeout(_timeout);
      return credential.user?.uid;
    } catch (_) {
      // Sem internet ou Firebase indisponível: segue sem sessão.
      return null;
    }
  }
}

final anonymousAuthServiceProvider = Provider<AnonymousAuthService>(
  (ref) => FirebaseAnonymousAuthService(),
);
