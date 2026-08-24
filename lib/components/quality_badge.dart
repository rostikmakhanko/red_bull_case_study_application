import 'package:flutter/material.dart';

import '../models/pixabay_media.dart';

class QualityBadge extends StatelessWidget {
  final PixabayMedia item;

  const QualityBadge({super.key, required this.item});

  String get _label {
    final h = item.height;
    if (h >= 2160) return '4K';
    if (h >= 1440) return '2K';
    if (h >= 1080) return 'FHD';
    return 'HD';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.kind == MediaKind.video
                ? Icons.videocam_outlined
                : Icons.image_outlined,
            size: 11,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            _label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
