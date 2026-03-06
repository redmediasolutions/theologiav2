import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/models/collection_model.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference articlesCollection = FirebaseFirestore.instance.collection('collection_articles');
  final CollectionReference collectionsCollection =FirebaseFirestore.instance.collection('Collections');
  final CollectionReference devotionsCollection = FirebaseFirestore.instance.collection('Devotions');

  // =========================================================
  // 🔹 YOUTUBE / GENERAL ARTICLES
  // =========================================================

  Stream<List<ArticleModel>> get getYoutubeVideos {
    return articlesCollection
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .map(_mapArticleList);
  }

  // =========================================================
  // 🔹 FEATURED ARTICLES
  // =========================================================

  Stream<List<ArticleModel>> get getFeaturedArticles {
    return articlesCollection
        .where('isPublished', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map(_mapArticleList);
  }

  // =========================================================
  // 🔹 COLLECTION BASED ARTICLES (NEW SYSTEM)
  // =========================================================

  Stream<List<ArticleModel>> getArticlesByCollection(
      String collectionId) {
    return articlesCollection
        .where('isPublished', isEqualTo: true)
        .where('collectionIds',
            arrayContains: collectionId)
        .snapshots()
        .handleError((error) {
          print(
              'Error fetching articles for collection $collectionId: $error');
        })
        .map(_mapArticleList);
  }

    // =========================================================
  // 🔹 COLLECTION FOR HOME
  // =========================================================


Stream<List<CollectionModel>> streamCollectionsforHome() {
  return collectionsCollection
      .where('isPublished', isEqualTo: true)
      .where('isHome', isEqualTo: true)
      .orderBy('HomeOrder', descending: false)
      .snapshots()
      .handleError((error) {
        print('Error fetching collections: $error');
      })
      .map((snapshot) =>
          snapshot.docs
              .map((doc) =>
                  CollectionModel.fromFirestore(doc))
              .toList());
}

  Stream<List<CollectionArticleViewModel>>
    streamCollectionOfArticles(String collectionId) {

  final collectionStream = _db
      .collection('collection_articles')
      .where('collectionId', isEqualTo: collectionId)
      .orderBy('order')
      .snapshots();

  return collectionStream.asyncMap((snapshot) async {
    if (snapshot.docs.isEmpty) {
      return [];
    }

    final futures = snapshot.docs.map((doc) async {
      final data = doc.data();
      final String articleId = data['articleId'];

      final articleDoc = await _db
          .collection('Articles')
          .doc(articleId)
          .get();

      if (!articleDoc.exists) {
        return null;
      }

      final articleData =
          articleDoc.data() as Map<String, dynamic>;

      // Optional publish guard
      if (articleData['isPublished'] != true) {
        return null;
      }

      return CollectionArticleViewModel(
        itemId: doc.id,
        articleId: articleId,
        title: articleData['title'] ?? 'Untitled',
        summary: articleData['excerpt'] ?? '',
        order: data['order'] ?? 0,
        featuredImage: articleData['featured_image'],
      );
    }).toList();

    final results = await Future.wait(futures);

    // remove nulls safely
    return results.whereType<CollectionArticleViewModel>().toList();
  });
}
  // =========================================================
  // 🔹 STREAM ALL COLLECTIONS
  // =========================================================

Stream<List<CollectionModel>> streamCollections() {
  return collectionsCollection
      .orderBy('order', descending: false)
      .snapshots()
      .handleError((error) {
        print('Error fetching collections: $error');
      })
      .map((snapshot) =>
          snapshot.docs
              .map((doc) =>
                  CollectionModel.fromFirestore(doc))
              .toList());
}

  // =========================================================
  // 🔹 STREAM SINGLE COLLECTION
  // =========================================================

  Stream<Map<String, dynamic>?> streamCollectionById(
      String collectionId) {
    return collectionsCollection
        .doc(collectionId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data =
          doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description':
            data['description'] ?? '',
        'coverImage': data['coverImage'],
        'order': data['order'] ?? 0,
      };
    });
  }

  // =========================================================
  // 🔹 SINGLE ARTICLE
  // =========================================================

  static Stream<Singlearticlemodel?> streamArticleById(
      String articleId) {
    return FirebaseFirestore.instance
        .collection('Articles')
        .doc(articleId)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final data =
          doc.data()!;

      if (data['isPublished'] != true) {
        return null;
      }

      return Singlearticlemodel(
        id: doc.id,
        authorId: data['author_id'] ?? '',
        createdBy: data['created_by'] ?? '',
        categoryIds: List<String>.from(
          (data['category_ids'] as List?) ?? const [],
        ),
        content: Map<String, dynamic>.from(
          (data['content'] as Map?) ?? const {},
        ),
        title: data['title'] ?? '',
        excerpt: data['excerpt'] ?? '',
        featuredImage: data['featured_image'],
        isPublished: data['isPublished'] ?? false,
        updateCount: data['update_count'] ?? 0,
        createdAt:
            (data['created_at'] as Timestamp?)
                    ?.toDate() ??
                DateTime.now(),
        lastUpdatedAt:
            (data['last_updated_at'] as Timestamp?)
                    ?.toDate() ??
                DateTime.now(),
        source: data['source'] != null
            ? Map<String, dynamic>.from(
                data['source'])
            : null,
      );
    });
  }

  // =========================================================
  // 🔹 PRIVATE ARTICLE MAPPER (CLEANER)
  // =========================================================

  List<ArticleModel> _mapArticleList(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data =
          doc.data() as Map<String, dynamic>;

      return ArticleModel(
        id: doc.id,
        authorId: data['author_id'] ?? '',
        categoryIds:
            List<String>.from(data['category_ids'] ?? []),
        createdAt:
            (data['created_at'] as Timestamp?)
                    ?.toDate() ??
                DateTime.now(),
        lastUpdatedAt:
            (data['last_updated_at'] as Timestamp?)
                    ?.toDate() ??
                DateTime.now(),
        createdBy: data['created_by'] ?? '',
        excerpt: data['excerpt'] ?? '',
        featuredImage: data['featured_image'],
        isPublished: data['isPublished'] ?? false,
        title: data['title'] ?? '',
        source: data['source'] != null
            ? Map<String, dynamic>.from(
                data['source'])
            : null,
      );
    }).toList();
  }

  // =========================================================
// 🔹 DEVOTIONS
// =========================================================

/// Stream all published devotions (latest first)
Stream<List<DevotionModel>> streamDevotions(int limit) {
  return devotionsCollection
      .where('isPublished', isEqualTo: true)
      .orderBy('episodeData', descending: true)
      .limit(limit)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs
              .map((doc) =>
                  DevotionModel.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList());
}

/// Fetch once (Future version)
Future<List<DevotionModel>> fetchDevotions() async {
  final snapshot = await devotionsCollection
      .where('isPublished', isEqualTo: true)
      .orderBy('episodeData', descending: true)
      .get();

  return snapshot.docs
      .map((doc) =>
          DevotionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
      .toList();
}

/// Stream today's devotion
Stream<DevotionModel?> streamTodayDevotion() {
  return devotionsCollection
      .where('episodeIsToday', isEqualTo: true)
      .where('isPublished', isEqualTo: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;

        return DevotionModel.fromFirestore(
          snapshot.docs.first
              as DocumentSnapshot<Map<String, dynamic>>,
        );
      });
}
}