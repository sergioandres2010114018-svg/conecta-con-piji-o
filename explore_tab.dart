import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/icons.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'municipio_screen.dart';
import 'section_screen.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final content = ContentService.instance.content;
    void push(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar'), backgroundColor: AppColors.arenaClara),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        children: [
          _ExploreCard(
            image: content.municipio.image,
            title: 'El municipio',
            subtitle: 'Datos generales, límites y corregimientos',
            icon: Icons.location_city,
            onTap: () => push(const MunicipioScreen()),
          ),
          for (final s in content.sections)
            _ExploreCard(
              image: s.image,
              title: s.title,
              subtitle: s.description,
              icon: iconFor(s.icon),
              onTap: () => push(SectionScreen(section: s)),
            ),
          _ExploreCard(
            image: 'assets/images/sections/hero.jpg',
            title: 'Contacto y enlaces de interés',
            subtitle: 'Envía sugerencias, aportes y consulta sitios oficiales',
            icon: Icons.mail,
            onTap: () => push(const ContactScreen()),
          ),
          _ExploreCard(
            image: 'assets/images/sections/pesca.jpg',
            title: 'Acerca del proyecto',
            subtitle: 'Misión, visión, valores, logo y equipo',
            icon: Icons.info,
            onTap: () => push(const AboutScreen()),
          ),
          const CreditsFooter(),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ExploreCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: ImageBanner(
            image: image,
            title: title,
            subtitle: subtitle,
            height: 150,
            child: Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: AppColors.naranja),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
