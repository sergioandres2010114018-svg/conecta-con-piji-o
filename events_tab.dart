import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/content.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final events = ContentService.instance.content.eventsSorted(now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiestas y eventos'),
        backgroundColor: AppColors.arenaClara,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        children: [
          const Text(
            'Calendario de celebraciones tradicionales. Las fechas pueden cambiar cada año: '
            'confirma la programación con la Alcaldía.',
            style: TextStyle(color: AppColors.cafe, fontSize: 13.5),
          ),
          const SizedBox(height: 12),
          for (final e in events) _EventTile(event: e, now: now),
          const CreditsFooter(),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final EventItem event;
  final DateTime now;
  const _EventTile({required this.event, required this.now});

  @override
  Widget build(BuildContext context) {
    final next = event.nextDate(now);
    String badge;
    if (next == null) {
      badge = 'Fecha variable';
    } else {
      final today = DateTime(now.year, now.month, now.day);
      final days = next.difference(today).inDays;
      badge = days == 0 ? '¡Hoy!' : (days == 1 ? 'Mañana' : 'En $days días');
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => _EventSheet(event: event, next: next),
          ),
          child: Row(
            children: [
              Container(
                width: 74,
                height: 100,
                color: AppColors.cafeOscuro,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(event.day?.toString() ?? '—',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    Text(
                      event.month == null ? '' : mesNombre(event.month!).substring(0, 3).toUpperCase(),
                      style: const TextStyle(color: Color(0xFFF3C27A), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                      const SizedBox(height: 2),
                      Text(event.dateText,
                          style: const TextStyle(fontSize: 12.5, color: AppColors.cafe)),
                      const SizedBox(height: 2),
                      Text(event.place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(badge, style: const TextStyle(fontSize: 11.5)),
                  backgroundColor: AppColors.arena,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventSheet extends StatelessWidget {
  final EventItem event;
  final DateTime? next;
  const _EventSheet({required this.event, required this.next});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageBanner(image: event.image, height: 170),
          ),
          const SizedBox(height: 12),
          Text(event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.event, size: 18, color: AppColors.naranja),
            const SizedBox(width: 6),
            Expanded(child: Text(next != null ? '${event.dateText} · próxima: ${fechaLarga(next!)}' : event.dateText)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.place, size: 18, color: AppColors.naranja),
            const SizedBox(width: 6),
            Expanded(child: Text(event.place)),
          ]),
          const SizedBox(height: 12),
          Text(event.description, style: const TextStyle(fontSize: 15.5, height: 1.45)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => openMap(context, '${event.place} Pijiño del Carmen Magdalena'),
            icon: const Icon(Icons.map),
            label: const Text('Ver lugar en el mapa'),
          ),
        ],
      ),
    );
  }
}
