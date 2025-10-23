import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 来源和时长
            Row(
              children: [
                Icon(Icons.public, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(article.source, style: theme.textTheme.bodySmall),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  article.formattedDuration,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 正文内容
            Text(
              article.content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),

            const SizedBox(height: 24),

            // 播放按钮（可选）
            ElevatedButton.icon(
              onPressed: () {
                // TODO: 播放文章对应音频
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('播放音频'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
