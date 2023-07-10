// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      text: json['text'] as String,
      votes: Map<String, int>.from(json['votes'] as Map),
      authorId: json['authorId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'text': instance.text,
      'votes': instance.votes,
      'authorId': instance.authorId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
