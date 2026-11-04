import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../services/auth_service.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';
import 'auth/login_screen.dart';
import 'home_shell.dart';

/// Pantalla de inicio: muestra el logo, carga el contenido y decide
/// si se muestra el login o la app.
class SplashScreen extends StatefulWidget {
  final String? firebaseError;
  const SplashScreen({super.key, this.firebaseError});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    setState(() => _error = null);
    try {
      await Future.wait([
        ContentService.instance.load(),
        Future.delayed(const Duration(milliseconds: 2200)),
      ]);
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo cargar el contenido de la aplicación.\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      if (widget.firebaseError != null) {
        return SetupRequiredScreen(error: widget.firebaseError!);
      }
      return const AuthGate();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutBack,
                      builder: (context, v, child) => Opacity(
                        opacity: v.clamp(0.0, 1.0),
                        child: Transform.scale(scale: v, child: child),
                      ),
                      child: const AppLogo(size: 230),
                    ),
                    const SizedBox(height: 12),
                    const Text(AppInfo.name,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.cafeOscuro)),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(AppInfo.slogan,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: AppColors.cafe)),
                    ),
                    const SizedBox(height: 28),
                    if (_error == null)
                      const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                              strokeWidth: 3, color: AppColors.naranja))
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(_error!, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(onPressed: _boot, child: const Text('Reintentar')),
                    ],
                  ],
                ),
              ),
            ),
            const CreditsFooter(),
          ],
        ),
      ),
    );
  }
}

/// Decide entre login y app según la sesión de Firebase.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authChanges,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.naranja)),
          );
        }
        if (snap.data != null) return const HomeShell();
        return const LoginScreen();
      },
    );
  }
}

/// Se muestra solo al desarrollar si falta configurar Firebase.
class SetupRequiredScreen extends StatelessWidget {
  final String error;
  const SetupRequiredScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final notConfigured = error == 'not-configured';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 130),
              const SizedBox(height: 16),
              Text(
                notConfigured ? 'Falta configurar Firebase' : 'No se pudo iniciar Firebase',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                notConfigured
                    ? 'Abre lib/firebase_options.dart y reemplaza los valores "REEMPLAZAR_..." '
                        'con los de tu proyecto de Firebase. Guía: docs/GUIA_FIREBASE.md'
                    : error,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
