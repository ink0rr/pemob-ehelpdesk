import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/timestamp.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  const Message({
    required this.message,
    required this.authorId,
    required this.createdAt,
  });

  final String message;
  final String authorId;
  @TimestampConverter()
  final DateTime createdAt;

  factory Message.fromJson(Map<String, Object?> json) => _$MessageFromJson(json);

  Map<String, Object?> toJson() => _$MessageToJson(this);
}
