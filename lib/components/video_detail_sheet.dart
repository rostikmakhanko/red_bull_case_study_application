import 'package:flutter/material.dart';
import '../models/pixabay_media.dart';
import '../utils/format_date.dart';
import 'label_value.dart';
import 'quality_badge.dart';

class VideoDetailSheet extends StatelessWidget {
  final PixabayMedia item;

  const VideoDetailSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, PixabayMedia item) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => VideoDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Text(
            'pixabay · videos · id ${item.id}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          _VideoPreview(item: item),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('00:00', style: TextStyle(fontSize: 11)),
              const Expanded(
                child: Slider(value: 0, onChanged: null), // TODO: wire up real playback
              ),
              Text(_formatDuration(item.duration), style: const TextStyle(fontSize: 11)),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelValue(label: 'RESOLUTION', value: '${item.width} × ${item.height}', darkBackground: false),
              if (item.publishedAt != null)
                LabelValue(label: 'CREATED', value: formatDate(item.publishedAt!), darkBackground: false),
              QualityBadge(item: item),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '--:--';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _VideoPreview extends StatelessWidget {
  final PixabayMedia item;
  const _VideoPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
              Image.network(
                item.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade800),
              )
            else
              Container(color: Colors.grey.shade800),
            const Center(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow, color: Colors.indigo, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}