import 'package:json_annotation/json_annotation.dart';
import 'package:webfeed/webfeed.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String author;
  final String source;
  final DateTime publishDate;
  final String imageUrl;
  final String audioUrl;
  final int duration; // 音频时长（秒）
  final bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.author,
    required this.source,
    required this.publishDate,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    this.isFavorite = false,
  });

  /// 从RSS项创建Article对象的工厂方法
  factory Article.fromRssItem({
    required dynamic item,
    String? id,
    String? title,
    String? description,
    String? content,
    String? link,
    DateTime? pubDate,
    String? imageUrl,
  }) {
    // 提取RSS项的内容
    String articleContent = '';
    if (item is RssItem) {
      // 如果是RssItem对象，从content或description中提取内容
      articleContent = item.content?.value ?? item.description ?? '';
    } else {
      // 否则使用传入的content或description
      articleContent = content ?? description ?? '';
    }
    
    return Article(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title ?? '无标题',
      content: articleContent,
      summary: '', // 将通过AI服务生成
      author: '', // RSS项可能不包含作者信息
      source: link ?? '', // 使用链接作为来源
      publishDate: pubDate ?? DateTime.now(),
      imageUrl: imageUrl ?? '',
      audioUrl: '', // 将通过AI服务生成
      duration: 0, // 将通过AI服务生成
      isFavorite: false,
    );
  }

  /// 将JSON转换为Article对象
  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  /// 将Article对象转换为JSON
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  /// 格式化音频时长（例如：3:30）
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// 格式化发布日期
  String get formattedDate {
    return '${publishDate.year}-${publishDate.month.toString().padLeft(2, '0')}-${publishDate.day.toString().padLeft(2, '0')}';
  }

  /// 创建一个新的Article实例，用于更新收藏状态
  Article copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? author,
    String? source,
    DateTime? publishDate,
    String? imageUrl,
    String? audioUrl,
    int? duration,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      author: author ?? this.author,
      source: source ?? this.source,
      publishDate: publishDate ?? this.publishDate,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.summary == summary &&
        other.author == author &&
        other.source == source &&
        other.publishDate == publishDate &&
        other.imageUrl == imageUrl &&
        other.audioUrl == audioUrl &&
        other.duration == duration &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      summary,
      author,
      source,
      publishDate,
      imageUrl,
      audioUrl,
      duration,
      isFavorite,
    );
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, author: $author, source: $source, publishDate: $publishDate, isFavorite: $isFavorite)';
  }
}