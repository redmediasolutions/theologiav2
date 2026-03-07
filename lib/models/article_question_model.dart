import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleQuestionModel {
  final String id;
  final String question;
  final String answer;
  final String askedBy;
  final DateTime? createdAt;

  ArticleQuestionModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.askedBy,
    this.createdAt,
  });

  factory ArticleQuestionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {

    final data = doc.data()!;

    return ArticleQuestionModel(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      askedBy: data['askedBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}