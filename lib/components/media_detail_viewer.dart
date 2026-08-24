import 'package:flutter/material.dart';
import '../models/pixabay_media.dart';

class MediaDetailViewer extends StatelessWidget {
  final PixabayMedia item;

  const MediaDetailViewer({super.key, required this.item});

  static void show(BuildContext context, PixabayMedia item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) =>
            MediaDetailViewer(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: item.largeImageUrl == null || item.largeImageUrl!.isEmpty
                    ? const Icon(Icons.broken_image, color: Colors.grey, size: 48)
                    : Image.network(
                        item.largeImageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white54),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 48,
                        ),
                      ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}