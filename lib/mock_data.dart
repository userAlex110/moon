import 'models/article.dart';

class MockData {
  /// 获取模拟文章列表
  static List<Article> getMockArticles() {
    return [
      Article(
        id: '1',
        title: 'Flutter状态管理最佳实践',
        content: '在Flutter开发中，状态管理是一个重要的话题。本文将介绍几种主流的状态管理方案，并分析它们的优缺点。',
        summary: '介绍Flutter中主流状态管理方案的比较和最佳实践',
        author: '张三',
        source: 'Flutter官方博客',
        publishDate: DateTime(2023, 10, 15),
        imageUrl: 'lib/assets/sample_image.jpg',
        audioUrl: 'lib/assets/sample.mp3',
        duration: 360, // 6分钟
        isFavorite: false,
      ),
      Article(
        id: '2',
        title: 'Dart语言新特性详解',
        content: 'Dart语言在不断演进，新版本带来了许多有用的新特性。本文将详细介绍空安全、扩展方法等重要特性。',
        summary: '详解Dart语言最新版本的重要新特性及其使用方法',
        author: '李四',
        source: 'Dart开发者社区',
        publishDate: DateTime(2023, 10, 14),
        imageUrl: 'lib/assets/sample_image.jpg',
        audioUrl: 'lib/assets/sample.mp3',
        duration: 420, // 7分钟
        isFavorite: true,
      ),
      Article(
        id: '3',
        title: '构建高性能Flutter应用',
        content: '性能优化是移动应用开发中的关键环节。本文将分享一些实用的Flutter性能优化技巧和最佳实践。',
        summary: '分享Flutter应用性能优化的关键技巧和实践经验',
        author: '王五',
        source: '移动开发技术周刊',
        publishDate: DateTime(2023, 10, 13),
        imageUrl: 'lib/assets/sample_image.jpg',
        audioUrl: 'lib/assets/sample.mp3',
        duration: 300, // 5分钟
        isFavorite: false,
      ),
    ];
  }
}