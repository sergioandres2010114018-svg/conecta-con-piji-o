import 'package:flutter/material.dart';

/// Convierte el nombre de icono del JSON en un IconData.
IconData iconFor(String name) {
  switch (name) {
    case 'historia':
      return Icons.history_edu;
    case 'cultura':
      return Icons.theater_comedy;
    case 'gastronomia':
      return Icons.restaurant;
    case 'turismo':
      return Icons.sailing;
    case 'ambiental':
      return Icons.eco;
    case 'mapa':
      return Icons.place;
    case 'fecha':
      return Icons.event;
    case 'extension':
      return Icons.crop_square;
    case 'gente':
      return Icons.groups;
    case 'altura':
      return Icons.terrain;
    case 'ruta':
      return Icons.route;
    case 'iglesia':
      return Icons.church;
    default:
      return Icons.star;
  }
}
