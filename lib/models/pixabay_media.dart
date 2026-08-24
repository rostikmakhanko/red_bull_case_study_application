enum MediaKind { image, video }

class PixabayMedia {
  final int id;
  final String tags;
  final String pageUrl;
  final int width;
  final int height;
  final MediaKind kind;
  final String name; // derived based on tags returned from Pixabay API
  final DateTime? publishedAt; // if possible - derived from previewURL for images and from thumbnail url for videos, otherwise - from userImageURL (???)

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
    required this.publishedAt,
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

  static DateTime? _extractDateFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    final match = RegExp(r'/(\d{4})/(\d{2})/(\d{2})/').firstMatch(url);
    if (match == null) return null;

    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);

    if (year == null || month == null || day == null) return null;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    if (year < 1968 || year > DateTime.now().year) return null;

    return DateTime(year, month, day);
  }

  factory PixabayMedia.fromImageJson(Map<String, dynamic> json) {
    final tags = json['tags'] ?? '';
    final previewUrl = json['previewURL'] as String?;
    final userImageUrl = json['userImageURL'] as String?;
    return PixabayMedia._(
      id: json['id'],
      tags: tags ?? '',
      pageUrl: json['pageURL'],
      width: json['imageWidth'],
      height: json['imageHeight'],
      kind: MediaKind.image,
      name: _deriveName(tags, json['id'], MediaKind.image),
      publishedAt: _extractDateFromUrl(previewUrl) ?? _extractDateFromUrl(userImageUrl),
      previewImageUrl: json['previewURL'],
      largeImageUrl: json['largeImageURL'],
    );
  }

  factory PixabayMedia.fromVideoJson(Map<String, dynamic> json) {
    final videos = json['videos'] as Map<String, dynamic>;
    final medium = videos['medium'] as Map<String, dynamic>;
    final tags = json['tags'] ?? '';
    final thumbnailUrl = json['thumbnail'] as String?;
    final userImageUrl = json['userImageURL'] as String?;
    return PixabayMedia._(
      id: json['id'],
      tags: tags ?? '',
      pageUrl: json['pageURL'],
      width: medium['width'],
      height: medium['height'],
      kind: MediaKind.video,
      name: _deriveName(tags, json['id'], MediaKind.video),
      publishedAt: _extractDateFromUrl(thumbnailUrl) ?? _extractDateFromUrl(userImageUrl),
      thumbnailUrl: thumbnailUrl,
      videoUrl: medium['url'],
      duration: json['duration'],
    );
  }

  String? get displayThumbnail =>
      kind == MediaKind.image ? previewImageUrl : thumbnailUrl;
}