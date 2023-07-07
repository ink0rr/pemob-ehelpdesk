import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/timestamp.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  const Question({
    required this.category,
    required this.title,
    required this.description,
    required this.authorId,
    required this.createdAt,
  });

  final String category;
  final String title;
  final String description;
  final String authorId;
  @TimestampConverter()
  final DateTime createdAt;

  factory Question.fromJson(Map<String, Object?> json) => _$QuestionFromJson(json);

  Map<String, Object?> toJson() => _$QuestionToJson(this);
}
