enum MediaKind { image, video }

class PixabayMedia {
  final int id;
  final String tags;
  final String pageUrl;
  final int width;
  final int height;
  final MediaKind kind;
  final String name; // derived based on tags returned from Pixabay API

  // Image-specific
  final String? previewImageUrl;
  final String? largeImageUrl;

  // Video-specific
  final String? thumbnailUrl;
  final String? videoUrl;
  final int? duration;

  PixabayMedia._({
    required this.id,
    required this.tags,
    required this.pageUrl,
    required this.width,
    required this.height,
    required this.kind,
    required this.name,
    this.previewImageUrl,
    this.largeImageUrl,
    this.thumbnailUrl,
    this.videoUrl,
    this.duration,
  });

  static String _deriveName(String tags, int id, MediaKind kind) {
    final firstTags = tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(2)
        .join('_')
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_');

    final base = firstTags.isEmpty ? 'media' : firstTags;
    final ext = kind == MediaKind.video ? 'mp4' : 'jpg';
    return '${base}_$id.$ext';
  }

  factory PixabayMedia.fromImageJson(Map<String, dynamic> json) {
    final tags = json['tags'] ?? '';
    return PixabayMedia._(
      id: json['id'],
      tags: tags ?? '',
      pageUrl: json['pageURL'],
      width: json['imageWidth'],
      height: json['imageHeight'],
      kind: MediaKind.image,
      name: _deriveName(tags, json['id'], MediaKind.image),
      previewImageUrl: json['previewURL'],
      largeImageUrl: json['largeImageURL'],
    );
  }

  factory PixabayMedia.fromVideoJson(Map<String, dynamic> json) {
    final videos = json['videos'] as Map<String, dynamic>;
    final medium = videos['medium'] as Map<String, dynamic>;
    final tags = json['tags'] ?? '';
    return PixabayMedia._(
      id: json['id'],
      tags: tags ?? '',
      pageUrl: json['pageURL'],
      width: medium['width'],
      height: medium['height'],
      kind: MediaKind.video,
      name: _deriveName(tags, json['id'], MediaKind.video),
      thumbnailUrl: medium['thumbnail'],
      videoUrl: medium['url'],
      duration: json['duration'],
    );
  }

  String? get displayThumbnail =>
      kind == MediaKind.image ? previewImageUrl : thumbnailUrl;
}