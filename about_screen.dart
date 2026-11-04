import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final a = ContentService.instance.content.about;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca del proyecto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: AppLogo(size: 200)),
          const Center(
            child: Text(AppInfo.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('“${a.slogan}”',
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.cafe)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aplicación móvil informativa, cultural y turística que reúne en un solo lugar la '
            'historia, las tradiciones, la gastronomía, las fiestas y los sitios de Pijiño del Carmen (Magdalena).',
            style: TextStyle(fontSize: 15.5, height: 1.45),
          ),
          const SectionTitle('Misión', icon: Icons.flag),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(a.mission, style: const TextStyle(fontSize: 15, height: 1.45))),
          const SectionTitle('Visión', icon: Icons.visibility),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(a.vision, style: const TextStyle(fontSize: 15, height: 1.45))),
          const SectionTitle('Valores', icon: Icons.favorite),
          for (final v in a.values)
            ListTile(
              dense: true,
              leading: const Icon(Icons.check_circle, color: AppColors.verde),
              title: Text(v[0], style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(v.length > 1 ? v[1] : ''),
            ),
          const SectionTitle('Simbología del logo', icon: Icons.palette),
          for (final s in a.symbols)
            ListTile(
              dense: true,
              leading: const Icon(Icons.brightness_1, size: 12, color: AppColors.naranja),
              title: Text(s[0], style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(s.length > 1 ? s[1] : ''),
            ),
          const SectionTitle('Organigrama', icon: Icons.account_tree),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/images/organigrama.png'),
          ),
          const SectionTitle('Proyecto productivo', icon: Icons.school),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Técnico en Programación de Aplicaciones para Dispositivos Móviles\n'
                'Centro Acuícola y Agroindustrial de Gaira · SENA\n'
                'Institución Educativa Técnica Departamental Pijiño del Carmen\n'
                'Articulación con la Educación Media · Proyecto SENATIC\n'
                'Grupo de caracterización 3321831',
                style: TextStyle(height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Versión ${AppInfo.version}',
                style: TextStyle(fontSize: 12, color: AppColors.cafe)),
          ),
          const CreditsFooter(),
        ],
      ),
    );
  }
}
