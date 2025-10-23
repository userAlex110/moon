import 'package:flutter/material.dart';
import 'models/article.dart';
import 'services/article_service.dart';
import 'services/audio_service.dart';
import 'widgets/article_card.dart';
import 'widgets/audio_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> _articles = [];
  final Set<String> _favorites = <String>{};
  
  final ArticleService _articleService = ArticleService();
  final AudioService _audioService = AudioService();
  
  String? _currentPlayingId;
  bool _isPlaying = false;
  Duration _progress = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 使用ArticleService获取每日推荐文章
      final articles = await _articleService.fetchDailyArticles();
      
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
      
      // 显示加载成功的提示
      if (articles.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('成功加载 ${articles.length} 篇推荐文章'),
              duration: const Duration(seconds: 3),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('加载文章失败: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('加载文章时出现错误，正在显示本地数据'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  void _playArticle(Article article) async {
    if (_currentPlayingId == article.id && _isPlaying) {
      // 暂停当前播放
      await _audioService.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      // 播放新文章或继续播放
      await _audioService.play(article.audioUrl);
      setState(() {
        _currentPlayingId = article.id;
        _isPlaying = true;
        _duration = Duration(seconds: article.duration);
      });
    }
  }

  void _toggleFavorite(String articleId) async {
    final isCurrentlyFavorite = _favorites.contains(articleId);
    
    // 使用ArticleService更新收藏状态
    final success = await _articleService.favoriteArticle(
      articleId, 
      !isCurrentlyFavorite
    );
    
    if (success) {
      setState(() {
        if (isCurrentlyFavorite) {
          _favorites.remove(articleId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已取消收藏')),
          );
        } else {
          _favorites.add(articleId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已添加到收藏')),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('收藏操作失败')),
      );
    }
  }

  void _seekTo(Duration position) async {
    await _audioService.seek(position);
    setState(() {
      _progress = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 播客'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 文章列表
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _articles.isEmpty
                    ? const Center(
                        child: Text('暂无文章数据'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          final article = _articles[index];
                          final isCurrentPlaying = _currentPlayingId == article.id;
                          
                          return ArticleCard(
                            article: article,
                            isPlaying: isCurrentPlaying && _isPlaying,
                            isFavorite: _favorites.contains(article.id),
                            onPlay: () => _playArticle(article),
                            onFavorite: () => _toggleFavorite(article.id),
                          );
                        },
                      ),
          ),
          
          // 音频播放器（仅在播放时显示）
          if (_currentPlayingId != null)
            AudioPlayer(
              isPlaying: _isPlaying,
              progress: _progress,
              duration: _duration,
              onPlayPause: () {
                final article = _articles.firstWhere(
                  (a) => a.id == _currentPlayingId,
                );
                _playArticle(article);
              },
              onSeek: _seekTo,
            ),
        ],
      ),
    );
  }
}
