import 'package:firebase_core/firebase_core.dart';

/// ============================================================
///  CONFIGURACIÓN DE FIREBASE  (solo Android)
/// ============================================================
/// 1. Crea un proyecto en https://console.firebase.google.com
/// 2. Agrega una app Android con el paquete:  co.edu.pijino.conecta_pijino
/// 3. Copia los valores de la consola (Configuración del proyecto >
///    Tus apps > Android) y reemplaza los textos "REEMPLAZAR_..." de abajo.
///    También puedes generar este archivo con `flutterfire configure`.
/// 4. Activa Authentication (Correo/contraseña) y Cloud Firestore.
///
/// Nota: estos valores NO son secretos (van dentro de cualquier APK). La
/// seguridad real se define con las reglas de Firestore (firestore.rules).
class DefaultFirebaseOptions {
  static const String _apiKey = 'REEMPLAZAR_API_KEY';
  static const String _appId = 'REEMPLAZAR_APP_ID';
  static const String _messagingSenderId = 'REEMPLAZAR_SENDER_ID';
  static const String _projectId = 'REEMPLAZAR_PROJECT_ID';
  static const String _storageBucket = 'REEMPLAZAR_STORAGE_BUCKET';

  /// Es `true` cuando ya se reemplazaron los valores de ejemplo.
  static bool get isConfigured =>
      !_apiKey.startsWith('REEMPLAZAR') &&
      !_appId.startsWith('REEMPLAZAR') &&
      !_projectId.startsWith('REEMPLAZAR');

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );
}
