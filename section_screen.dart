import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/content.dart';
import '../widgets/common.dart';

/// Lista de elementos de una sección (historia, cultura, gastronomía, etc.).
class SectionScreen extends StatelessWidget {
  final ContentSection section;
  const SectionScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: AppColors.cafeOscuro,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(section.title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(section.image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xAA000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(section.description,
                  style: const TextStyle(fontSize: 15.5, color: AppColors.cafeOscuro, height: 1.4)),
            ),
          ),
          SliverList.builder(
            itemCount: section.items.length,
            itemBuilder: (context, i) {
              final item = section.items[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: item))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset(item.image, fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800, fontSize: 15.5)),
                                const SizedBox(height: 4),
                                Text(item.summary,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: CreditsFooter()),
        ],
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final ContentItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: AppColors.cafeOscuro,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(item.image, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.cafeOscuro)),
                  const SizedBox(height: 8),
                  if (item.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final t in item.tags)
                          Chip(label: Text(t), backgroundColor: AppColors.arena),
                      ],
                    ),
                  const SizedBox(height: 8),
                  for (final p in item.body)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(p, style: const TextStyle(fontSize: 16, height: 1.5)),
                    ),
                  if (item.mapQuery != null)
                    FilledButton.icon(
                      onPressed: () => openMap(context, item.mapQuery!),
                      icon: const Icon(Icons.map),
                      label: const Text('Ver en Google Maps'),
                    ),
                  if (item.needsValidation) const ValidationNotice(),
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
