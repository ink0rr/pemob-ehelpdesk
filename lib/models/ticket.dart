import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/timestamp.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  const Ticket({
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

  factory Ticket.fromJson(Map<String, Object?> json) => _$TicketFromJson(json);

  Map<String, Object?> toJson() => _$TicketToJson(this);
}
