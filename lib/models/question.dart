import 'package:flutter/material.dart';

enum QuestionCategory {
  materiPerkuliahan,
  siakad,
  elearning,
  jadwalKuliah,
  biayaKuliah,
}

@immutable
class Question {
  const Question({
    // required this.id,
    required this.category,
    required this.title,
    required this.description,
    // required this.authorId,
  });

  // final String id;
  final QuestionCategory category;
  final String title;
  final String description;
  // final String authorId;
}
