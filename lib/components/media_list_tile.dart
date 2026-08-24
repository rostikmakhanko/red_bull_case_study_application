import 'package:flutter/material.dart';
import '../models/pixabay_media.dart';
import '../utils/format_date.dart';
import 'quality_badge.dart';

class MediaListTile extends StatelessWidget {
  final PixabayMedia item;
  final VoidCallback onTap;

  const MediaListTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVideo = item.kind == MediaKind.video;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Thumbnail(url: item.displayThumbnail),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _dimensionsLine(item),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (item.publishedAt != null)
                        Row(
                          children: [
                            Text(
                              'Created ${formatDate(item.publishedAt!)}',
                              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      QualityBadge(item: item),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isVideo)
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.play_arrow, size: 18, color: Colors.white),
              )
            else
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  String _dimensionsLine(PixabayMedia item) {
    final resolution = '${item.width} × ${item.height}';
    if (item.kind == MediaKind.video) {
      return '$resolution · ${_formatDuration(item.duration)}';
    }
    return '$resolution · —';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '--:--';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _Thumbnail extends StatelessWidget {
  final String? url;
  const _Thumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 56,
        height: 56,
        child: (url == null || url!.isEmpty)
            ? Container(color: Colors.grey.shade200)
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: Colors.grey.shade200);
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}