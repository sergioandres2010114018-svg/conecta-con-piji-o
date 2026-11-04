import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../services/auth_service.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const _types = [
    'Sugerencia',
    'Corrección de contenido',
    'Aporte cultural (historia, fotos, relatos)',
    'Emprendimiento local',
  ];
  final _msg = TextEditingController();
  String _type = _types.first;
  bool _sending = false;

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_msg.text.trim().length < 10) {
      showMessage(context, 'Escribe un mensaje de al menos 10 caracteres.', error: true);
      return;
    }
    setState(() => _sending = true);
    try {
      await AuthService.instance.sendSuggestion(type: _type, message: _msg.text);
      if (!mounted) return;
      _msg.clear();
      showMessage(context, '¡Gracias! Tu mensaje fue enviado al equipo.');
    } on AuthFailure catch (e) {
      if (mounted) showMessage(context, e.message, error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = ContentService.instance.content.links;
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto y participación')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Esta app se construye con la comunidad. Cuéntanos qué podemos mejorar, '
            'corrige un dato o comparte una historia, una foto o tu emprendimiento.',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: [
              for (final t in _types)
                ChoiceChip(
                  label: Text(t, style: const TextStyle(fontSize: 12.5)),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _msg,
            minLines: 4,
            maxLines: 8,
            maxLength: 1000,
            decoration: const InputDecoration(
              hintText: 'Escribe tu mensaje aquí...',
              border: OutlineInputBorder(),
            ),
          ),
          FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: const Icon(Icons.send),
            label: Text(_sending ? 'Enviando...' : 'Enviar al equipo'),
          ),
          const SectionTitle('Enlaces de interés', icon: Icons.link),
          for (final l in links)
            Card(
              child: ListTile(
                leading: const Icon(Icons.open_in_new, color: AppColors.naranja),
                title: Text(l.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(l.description),
                onTap: () => openUrl(context, l.url),
              ),
            ),
          const CreditsFooter(),
        ],
      ),
    );
  }
}
