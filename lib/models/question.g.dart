// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      votes: Map<String, int>.from(json['votes'] as Map),
      answerId: json['answerId'] as String?,
      authorId: json['authorId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'votes': instance.votes,
      'answerId': instance.answerId,
      'authorId': instance.authorId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
