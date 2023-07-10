// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      votes: Map<String, int>.from(json['votes'] as Map),
      authorId: json['authorId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'votes': instance.votes,
      'authorId': instance.authorId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
