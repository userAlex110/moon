import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:moon/models/article.dart';
import '../mock_data.dart';

class ArticleService {
  
  /// 获取每日推荐文章列表
  Future<List<Article>> fetchDailyArticles() async {
    try {
      // RSS源URL，替换为实际的RSS源地址
      final String rssUrl = 'https://juejin.cn/rss'; // 替换为实际RSS地址
      
      // 获取RSS内容
      final response = await http.get(Uri.parse(rssUrl)).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('请求超时');
        },
      );
      
      if (response.statusCode == 200) {
        // 解析RSS内容
        final rssFeed = RssFeed.parse(response.body);
        
        // 将RSS项转换为Article对象
        final articles = <Article>[];
        if (rssFeed.items != null) {
          for (var item in rssFeed.items!) {
            final article = Article.fromRssItem(
              item: item,
              id: item.guid ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: item.title ?? '无标题',
              description: item.description,
              content: item.content?.value ?? item.description ?? '',
              link: item.link,
              pubDate: item.pubDate ?? DateTime.now(),
            );
            articles.add(article);
          }
        }
        
        return articles;
      } else {
        // HTTP请求失败时返回模拟数据
        print('Failed to load RSS feed. Status code: ${response.statusCode}');
        return MockData.getMockArticles();
      }
    } on TimeoutException catch (e) {
      // 超时处理
      print('Timeout error: $e');
      return MockData.getMockArticles();
    } on http.ClientException catch (e) {
      // 网络错误处理
      print('Network error: $e');
      return MockData.getMockArticles();
    } catch (e) {
      // 其他错误处理
      print('Error fetching articles: $e');
      return MockData.getMockArticles();
    }
  }

  /// 根据ID获取特定文章
  Future<Article?> fetchArticleById(String id) async {
    try {
      // 在实际应用中，这里会调用API获取数据
      // final response = await http.get(Uri.parse('$_baseUrl/articles/$id'));
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> data = json.decode(response.body);
      //   return Article.fromJson(data);
      // } else {
      //   throw Exception('Failed to load article');
      // }
      
      // 目前使用模拟数据
      final articles = MockData.getMockArticles();
      return articles.firstWhere((article) => article.id == id);
    } catch (e) {
      print('Error fetching article: $e');
      return null;
    }
  }

  /// 收藏文章
  Future<bool> favoriteArticle(String articleId, bool favorite) async {
    try {
      // 在实际应用中，这里会调用API更新收藏状态
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/articles/$articleId/favorite'),
      //   body: {'favorite': favorite.toString()},
      // );
      // return response.statusCode == 200;
      
      // 模拟操作成功
      return true;
    } catch (e) {
      print('Error favoriting article: $e');
      return false;
    }
  }

  /// 获取AI生成的文章摘要
  Future<String> fetchArticleSummary(String articleId) async {
    try {
      // 在实际应用中，这里会调用AI服务API获取文章摘要
      // final response = await http.get(Uri.parse('$_baseUrl/articles/$articleId/summary'));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return data['summary'];
      // } else {
      //   throw Exception('Failed to load summary');
      // }
      
      // 模拟返回摘要
      return "这是文章的AI生成摘要。在实际应用中，这将是通过AI分析文章内容后生成的智能摘要。";
    } catch (e) {
      print('Error fetching summary: $e');
      return "摘要生成失败。";
    }
  }

  /// 获取AI生成的播客音频
  Future<String> fetchPodcastAudio(String articleId) async {
    try {
      // 在实际应用中，这里会调用AI服务API生成播客音频
      // final response = await http.get(Uri.parse('$_baseUrl/articles/$articleId/podcast'));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return data['audioUrl'];
      // } else {
      //   throw Exception('Failed to generate podcast');
      // }
      
      // 模拟返回音频URL
      return "lib/assets/sample.mp3";
    } catch (e) {
      print('Error fetching podcast: $e');
      return "";
    }
  }
}