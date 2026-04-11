import 'package:cloud_firestore/cloud_firestore.dart';

class Singlearticlemodel {
  final String id;
  final String title;
  final String excerpt;
  final String authorId;
  final String createdBy;
  final List<String> categoryIds;
  final Map<String, dynamic> content;
  final bool isPublished;
  final int updateCount;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String? featuredImage;
  final Map<String, dynamic>? source;

  // ✅ NEW FIELD
  final String? slug;

  Singlearticlemodel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.authorId,
    required this.createdBy,
    required this.categoryIds,
    required this.content,
    required this.isPublished,
    required this.updateCount,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.featuredImage,
    this.source,
    this.slug, // ✅ added
  });

  /// 🔥 Factory Constructor
  factory Singlearticlemodel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Singlearticlemodel(
      id: doc.id,
      title: data['title'] ?? '',
      excerpt: data['excerpt'] ?? '',
      authorId: data['author_id'] ?? '',
      createdBy: data['created_by'] ?? '',
      categoryIds: List<String>.from(data['category_ids'] ?? []),
      content: Map<String, dynamic>.from(data['content'] ?? {}),
      isPublished: data['isPublished'] ?? false,
      updateCount: data['update_count'] ?? 0,
      createdAt:
          (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdatedAt:
          (data['last_updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      featuredImage: data['featured_image'],
      source: data['source'] != null
          ? Map<String, dynamic>.from(data['source'])
          : null,

      // ✅ FETCH SLUG
      slug: data['slug'],
    );
  }

  /// 🔥 Precomputed once (performance optimized)
  late final List<Map<String, dynamic>> normalizedBlocks =
      _normalizeContent();

  /// 🔥 Private content normalizer
  List<Map<String, dynamic>> _normalizeContent() {
    if (content.isEmpty) return [];

    final full = content['full'];
    if (full is! Map<String, dynamic>) return [];

    final rawBlocks = full['normalized_blocks'];
    if (rawBlocks is! List) return [];

    return rawBlocks.map<Map<String, dynamic>>((block) {
      final map = Map<String, dynamic>.from(block);

      return {
        'type': map['type'],
        'level': map['level'],
        'ordered': map['ordered'],
        'reference': map['reference'],
        'url': map['url'],
        'content': map['content'],
      };
    }).toList();
  }
}