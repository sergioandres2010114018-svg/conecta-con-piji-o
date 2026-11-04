import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.naranja,
    primary: AppColors.naranja,
    secondary: AppColors.cafe,
    tertiary: AppColors.verde,
    surface: AppColors.arenaClara,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.arenaClara,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
