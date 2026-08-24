import 'package:flutter/material.dart';

import '../models/pixabay_media.dart';
import '../utils/format_date.dart';
import '../components/quality_badge.dart';

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
                    ? const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 48,
                      )
                    : Image.network(
                        item.largeImageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white54,
                            ),
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

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                24,
                16,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _LabelValue(
                          label: 'RESOLUTION',
                          value: '${item.width} × ${item.height}',
                        ),
                      ),
                      if (item.publishedAt != null)
                        Expanded(
                          child: _LabelValue(
                            label: 'CREATED',
                            value: formatDate(item.publishedAt!),
                          ),
                        ),
                      QualityBadge(item: item),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}