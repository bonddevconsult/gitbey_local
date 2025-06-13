# Spec: Play and Pause Functionality

## Objective

Implement play and pause functionality in `music_player.dart` to allow users to control the playback of recommended songs. The functionality should integrate with the Spotify API to manage playback state.

## Steps to Achieve Objective

### 1. Update UI State Management

- Add a boolean `isPlaying` to track the playback state.
- Use `setState` to update the UI when the playback state changes.

#### UI State Management Example

```dart
bool isPlaying = false;

void playTrack() {
  setState(() {
    isPlaying = true;
  });
}

void pauseTrack() {
  setState(() {
    isPlaying = false;
  });
}
```

### 2. Integrate Spotify API for Playback

- Use the Spotify API to play and pause tracks.
- Add API calls in `playTrack` and `pauseTrack` methods.
- Handle API responses to ensure the playback state is synchronized with Spotify.

#### Spotify API Integration Example

```dart
import 'package:http/http.dart' as http;

Future<void> playTrack(String trackUri, String accessToken) async {
  final url = Uri.parse('https://api.spotify.com/v1/me/player/play');
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: '{"uris": ["$trackUri"]}',
  );

  if (response.statusCode != 204) {
    throw Exception('Failed to play track: ${response.body}');
  }
}

Future<void> pauseTrack(String accessToken) async {
  final url = Uri.parse('https://api.spotify.com/v1/me/player/pause');
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode != 204) {
    throw Exception('Failed to pause track: ${response.body}');
  }
}
```

### 3. Add Error Handling

- Display user-friendly error messages for playback failures.
- Use a helper method `showError` to show error messages in a dialog or snackbar.

#### Error Handling Example

```dart
void showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

### 4. Write Unit Tests

- Mock Spotify API responses to simulate success and failure scenarios.
- Test `playTrack` and `pauseTrack` methods to ensure they handle API responses correctly.

#### Unit Testing Example

```dart
void testPlayTrack() {
  // Mock successful API response
  SpotifyService.play = (uri) => Future.value(Response(success: true));
  playTrack();
  assert(isPlaying == true);

  // Mock failure API response
  SpotifyService.play = (uri) => Future.value(Response(success: false, errorMessage: "Error"));
  playTrack();
  assert(isPlaying == false);
}

void testPauseTrack() {
  // Mock successful API response
  SpotifyService.pause = () => Future.value(Response(success: true));
  pauseTrack();
  assert(isPlaying == false);

  // Mock failure API response
  SpotifyService.pause = () => Future.value(Response(success: false, errorMessage: "Error"));
  pauseTrack();
  assert(isPlaying == true);
}
```

### 5. Enhance UI

- Disable the "Play" button when `isPlaying` is true.
- Disable the "Pause" button when `isPlaying` is false.

#### UI Enhancement Example

```dart
ElevatedButton(
  onPressed: isPlaying ? null : playTrack,
  child: const Text('Play'),
),
ElevatedButton(
  onPressed: isPlaying ? pauseTrack : null,
  child: const Text('Pause'),
),
```

## Necessary User Intervention

- Users must authenticate with Spotify to enable playback functionality.
- Users must grant necessary permissions for the app to control playback.

## Notes

- Ensure the Spotify API credentials are securely stored and not hardcoded.
- Consider adding a loading indicator while the API call is in progress.
