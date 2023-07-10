import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/timestamp.dart';

part 'answer.g.dart';

@JsonSerializable()
class Answer {
  const Answer({
    required this.text,
    required this.votes,
    required this.authorId,
    required this.createdAt,
  });

  final String text;
  final Map<String, int> votes;
  final String authorId;
  @TimestampConverter()
  final DateTime createdAt;

  factory Answer.fromJson(Map<String, Object?> json) => _$AnswerFromJson(json);

  Map<String, Object?> toJson() => _$AnswerToJson(this);
}
