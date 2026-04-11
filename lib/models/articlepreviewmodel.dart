import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePreviewModel {
  final String id;
  final String title;
  final String? featuredImage;
  final String? slug; // ✅ NEW

  ArticlePreviewModel({
    required this.id,
    required this.title,
    this.featuredImage,
    this.slug, // ✅ NEW
  });

  factory ArticlePreviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return ArticlePreviewModel(
      id: doc.id,
      title: data?['title'] ?? 'Untitled',
      featuredImage: data?['featured_image'],
      slug: data?['slug'], // ✅ NEW
    );
  }
}