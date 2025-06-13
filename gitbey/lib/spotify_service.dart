// File: spotify_service.dart
// Purpose: Connect backend services to Spotify for authentication and song metadata.

import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyService {
  final String clientId;
  final String clientSecret;
  String? accessToken;

  SpotifyService({required this.clientId, required this.clientSecret});

  // Authenticate with Spotify and retrieve an access token
  Future<void> authenticate() async {
    final url = 'https://accounts.spotify.com/api/token';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['access_token'];
      print('Spotify access token: $accessToken');
    } else {
      throw Exception('Failed to authenticate with Spotify: ${response.statusCode}');
    }
  }

  // Fetch track URI based on song name
  Future<String> fetchTrackUri(String songName) async {
    if (accessToken == null) {
      throw Exception('Spotify access token is not available. Please authenticate first.');
    }

    final encodedSongName = Uri.encodeComponent(songName); // URL-encode the song name
    final url = 'https://api.spotify.com/v1/search?q=$encodedSongName&type=track&limit=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trackUri = data['tracks']['items'][0]['uri'];
      print('Fetched track URI: $trackUri');
      return trackUri;
    } else {
      throw Exception('Failed to fetch track URI: ${response.statusCode}');
    }
  }
}
