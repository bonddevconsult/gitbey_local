// File: main.dart
// Purpose: Entry point for the GitBey app, allowing users to input their GitHub handle.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'github_service.dart';
import 'song_recommendation_service.dart';
import 'spotify_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  print('Initializing app...');
  await dotenv.load(); // Load environment variables
  print('GITHUB_PERSONAL_ACCESS_TOKEN: ${dotenv.env['GITHUB_PERSONAL_ACCESS_TOKEN']}'); // Debug log for token
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp widget...');
    return MaterialApp(
      title: 'GitBey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GitHubHandleInputPage(),
    );
  }
}

class GitHubHandleInputPage extends StatefulWidget {
  const GitHubHandleInputPage({super.key});

  @override
  State<GitHubHandleInputPage> createState() => _GitHubHandleInputPageState();
}

class _GitHubHandleInputPageState extends State<GitHubHandleInputPage> {
  final TextEditingController _githubHandleController = TextEditingController();
  final GitHubService _gitHubService = GitHubService(dotenv.env['GITHUB_PERSONAL_ACCESS_TOKEN'] ?? ''); // Use environment variable for token
  final SongRecommendationService _songRecommendationService = SongRecommendationService();
  final SpotifyService _spotifyService = SpotifyService(
    clientId: dotenv.env['SPOTIFY_CLIENT_ID'] ?? '',
    clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '',
  );
  bool _isValid = true;
  List<String> _commitMessages = [];
  String? _error;
  List<String> _recommendedTrackNames = [];
  List<String> _recommendedTrackImages = [];

  void _validateInput() {
    print('Validating input: ${_githubHandleController.text}');
    setState(() {
      _isValid = _githubHandleController.text.isNotEmpty;
    });
  }

  Future<void> _fetchCommits() async {
    print('Fetching commits for handle: ${_githubHandleController.text}');
    setState(() {
      _error = null;
    });

    try {
      await _spotifyService.authenticate();
      final commits = await _gitHubService.fetchCommitMessages(_githubHandleController.text);
      print('Fetched commits: $commits');

      final sentimentScores = _gitHubService.analyzeSentiment(commits);
      print('Sentiment analysis: $sentimentScores');

      final recommendedSongs = _songRecommendationService.recommendSongs(sentimentScores);
      print('Recommended songs: $recommendedSongs');

      final trackData = await Future.wait(recommendedSongs.map((song) async {
        final trackUri = await _spotifyService.fetchTrackUri(song);
        final trackImage = await _spotifyService.fetchTrackImage(song);
        print('fetchedtrackimage $trackImage '); // Fetch track image
        return {'uri': trackUri, 'name': song, 'image': trackImage};
      }));

      setState(() {
        _commitMessages = commits;
        trackData.forEach((data) => print('Track image: ${data['image']}'));
        _recommendedTrackNames = trackData.map((data) => data['name'] as String).toList();
        _recommendedTrackImages = trackData.map((data) => data['image'] as String).toList();
      });
    } catch (e) {
      print('Error fetching commits or tracks: $e');
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building GitHubHandleInputPage widget...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter GitHub Handle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            TextField(
              controller: _githubHandleController,
              decoration: InputDecoration(
                labelText: 'GitHub Handle',
                border: OutlineInputBorder(),
                errorText: _isValid ? null : 'Invalid handle',
              ),
              onChanged: (value) => _validateInput(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isValid ? _fetchCommits : null,
                child: const Text('Submit'),
              ),
            ),

            // Error Message Section
            if (_error != null) ...[
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],

            // Commit Messages Section
            if (_commitMessages.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Commit Messages:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _commitMessages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(_commitMessages[index]),
                      ),
                    );
                  },
                ),
              ),

              // Recommended Songs Section
              const SizedBox(height: 20),
              const Text(
                'Recommended Songs:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _recommendedTrackNames.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Image.network(
                          _recommendedTrackImages[index],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(_recommendedTrackNames[index]),
                        subtitle: const Text('Tap to play or pause'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
