import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    if (appState.favoriteEpisodes.isEmpty) {
      return const Center(child: Text('还没有收藏的播客'));
    }
    return ListView.separated(
      itemCount: appState.favoriteEpisodes.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final Episode episode = appState.favoriteEpisodes[index];
        return ListTile(
          title: Text(episode.title),
          subtitle: Text(episode.audioUrl),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => appState.toggleFavorite(episode),
            tooltip: '移除收藏',
          ),
          onTap: () {
            // 播放功能稍后在集成 just_audio 后补上
          },
        );
      },
    );
  }
}


