import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  String? firebaseError;
  if (!DefaultFirebaseOptions.isConfigured) {
    firebaseError = 'not-configured';
  } else {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    } catch (e) {
      firebaseError = e.toString();
    }
  }
  runApp(ConectaApp(firebaseError: firebaseError));
}

class ConectaApp extends StatelessWidget {
  final String? firebaseError;
  const ConectaApp({super.key, this.firebaseError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: SplashScreen(firebaseError: firebaseError),
    );
  }
}
