// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  summary: json['summary'] as String,
  author: json['author'] as String,
  source: json['source'] as String,
  publishDate: DateTime.parse(json['publishDate'] as String),
  imageUrl: json['imageUrl'] as String,
  audioUrl: json['audioUrl'] as String,
  duration: (json['duration'] as num).toInt(),
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'summary': instance.summary,
  'author': instance.author,
  'source': instance.source,
  'publishDate': instance.publishDate.toIso8601String(),
  'imageUrl': instance.imageUrl,
  'audioUrl': instance.audioUrl,
  'duration': instance.duration,
  'isFavorite': instance.isFavorite,
};
