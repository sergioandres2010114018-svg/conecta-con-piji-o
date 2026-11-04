/// Modelos del contenido cultural de la app (cargado desde assets/data/contenido.json).

String _s(Map<String, dynamic> m, String k, [String d = '']) =>
    (m[k] ?? d).toString();

List<String> _strings(dynamic v) =>
    (v as List? ?? const []).map((e) => e.toString()).toList();

List<Map<String, dynamic>> _maps(dynamic v) => (v as List? ?? const [])
    .map((e) => Map<String, dynamic>.from(e as Map))
    .toList();

class ContentItem {
  final String id;
  final String title;
  final String summary;
  final List<String> body;
  final String image;
  final List<String> tags;
  final String? mapQuery;
  final bool needsValidation;

  ContentItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.image,
    required this.tags,
    required this.mapQuery,
    required this.needsValidation,
  });

  factory ContentItem.fromJson(Map<String, dynamic> j) => ContentItem(
        id: _s(j, 'id'),
        title: _s(j, 'titulo'),
        summary: _s(j, 'resumen'),
        body: _strings(j['cuerpo']),
        image: _s(j, 'imagen'),
        tags: _strings(j['etiquetas']),
        mapQuery: j['mapa']?.toString(),
        needsValidation: j['validar'] == true,
      );
}

class ContentSection {
  final String id;
  final String title;
  final String icon;
  final String image;
  final String description;
  final List<ContentItem> items;

  ContentSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.image,
    required this.description,
    required this.items,
  });

  factory ContentSection.fromJson(Map<String, dynamic> j) => ContentSection(
        id: _s(j, 'id'),
        title: _s(j, 'titulo'),
        icon: _s(j, 'icono'),
        image: _s(j, 'imagen'),
        description: _s(j, 'descripcion'),
        items: _maps(j['items']).map(ContentItem.fromJson).toList(),
      );
}

class MunicipioFact {
  final String icon;
  final String label;
  final String value;
  MunicipioFact(this.icon, this.label, this.value);

  factory MunicipioFact.fromJson(Map<String, dynamic> j) =>
      MunicipioFact(_s(j, 'icono'), _s(j, 'etiqueta'), _s(j, 'valor'));
}

class MunicipioInfo {
  final String description;
  final String image;
  final List<MunicipioFact> facts;
  final String limits;
  final List<String> corregimientos;
  final String note;

  MunicipioInfo({
    required this.description,
    required this.image,
    required this.facts,
    required this.limits,
    required this.corregimientos,
    required this.note,
  });

  factory MunicipioInfo.fromJson(Map<String, dynamic> j) => MunicipioInfo(
        description: _s(j, 'descripcion'),
        image: _s(j, 'imagen'),
        facts: _maps(j['datos']).map(MunicipioFact.fromJson).toList(),
        limits: _s(j, 'limites'),
        corregimientos: _strings(j['corregimientos']),
        note: _s(j, 'nota'),
      );
}

class EventItem {
  final String id;
  final String title;
  final int? day;
  final int? month;
  final String dateText;
  final String place;
  final String description;
  final String image;
  final bool variable;

  EventItem({
    required this.id,
    required this.title,
    required this.day,
    required this.month,
    required this.dateText,
    required this.place,
    required this.description,
    required this.image,
    required this.variable,
  });

  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
        id: _s(j, 'id'),
        title: _s(j, 'titulo'),
        day: j['dia'] is int ? j['dia'] as int : null,
        month: j['mes'] is int ? j['mes'] as int : null,
        dateText: _s(j, 'fechaTexto'),
        place: _s(j, 'lugar'),
        description: _s(j, 'descripcion'),
        image: _s(j, 'imagen'),
        variable: j['variable'] == true,
      );

  /// Próxima fecha de un evento de fecha fija. Para eventos variables devuelve null.
  DateTime? nextDate(DateTime now) {
    if (variable || day == null || month == null) return null;
    final today = DateTime(now.year, now.month, now.day);
    var d = DateTime(now.year, month!, day!);
    if (d.isBefore(today)) d = DateTime(now.year + 1, month!, day!);
    return d;
  }
}

