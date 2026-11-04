import 'package:flutter/material.dart';

/// Datos generales de la aplicación.
class AppInfo {
  static const String name = 'Conecta con Pijiño';
  static const String slogan = 'El corazón de Pijiño en cada atarraya';
  static const String version = '1.0.0';

  /// Créditos solicitados por el equipo del proyecto.
  static const String createdBy =
      'App móvil creada por: Valentina Lopez, Lorena Lopez, Maria Machado y Yair Palomino';
  static const String institution = 'IE Pijiño';
  static const String project = 'Proyecto SENATIC';

  static const String logoAsset = 'assets/images/logo.png';
  static const String heroAsset = 'assets/images/sections/hero.jpg';
  static const String contentAsset = 'assets/data/contenido.json';
}

/// Paleta tomada del logo (documento del proyecto, sección "Colores").
class AppColors {
  static const Color naranja = Color(0xFFD2691E); // sol, alegría
  static const Color cafe = Color(0xFF7A4A2B); // tierra y canoa
  static const Color cafeOscuro = Color(0xFF3B2A1F);
  static const Color arena = Color(0xFFF3E3C3); // playas del río
  static const Color arenaClara = Color(0xFFFBF5E8);
  static const Color negro = Color(0xFF1E1A17);
  static const Color verde = Color(0xFF6B7B3A);
}
