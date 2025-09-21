import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeMusicService {
  static const String _baseUrl = 'youtube-music-api3.p.rapidapi.com';
  static const String _apiKey =
      '411aa8bf9cmsh79fcb792026c5edp175bdbjsn4535995e6b4e';

  Future<Map<String, dynamic>> searchSuggestions(String query) async {
    try {
      final uri = Uri.https(_baseUrl, '/search_suggestions', {'q': query});
      final response = await http.get(
        uri,
        headers: {
          'x-rapidapi-key': _apiKey,
          'x-rapidapi-host': _baseUrl,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load search suggestions');
      }
    } catch (e) {
      throw Exception('Error searching for music: $e');
    }
  }
}
