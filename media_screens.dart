import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/constants.dart';
import '../models/content.dart';

/// Tarjeta con la portada de un video; al tocarla abre el reproductor.
class VideoCard extends StatelessWidget {
  final GalleryVideo video;
  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(video.cover, fit: BoxFit.cover),
                  Container(color: Colors.black26),
                  const Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.play_arrow, size: 40, color: AppColors.naranja),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(video.description, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final GalleryVideo video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final v = widget.video;
    if (v.asset != null && v.asset!.isNotEmpty) {
      _controller = VideoPlayerController.asset(v.asset!);
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(v.url ?? ''));
    }
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _controller.play();
    }).catchError((Object e) {
      if (mounted) setState(() => _error = 'No se pudo reproducir el video.');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final playing = _ready && _controller.value.isPlaying;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.video.title, style: const TextStyle(fontSize: 16)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _error != null
                    ? Text(_error!, style: const TextStyle(color: Colors.white))
                    : !_ready
                        ? const CircularProgressIndicator(color: AppColors.naranja)
                        : GestureDetector(
                            onTap: () => playing ? _controller.pause() : _controller.play(),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
              ),
            ),
            if (_ready)
              Container(
                color: const Color(0xFF111111),
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  children: [
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppColors.naranja,
                        bufferedColor: Colors.white30,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          color: Colors.white,
                          iconSize: 34,
                          icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                          onPressed: () => playing ? _controller.pause() : _controller.play(),
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.replay),
                          onPressed: () async {
                            await _controller.seekTo(Duration.zero);
                            await _controller.play();
                          },
                        ),
                        const Spacer(),
                        Text(
                          '${_fmt(_controller.value.position)} / ${_fmt(_controller.value.duration)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.video.description,
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Visor de fotos a pantalla completa con zoom y deslizamiento.
class PhotoViewerScreen extends StatefulWidget {
  final List<GalleryPhoto> photos;
  final int initial;
  const PhotoViewerScreen({super.key, required this.photos, required this.initial});

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late final PageController _page = PageController(initialPage: widget.initial);
  late int _current = widget.initial;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.photos[_current];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_current + 1} / ${widget.photos.length}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _page,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: widget.photos[i].image,
                    child: Image.asset(widget.photos[i].image, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF111111),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(p.description, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
