// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'authorId': instance.authorId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
