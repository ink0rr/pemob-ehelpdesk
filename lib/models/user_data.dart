import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class UserData {
  const UserData({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  final String id;
  final String username;
  final String avatarUrl;

  static Future<void> register({
    required String id,
    required String username,
  }) async {
    final db = FirebaseFirestore.instance;
    await db.collection('users').doc(id).set({
      'username': username,
      'avatar_url':
          'https://ui-avatars.com/api/?background=random&name=${username.split(" ").join("+")}&size=128&format=png',
    });
  }

  static UserData fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();
    if (map == null) {
      throw Exception('Data not found');
    }

    return UserData(
      id: snapshot.id,
      username: map['username'],
      avatarUrl: map['avatar_url'],
    );
  }

  static Future<UserData> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final db = FirebaseFirestore.instance;
    return await db.collection('users').doc(user.uid).get().then(fromSnapshot);
  }
}
