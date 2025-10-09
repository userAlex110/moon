import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class PodcastGeneratorPage extends StatefulWidget {
  const PodcastGeneratorPage({super.key});

  @override
  State<PodcastGeneratorPage> createState() => _PodcastGeneratorPageState();
}

class _PodcastGeneratorPageState extends State<PodcastGeneratorPage> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: appState.availableTopics.length,
            itemBuilder: (BuildContext context, int index) {
              final String topic = appState.availableTopics[index];
              final bool selected = appState.isTopicSelected(topic);
              return CheckboxListTile(
                title: Text(topic),
                value: selected,
                onChanged: (bool? value) {
                  appState.toggleTopicSelection(topic);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: appState.selectedTopics.isEmpty || _isGenerating
                ? null
                : () async {
                    setState(() {
                      _isGenerating = true;
                    });
                    try {
                      await appState.generatePodcast();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('生成完成')),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isGenerating = false;
                        });
                      }
                    }
                  },
            icon: const Icon(Icons.podcasts),
            label: Text(_isGenerating ? '正在生成...' : '生成播客'),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: appState.generatedEpisodes.length,
            itemBuilder: (BuildContext context, int index) {
              final Episode episode = appState.generatedEpisodes[index];
              final bool fav = appState.isFavorite(episode);
              return ListTile(
                title: Text(episode.title),
                subtitle: Text(episode.audioUrl),
                trailing: IconButton(
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => appState.toggleFavorite(episode),
                ),
                onTap: () {
                  // 播放功能稍后在集成 just_audio 后补上
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


