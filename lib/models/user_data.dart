import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  const UserData({
    this.name,
    required this.username,
    required this.photoURL,
    required this.role,
    required this.createdAt,
  });

  final String? name;
  final String username;
  final String photoURL;
  final String role;
  final DateTime createdAt;

  factory UserData.fromJson(Map<String, Object?> json) => _$UserDataFromJson(json);

  Map<String, Object?> toJson() => _$UserDataToJson(this);
}
