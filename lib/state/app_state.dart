import 'package:flutter/foundation.dart';

class Episode {
  Episode({required this.title, required this.audioUrl});

  final String title;
  final String audioUrl;
}

class AppState extends ChangeNotifier {
  AppState();

  final List<String> availableTopics = <String>[
    'AI',
    'Science',
    'Technology',
    'Business',
    'Health',
    'Sports',
    'Politics',
    'Culture',
  ];

  final Set<String> selectedTopics = <String>{};

  final List<Episode> generatedEpisodes = <Episode>[];

  final List<Episode> favoriteEpisodes = <Episode>[];

  void toggleTopicSelection(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
    notifyListeners();
  }

  bool isTopicSelected(String topic) => selectedTopics.contains(topic);

  Future<Episode> generatePodcast() async {
    // 在接入真实 API 前，这里先模拟一个耗时的生成过程
    await Future<void>.delayed(const Duration(seconds: 1));

    final String title =
        selectedTopics.isEmpty ? 'Daily Briefing' : selectedTopics.join(', ');
    // 占位音频链接；接入后端后替换为真实 URL
    const String audioUrl =
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

    final Episode episode = Episode(title: title, audioUrl: audioUrl);
    generatedEpisodes.insert(0, episode);
    notifyListeners();
    return episode;
  }

  void toggleFavorite(Episode episode) {
    final int index = favoriteEpisodes.indexWhere(
      (Episode e) => e.audioUrl == episode.audioUrl && e.title == episode.title,
    );
    if (index >= 0) {
      favoriteEpisodes.removeAt(index);
    } else {
      favoriteEpisodes.add(episode);
    }
    notifyListeners();
  }

  bool isFavorite(Episode episode) {
    return favoriteEpisodes.any(
      (Episode e) => e.audioUrl == episode.audioUrl && e.title == episode.title,
    );
  }
}


