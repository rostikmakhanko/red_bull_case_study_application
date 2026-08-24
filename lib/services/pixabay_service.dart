import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/pixabay_media.dart';

class PixabayException implements Exception {
  final String message;
  PixabayException(this.message);
  @override
  String toString() => 'PixabayException: $message';
}

class PixabayService {
  static const _baseUrl = 'https://pixabay.com/api';
  static const _videoUrl = 'https://pixabay.com/api/videos';

  final http.Client _client;
  PixabayService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<PixabayMedia>> searchImages(
    String query, {
    int page = 1,
    int perPage = 25,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'key': ApiKeys.pixabay,
      'q': query,
      'page': '$page',
      'per_page': '$perPage',
      'safesearch': 'true',
    });

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw PixabayException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final hits = (data['hits'] as List).cast<Map<String, dynamic>>();
    return hits.map(PixabayMedia.fromImageJson).toList();
  }

  Future<List<PixabayMedia>> searchVideos(
    String query, {
    int page = 1,
    int perPage = 25,
  }) async {
    final uri = Uri.parse(_videoUrl).replace(queryParameters: {
      'key': ApiKeys.pixabay,
      'q': query,
      'page': '$page',
      'per_page': '$perPage',
      'safesearch': 'true',
    });

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw PixabayException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final hits = (data['hits'] as List).cast<Map<String, dynamic>>();
    return hits.map(PixabayMedia.fromVideoJson).toList();
  }

  /// Fetches both images and videos for a folder name, merged into one list.
  Future<List<PixabayMedia>> searchFolder(
    String folderName, {
    int page = 1,
    int perPage = 25,
  }) async {
    final results = await Future.wait([
      searchImages(folderName, page: page, perPage: perPage),
      searchVideos(folderName, page: page, perPage: perPage),
    ]);
    final merged = [...results[0], ...results[1]];
    merged.sort((a, b) => a.name.compareTo(b.name));
    return merged;
  }

  void dispose() => _client.close();
}