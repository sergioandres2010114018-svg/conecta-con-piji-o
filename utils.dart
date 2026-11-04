import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(const SnackBar(content: Text('No se pudo abrir el enlace.')));
    }
  } catch (_) {
    messenger.showSnackBar(const SnackBar(content: Text('No se pudo abrir el enlace.')));
  }
}

Future<void> openMap(BuildContext context, String query) {
  final url =
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
  return openUrl(context, url);
}

const List<String> _meses = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
];

String mesNombre(int m) => _meses[(m - 1).clamp(0, 11)];

String fechaLarga(DateTime d) => '${d.day} de ${mesNombre(d.month)} de ${d.year}';

void showMessage(BuildContext context, String text, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
}
