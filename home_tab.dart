import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/icons.dart';
import '../models/content.dart';
import '../services/auth_service.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';
import 'about_screen.dart';
import 'media_screens.dart';
import 'municipio_screen.dart';
import 'section_screen.dart';

class HomeTab extends StatelessWidget {
  final void Function(int) onGoTo;
  const HomeTab({super.key, required this.onGoTo});

  @override
  Widget build(BuildContext context) {
    final content = ContentService.instance.content;
    final now = DateTime.now();
    final events = content.eventsSorted(now);
    final nextEvent = events.isEmpty ? null : events.first;
    final tip = content.tips.isEmpty
        ? null
        : content.tips[now.difference(DateTime(now.year)).inDays % content.tips.length];
    final User? user = AuthService.instance.currentUser;
    final first = (user?.displayName ?? '').trim().split(' ').first;

    final shortcuts = <_Shortcut>[
      for (final id in ['historia', 'cultura', 'gastronomia', 'turismo', 'ambiental'])
        if (content.section(id) != null)
          _Shortcut(content.section(id)!.title, iconFor(id), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SectionScreen(section: content.section(id)!)));
          }),
      _Shortcut('Municipio', Icons.location_city, () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const MunicipioScreen()));
      }),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ------------------------------------------------------ cabecera
        SizedBox(
          height: 300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppInfo.heroAsset, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x66000000), Color(0x00000000), Color(0xCC1E1A17)],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const AppLogo(size: 54, circle: true),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(AppInfo.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                          ),
                          IconButton(
                            tooltip: 'Acerca de',
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AboutScreen())),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(first.isEmpty ? '¡Hola!' : '¡Hola, $first!',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('Descubre la historia, la cultura y los sabores de Pijiño del Carmen.',
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('“${AppInfo.slogan}”',
                          style: TextStyle(
                              color: Color(0xFFF3C27A),
                              fontSize: 13,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ------------------------------------------------ accesos rápidos
        const SectionTitle('Explora Pijiño', icon: Icons.explore),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.05,
            children: [for (final s in shortcuts) _ShortcutTile(s)],
          ),
        ),

        // ---------------------------------------------- próximo evento
        if (nextEvent != null) ...[
          const SectionTitle('Próximo evento', icon: Icons.celebration),
          _EventCard(event: nextEvent, onTap: () => onGoTo(3)),
        ],

        // ----------------------------------------------------- video
        if (content.videos.isNotEmpty) ...[
          const SectionTitle('Video destacado', icon: Icons.play_circle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VideoCard(video: content.videos.first),
          ),
        ],

        // ------------------------------------------------------ consejo
        if (tip != null) ...[
          const SectionTitle('Consejo para cuidar el entorno', icon: Icons.eco),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.verde.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.verde.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.verde, size: 32),
                  const SizedBox(width: 12),
                  Expanded(child: Text(tip, style: const TextStyle(fontSize: 15))),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        const CreditsFooter(),
      ],
    );
  }
}

class _Shortcut {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  _Shortcut(this.label, this.icon, this.onTap);
}

class _ShortcutTile extends StatelessWidget {
  final _Shortcut s;
  const _ShortcutTile(this.s);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: s.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.arena,
                child: Icon(s.icon, color: AppColors.naranja, size: 26),
              ),
              const SizedBox(height: 8),
              Text(s.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final next = event.nextDate(DateTime.now());
    String badge = event.dateText;
    if (next != null) {
      final days = next.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays;
      badge = days == 0 ? '¡Hoy!' : (days == 1 ? 'Mañana' : 'En $days días');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              ImageBanner(image: event.image, title: event.title, subtitle: event.dateText, height: 150),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Chip(label: Text(badge), backgroundColor: AppColors.arena),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(event.place,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.cafe)),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
