import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Opciones de "relación con Pijiño" (segmentos del documento del proyecto).
const List<String> kRelaciones = [
  'Habitante',
  'Visitante / turista',
  'Estudiante',
  'Docente',
  'Comerciante / emprendedor',
  'Oriundo que vive fuera',
  'Gestor cultural',
];

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String relation;
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.relation,
    required this.createdAt,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> m) {
    final ts = m['creadoEn'];
    return UserProfile(
      uid: uid,
      name: (m['nombre'] ?? '').toString(),
      email: (m['correo'] ?? '').toString(),
      phone: (m['telefono'] ?? '').toString(),
      relation: (m['relacion'] ?? '').toString(),
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}

/// Error con mensaje listo para mostrar al usuario.
class AuthFailure implements Exception {
  final String message;
  final String code;
  AuthFailure(this.message, [this.code = '']);
  @override
  String toString() => message;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('usuarios');

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ---------------------------------------------------------------- registro
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String relation,
  }) async {
    UserCredential cred;
    try {
      cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    } catch (e) {
      throw AuthFailure('No se pudo crear la cuenta. Intenta de nuevo.');
    }

    final user = cred.user!;
    try {
      await user.updateDisplayName(name.trim());
    } catch (_) {}
    try {
      await user.sendEmailVerification();
    } catch (_) {}

    // Guarda al usuario en Firestore. Si falla (p. ej. reglas), se reintenta
    // automáticamente en el siguiente inicio de sesión (ensureProfile).
    try {
      await _users.doc(user.uid).set({
        'nombre': name.trim(),
        'correo': email.trim().toLowerCase(),
        'telefono': phone.trim(),
        'relacion': relation,
        'aceptoTerminos': true,
        'creadoEn': FieldValue.serverTimestamp(),
        'ultimoAcceso': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  // ------------------------------------------------------------------- login
  Future<void> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await ensureProfile(cred.user);
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    } catch (e) {
      throw AuthFailure('No se pudo iniciar sesión. Intenta de nuevo.');
    }
  }

  /// Crea el documento del usuario si no existe y registra el último acceso.
  Future<void> ensureProfile(User? user) async {
    if (user == null) return;
    try {
      final ref = _users.doc(user.uid);
      final snap = await ref.get();
      if (snap.exists) {
        await ref.set({'ultimoAcceso': FieldValue.serverTimestamp()},
            SetOptions(merge: true));
      } else {
        await ref.set({
          'nombre': user.displayName ?? '',
          'correo': (user.email ?? '').toLowerCase(),
          'telefono': '',
          'relacion': '',
          'aceptoTerminos': true,
          'creadoEn': FieldValue.serverTimestamp(),
          'ultimoAcceso': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {
      // No bloquea el acceso a la app si Firestore no responde.
    }
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  Future<void> resendVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  // ------------------------------------------------------------------ perfil
  Stream<UserProfile?> profileStream(String uid) {
    return _users.doc(uid).snapshots().map((s) {
      final data = s.data();
      if (data == null) return null;
      return UserProfile.fromMap(uid, data);
    });
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String relation,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.updateDisplayName(name.trim());
      await _users.doc(user.uid).set({
        'nombre': name.trim(),
        'telefono': phone.trim(),
        'relacion': relation,
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    } catch (_) {
      throw AuthFailure('No se pudo guardar el perfil. Revisa tu conexión.');
    }
  }

  /// Elimina la cuenta y sus datos. Requiere la contraseña actual.
  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;
    try {
      final cred =
          EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(cred);
      try {
        await _users.doc(user.uid).delete();
      } catch (_) {}
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  // ------------------------------------------------------------ sugerencias
  Future<void> sendSuggestion({
    required String type,
    required String message,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw AuthFailure('Debes iniciar sesión.');
    try {
      await _db.collection('sugerencias').add({
        'uid': user.uid,
        'nombre': user.displayName ?? '',
        'correo': user.email ?? '',
        'tipo': type,
        'mensaje': message.trim(),
        'creadoEn': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      throw AuthFailure('No se pudo enviar. Revisa tu conexión e inténtalo de nuevo.');
    }
  }

  // ---------------------------------------------------------------- errores
  AuthFailure _map(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthFailure('Ya existe una cuenta con ese correo.', e.code);
      case 'invalid-email':
        return AuthFailure('El correo no es válido.', e.code);
      case 'weak-password':
        return AuthFailure('La contraseña es muy débil (mínimo 6 caracteres).', e.code);
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure('Correo o contraseña incorrectos.', e.code);
      case 'user-disabled':
        return AuthFailure('Esta cuenta fue deshabilitada.', e.code);
      case 'too-many-requests':
        return AuthFailure('Demasiados intentos. Espera unos minutos e inténtalo de nuevo.', e.code);
      case 'network-request-failed':
        return AuthFailure('Sin conexión a internet. Revisa tu red.', e.code);
      case 'operation-not-allowed':
        return AuthFailure('El acceso con correo y contraseña no está activado en Firebase.', e.code);
      case 'requires-recent-login':
        return AuthFailure('Por seguridad, vuelve a iniciar sesión e inténtalo otra vez.', e.code);
      default:
        return AuthFailure('Ocurrió un error (${e.code}). Inténtalo de nuevo.', e.code);
    }
  }
}
