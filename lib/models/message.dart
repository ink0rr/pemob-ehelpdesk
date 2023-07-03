import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class Message {
  const Message({
    required this.message,
    required this.authorId,
    required this.createdAt,
  });

  final String message;
  final String authorId;
  final DateTime createdAt;

  static add({
    required String questionId,
    required String message,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final db = FirebaseFirestore.instance;
    final createdAt = DateTime.now();
    final ref = await db.collection('questions/$questionId/messages').add({
      'message': message,
      'author_id': user.uid,
      'created_at': createdAt,
    });
    final snapshot = await ref.get();

    return Message.fromSnapshot(snapshot);
  }

  static Message fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();
    if (map == null) {
      throw Exception('Data not found');
    }

    return Message(
      message: map['message'],
      authorId: map['author_id'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots(
    String questionId,
  ) {
    final db = FirebaseFirestore.instance;
    return db
        .collection('/questions/$questionId/messages')
        .orderBy('created_at')
        .snapshots();
  }
}
