import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../core/constants.dart';
import '../models/content.dart';

/// Carga el contenido cultural desde `assets/data/contenido.json`.
/// El contenido va dentro de la app, por lo que funciona sin internet.
class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  AppContent? _content;
  AppContent get content {
    final c = _content;
    if (c == null) {
      throw StateError('El contenido aún no se ha cargado.');
    }
    return c;
  }

  bool get isLoaded => _content != null;

  Future<void> load() async {
    final raw = await rootBundle.loadString(AppInfo.contentAsset);
    _content = AppContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
