// File: song_recommendation_service.dart
// Purpose: Provides functionality to recommend songs based on sentiment analysis.

class SongRecommendationService {
  // Maps sentiment categories to Beyoncé songs
  final Map<String, List<String>> songMapping = {
    'happy': ['Halo', 'Love On Top', 'Crazy In Love', 'Single Ladies', 'Irreplaceable'],
    'frustrated': ['Ring the Alarm', 'Resentment', 'I Care', 'Don’t Hurt Yourself', 'Freedom'],
    'productive': ['Run the World (Girls)', 'Formation', 'End of Time', 'Upgrade U', 'Diva'],
  };

  // Recommends songs based on sentiment scores
  List<String> recommendSongs(Map<String, int> sentimentScores) {
    final List<String> recommendedSongs = [];

    sentimentScores.forEach((sentiment, score) {
      if (songMapping.containsKey(sentiment)) {
        recommendedSongs.addAll(songMapping[sentiment]!.take(score));
      }
    });

    return recommendedSongs.take(5).toList(); // Limit to 5 songs
  }
}
