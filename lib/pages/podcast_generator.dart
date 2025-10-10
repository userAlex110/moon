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
        // 主题选择区域
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    '选择感兴趣的主题',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '已选择 ${appState.selectedTopics.length} 个主题',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: appState.availableTopics.length,
            itemBuilder: (BuildContext context, int index) {
              final String topic = appState.availableTopics[index];
              final bool selected = appState.isTopicSelected(topic);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: selected ? 4 : 1,
                color: selected 
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
                child: ListTile(
                  leading: Icon(
                    _getTopicIcon(topic),
                    color: selected 
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    topic,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: Checkbox(
                    value: selected,
                    onChanged: (bool? value) {
                      appState.toggleTopicSelection(topic);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () => appState.toggleTopicSelection(topic),
                ),
              );
            },
          ),
        ),
        // 生成按钮
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
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
                            const SnackBar(content: Text('播客生成完成！')),
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
              icon: _isGenerating 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.podcasts),
              label: Text(_isGenerating ? '正在生成...' : '生成播客'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        // 生成结果区域
        if (appState.generatedEpisodes.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  '生成的播客',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: appState.generatedEpisodes.length,
              itemBuilder: (BuildContext context, int index) {
                final Episode episode = appState.generatedEpisodes[index];
                final bool fav = appState.isFavorite(episode);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      episode.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '点击播放',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.red : null,
                      ),
                      onPressed: () => appState.toggleFavorite(episode),
                      tooltip: fav ? '取消收藏' : '收藏',
                    ),
                    onTap: () {
                      // 播放功能稍后在集成 just_audio 后补上
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  IconData _getTopicIcon(String topic) {
    switch (topic) {
      case 'AI':
        return Icons.smart_toy;
      case 'Science':
        return Icons.science;
      case 'Technology':
        return Icons.computer;
      case 'Business':
        return Icons.business;
      case 'Health':
        return Icons.health_and_safety;
      case 'Sports':
        return Icons.sports;
      case 'Politics':
        return Icons.account_balance;
      case 'Culture':
        return Icons.palette;
      default:
        return Icons.topic;
    }
  }
}


