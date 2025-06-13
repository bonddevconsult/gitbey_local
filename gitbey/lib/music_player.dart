// File: music_player.dart
// Purpose: Implements playback controls for recommended songs.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv for environment variables
import 'spotify_service.dart'; // Import SpotifyService

class MusicPlayer extends StatefulWidget {
  final String trackUri;

  const MusicPlayer({
    Key? key,
    required this.trackUri,
  }) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  late SpotifyService _spotifyService;

  @override
  void initState() {
    super.initState();
    _spotifyService = SpotifyService(
      clientId: dotenv.env['SPOTIFY_CLIENT_ID'] ?? '',
      clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '',
    );
    _authenticateSpotify();
  }

  Future<void> _authenticateSpotify() async {
    try {
      await _spotifyService.authenticate();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Spotify authentication failed: $e')),
      );
    }
  }

  Future<void> playTrack() async {
    setState(() {
      isPlaying = true;
    });
    try {
      final url = Uri.parse('https://api.spotify.com/v1/me/player/play');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer ${_spotifyService.accessToken}',
          'Content-Type': 'application/json',
        },
        body: '{"uris": ["${widget.trackUri}"]}',
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to play track: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> pauseTrack() async {
    setState(() {
      isPlaying = false;
    });
    try {
      final url = Uri.parse('https://api.spotify.com/v1/me/player/pause');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer ${_spotifyService.accessToken}',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to pause track: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isPlaying = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Track URI: ${widget.trackUri}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isPlaying ? null : playTrack,
              child: const Text('Play'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: isPlaying ? pauseTrack : null,
              child: const Text('Pause'),
            ),
          ],
        ),
      ],
    );
  }
}
