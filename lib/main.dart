import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/favorites_page.dart';
import 'pages/podcast_generator.dart';
import 'pages/article_detail.dart';
import 'state/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: const MoonApp(),
    ),
  );
}

class MoonApp extends StatelessWidget {
  const MoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Podcast',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const PodcastGeneratorPage(),
      ArticleDetailPage(
        title: '沉浸式阅读设计：让内容成为主角',
        source: 'Design Weekly',
        publishedAt: DateTime.now(),
        content:
            '这是一个示例文章页面，用于展示沉浸式阅读布局。\n\n'
            '核心原则：\n'
            '1) 减少干扰：以内容为中心，控制装饰元素。\n'
            '2) 分层清晰：标题 > 元信息 > 正文 > 操作栏。\n'
            '3) 响应式布局：在手机上保证舒适的阅读宽度。\n\n'
            '你可以在此处粘贴长文，观察滚动进度、字号调节等体验。',
      ),
      const FavoritesPage(),
    ];
      
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? '生成播客'
              : _selectedIndex == 1
                  ? '文章'
                  : '收藏',
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.podcasts_outlined),
            activeIcon: Icon(Icons.podcasts),
            label: '生成',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: '文章',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '收藏',
          ),
        ],
      ),
    );
  }
}