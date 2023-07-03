import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class Question {
  const Question({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.authorId,
    required this.createdAt,
  });

  final String id;
  final String category;
  final String title;
  final String description;
  final String authorId;
  final DateTime createdAt;

  static add({
    required String category,
    required String title,
    required String description,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final db = FirebaseFirestore.instance;
    final createdAt = DateTime.now();
    final ref = await db.collection('questions').add({
      'category': category.toString(),
      'title': title,
      'description': description,
      'author_id': user.uid,
      'created_at': createdAt,
    });
    final snapshot = await ref.get();

    return Question.fromSnapshot(snapshot);
  }

  static Question fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();
    if (map == null) {
      throw Exception('Data not found');
    }

    return Question(
      id: snapshot.id,
      category: map['category'],
      title: map['title'],
      description: map['description'],
      authorId: map['author_id'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    final db = FirebaseFirestore.instance;
    return db.collection('questions').orderBy('created_at').snapshots();
  }
}
