import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/icons.dart';
import '../core/utils.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';

class MunicipioScreen extends StatelessWidget {
  const MunicipioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = ContentService.instance.content.municipio;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: AppColors.cafeOscuro,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Pijiño del Carmen',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              background: Image.asset(m.image, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 16),
                  for (final f in m.facts)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.arena,
                          child: Icon(iconFor(f.icon), color: AppColors.naranja),
                        ),
                        title: Text(f.label,
                            style: const TextStyle(fontSize: 12.5, color: AppColors.cafe)),
                        subtitle: Text(f.value,
                            style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.negro)),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text('Límites',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(m.limits, style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 16),
                  const Text('Corregimientos y centros poblados',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final c in m.corregimientos)
                        Chip(
                          avatar: const Icon(Icons.place, size: 16, color: AppColors.naranja),
                          label: Text(c),
                          backgroundColor: AppColors.arena,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        openMap(context, 'Pijiño del Carmen, Magdalena, Colombia'),
                    icon: const Icon(Icons.map),
                    label: const Text('Ver Pijiño del Carmen en el mapa'),
                  ),
                  const SizedBox(height: 12),
                  Text(m.note,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.cafe)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: CreditsFooter()),
        ],
      ),
    );
  }
}