class GalleryPhoto {
  final String image;
  final String title;
  final String description;
  GalleryPhoto(this.image, this.title, this.description);

  factory GalleryPhoto.fromJson(Map<String, dynamic> j) =>
      GalleryPhoto(_s(j, 'imagen'), _s(j, 'titulo'), _s(j, 'descripcion'));
}

class GalleryVideo {
  final String title;
  final String description;
  final String? asset;
  final String? url;
  final String cover;
  GalleryVideo({
    required this.title,
    required this.description,
    required this.asset,
    required this.url,
    required this.cover,
  });

  factory GalleryVideo.fromJson(Map<String, dynamic> j) => GalleryVideo(
        title: _s(j, 'titulo'),
        description: _s(j, 'descripcion'),
        asset: j['asset']?.toString(),
        url: j['url']?.toString(),
        cover: _s(j, 'portada'),
      );
}

class LinkItem {
  final String title;
  final String url;
  final String description;
  LinkItem(this.title, this.url, this.description);

  factory LinkItem.fromJson(Map<String, dynamic> j) =>
      LinkItem(_s(j, 'titulo'), _s(j, 'url'), _s(j, 'descripcion'));
}

class AboutInfo {
  final String slogan;
  final String mission;
  final String vision;
  final List<List<String>> values;
  final List<List<String>> symbols;

  AboutInfo({
    required this.slogan,
    required this.mission,
    required this.vision,
    required this.values,
    required this.symbols,
  });

  static List<List<String>> _pairs(dynamic v) => (v as List? ?? const [])
      .map((e) => (e as List).map((x) => x.toString()).toList())
      .toList();

  factory AboutInfo.fromJson(Map<String, dynamic> j) => AboutInfo(
        slogan: _s(j, 'slogan'),
        mission: _s(j, 'mision'),
        vision: _s(j, 'vision'),
        values: _pairs(j['valores']),
        symbols: _pairs(j['simbologia']),
      );
}

class AppContent {
  final MunicipioInfo municipio;
  final List<ContentSection> sections;
  final List<String> tips;
  final List<EventItem> events;
  final List<GalleryPhoto> photos;
  final List<GalleryVideo> videos;
  final List<LinkItem> links;
  final AboutInfo about;

  AppContent({
    required this.municipio,
    required this.sections,
    required this.tips,
    required this.events,
    required this.photos,
    required this.videos,
    required this.links,
    required this.about,
  });

  factory AppContent.fromJson(Map<String, dynamic> j) {
    final gal = Map<String, dynamic>.from(j['galeria'] as Map);
    return AppContent(
      municipio:
          MunicipioInfo.fromJson(Map<String, dynamic>.from(j['municipio'] as Map)),
      sections: _maps(j['secciones']).map(ContentSection.fromJson).toList(),
      tips: _strings(j['consejos']),
      events: _maps(j['eventos']).map(EventItem.fromJson).toList(),
      photos: _maps(gal['fotos']).map(GalleryPhoto.fromJson).toList(),
      videos: _maps(gal['videos']).map(GalleryVideo.fromJson).toList(),
      links: _maps(j['enlaces']).map(LinkItem.fromJson).toList(),
      about: AboutInfo.fromJson(Map<String, dynamic>.from(j['acerca'] as Map)),
    );
  }

  ContentSection? section(String id) {
    for (final s in sections) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Eventos de fecha fija ordenados por cercanía, seguidos de los variables.
  List<EventItem> eventsSorted(DateTime now) {
    final fixed = events.where((e) => e.nextDate(now) != null).toList()
      ..sort((a, b) => a.nextDate(now)!.compareTo(b.nextDate(now)!));
    final variable = events.where((e) => e.nextDate(now) == null).toList()
      ..sort((a, b) => (a.month ?? 13).compareTo(b.month ?? 13));
    return [...fixed, ...variable];
  }
}
