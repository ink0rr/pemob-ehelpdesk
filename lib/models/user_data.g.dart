// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      name: json['name'] as String?,
      username: json['username'] as String,
      photoURL: json['photoURL'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'photoURL': instance.photoURL,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
    };
