import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../services/content_service.dart';
import '../widgets/common.dart';
import 'media_screens.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ContentService.instance.content;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Galería multimedia'),
          backgroundColor: AppColors.arenaClara,
          bottom: const TabBar(
            labelColor: AppColors.naranja,
            indicatorColor: AppColors.naranja,
            tabs: [
              Tab(icon: Icon(Icons.photo), text: 'Fotos'),
              Tab(icon: Icon(Icons.videocam), text: 'Videos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ----------------------------------------------------- fotos
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: c.photos.length,
                  itemBuilder: (context, i) {
                    final p = c.photos[i];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PhotoViewerScreen(photos: c.photos, initial: i))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(tag: p.image, child: Image.asset(p.image, fit: BoxFit.cover)),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x00000000), Color(0xB3000000)],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              child: Text(p.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const CreditsFooter(),
              ],
            ),
            // ---------------------------------------------------- videos
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final v in c.videos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: VideoCard(video: v),
                  ),
                const CreditsFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
