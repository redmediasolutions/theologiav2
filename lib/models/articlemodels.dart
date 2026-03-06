
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
}