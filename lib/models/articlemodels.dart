
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;

  final String authorId;
  final List<String> categoryIds;

  /// Raw Firestore content map (normalized_blocks, raw, etc.)

  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  final String createdBy;
  final String excerpt;
  final String? featuredImage;

  final bool isPublished;
  final String title;

  final Map<String, dynamic>? source;

  ArticleModel({
    required this.id,
    required this.authorId,
    required this.categoryIds,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.createdBy,
    required this.excerpt,
    required this.isPublished,
    required this.title,
    this.featuredImage,
    this.source,
  });

  /// 🧪 Helpful getters
  bool get hasTitle => title.trim().isNotEmpty;

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  return ArticleModel(
    id: doc.id,
    authorId: data['author_id'] ?? '',
    categoryIds: List<String>.from(data['category_ids'] ?? []),

    createdAt: (data['created_at'] as Timestamp?)?.toDate() ??
        DateTime.now(),

    lastUpdatedAt: (data['last_updated_at'] as Timestamp?)?.toDate() ??
        DateTime.now(),

    createdBy: data['created_by'] ?? '',
    excerpt: data['excerpt'] ?? '',
    isPublished: data['isPublished'] ?? false,
    title: data['title'] ?? 'Untitled',

    featuredImage: data['featured_image'],
    source: data['source'],
  );
}
}