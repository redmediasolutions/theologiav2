import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theologia_app_1/models/article_question_model.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/models/collection_model.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference articlesCollection =
      FirebaseFirestore.instance.collection('collection_articles');

  final CollectionReference collectionsCollection =
      FirebaseFirestore.instance.collection('Collections');

  final CollectionReference devotionsCollection =
      FirebaseFirestore.instance.collection('Devotions');

  // =========================================================
  // YOUTUBE / GENERAL ARTICLES
  // =========================================================

  Stream<List<ArticleModel>> get getYoutubeVideos {
    return articlesCollection
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .handleError((error) {
          print('Youtube stream error: $error');
        })
        .map(_safeMapArticleList);
  }

  // =========================================================
  // FEATURED ARTICLES
  // =========================================================

  // =========================================================
// FEATURED ARTICLES
// =========================================================

Stream<List<ArticleModel>> get getFeaturedArticles {

  print("🔥 getFeaturedArticles STREAM CREATED");

  return articlesCollection
      .where('isPublished', isEqualTo: true)
      .where('isFeatured', isEqualTo: true)
      .snapshots()
      .handleError((error) {
        print("🔥 Featured articles stream ERROR: $error");
      })
      .map((snapshot) {

        print("📡 Featured articles SNAPSHOT received");
        print("📊 Documents count: ${snapshot.docs.length}");

        try {

          final result = _safeMapArticleList(snapshot);

          print("✅ Featured articles mapped successfully");
          print("📚 Articles returned: ${result.length}");

          return result;

        } catch (e, stack) {

          print("🔥 Featured article mapping ERROR");
          print(e);
          print(stack);

          return [];

        }
      });
}
// =========================================================
// ARTICLES BY COLLECTION
// =========================================================

Stream<List<ArticleModel>> getArticlesByCollection(String collectionId) {

  print("🔥 getArticlesByCollection STREAM CREATED");
  print("📁 CollectionId: $collectionId");

  return articlesCollection
      .where('isPublished', isEqualTo: true)
      .where('collectionIds', arrayContains: collectionId)
      .snapshots()
      .handleError((error) {
        print("🔥 Collection article stream ERROR for $collectionId");
        print(error);
      })
      .map((snapshot) {

        print("📡 Collection snapshot received");
        print("📊 Docs returned: ${snapshot.docs.length}");

        try {

          final result = _safeMapArticleList(snapshot);

          print("✅ Collection articles mapped successfully");
          print("📚 Articles returned: ${result.length}");

          return result;

        } catch (e, stack) {

          print("🔥 Collection article mapping ERROR");
          print(e);
          print(stack);

          return [];

        }
      });
}

  // =========================================================
  // COLLECTIONS FOR HOME
  // =========================================================

  Stream<List<CollectionModel>> streamCollectionsforHome() {
    return collectionsCollection
        .where('isPublished', isEqualTo: true)
        .where('isHome', isEqualTo: true)
        .orderBy('HomeOrder')
        .snapshots()
        .handleError((error) {
          print('Error fetching collections: $error');
        })
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => CollectionModel.fromFirestore(doc))
            .toList();
      } catch (e) {
        print('Collection mapping error: $e');
        return [];
      }
    });
  }

  // =========================================================
  // COLLECTION ARTICLES (SAFE VERSION)
  // =========================================================

  Stream<List<CollectionArticleViewModel>> streamCollectionOfArticles(
      String collectionId) {
    return _db
        .collection('collection_articles')
        .where('collectionId', isEqualTo: collectionId)
        .orderBy('order')
        .snapshots()
        .handleError((error) {
          print('Collection articles error: $error');
        })
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          final data = doc.data();

          return CollectionArticleViewModel(
            itemId: doc.id,
            articleId: data['articleId'],
            title: data['title'] ?? 'Untitled',
            summary: data['summary'] ?? '',
            order: data['order'] ?? 0,
            featuredImage: data['featuredImage'],
          );
        }).toList();
      } catch (e) {
        print('Collection article mapping error: $e');
        return [];
      }
    });
  }

  // =========================================================
  // ALL COLLECTIONS
  // =========================================================

  Stream<List<CollectionModel>> streamCollections() {
    return collectionsCollection
        .orderBy('order')
        .snapshots()
        .handleError((error) {
          print('Error fetching collections: $error');
        })
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => CollectionModel.fromFirestore(doc))
            .toList();
      } catch (e) {
        print('Collections mapping error: $e');
        return [];
      }
    });
  }

  // =========================================================
  // SINGLE COLLECTION
  // =========================================================

  Stream<Map<String, dynamic>?> streamCollectionById(String collectionId) {
    return collectionsCollection.doc(collectionId).snapshots().map((doc) {
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;

      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description': data['description'] ?? '',
        'coverImage': data['coverImage'],
        'order': data['order'] ?? 0,
      };
    });
  }

  // =========================================================
  // SINGLE ARTICLE
  // =========================================================

 static Stream<Singlearticlemodel?> streamArticleById(String articleId) {

  print("📡 streamArticleById START");
  print("📄 ArticleId: $articleId");

  return FirebaseFirestore.instance
      .collection('Articles')
      .doc(articleId)
      .snapshots()
      .handleError((error) {
        print("🔥 Single article stream error: $error");
      })
      .map((doc) {

        print("📡 Article snapshot received");

        if (!doc.exists || doc.data() == null) {
          print("❌ Article document does not exist");
          return null;
        }

        try {

          final data = doc.data()!;

          if (data['isPublished'] != true) {
            print("⚠️ Article not published");
            return null;
          }

          final model = Singlearticlemodel(
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
                (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
            lastUpdatedAt:
                (data['last_updated_at'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
            source: data['source'] != null
                ? Map<String, dynamic>.from(data['source'])
                : null,
          );

          print("✅ Article parsed successfully: ${model.title}");

          return model;

        } catch (e, stack) {

          print("🔥 Article mapping error");
          print(e);
          print(stack);

          return null;
        }
      });
}

  // =========================================================
  // DEVOTIONS
  // =========================================================

  Stream<List<DevotionModel>> streamDevotions(int limit) {
    return devotionsCollection
        .where('isPublished', isEqualTo: true)
        .orderBy('episodeData', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((error) {
          print('Devotion stream error: $error');
        })
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => DevotionModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();
      } catch (e) {
        print('Devotion mapping error: $e');
        return [];
      }
    });
  }

  // =========================================================
  // PAGINATED ARTICLES
  // =========================================================

  Stream<List<ArticleModel>> streamPublishedArticles({
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) {
    Query query = _db
        .collection('Articles')
        .where('isPublished', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().handleError((error) {
      print('Published articles error: $error');
    }).map(_safeMapArticleList);
  }

  // =========================================================
  // SEARCH
  // =========================================================

  Future<List<ArticleModel>> searchArticles(String query) async {
    final q = query.toLowerCase();

    final snapshot = await _db
        .collection('Articles')
        .where('isPublished', isEqualTo: true)
        .get();

    final articles = _safeMapArticleList(snapshot);

    return articles.where((article) {
      final title = article.title.toLowerCase();
      final excerpt = article.excerpt.toLowerCase();

      return title.contains(q) || excerpt.contains(q);
    }).toList();
  }

  // =========================================================
  // ARTICLE QUESTIONS
  // =========================================================

  Stream<List<ArticleQuestionModel>> streamArticleQuestions(String articleId) {
    return _db
        .collection('Articles')
        .doc(articleId)
        .collection('questions')
        .where('answered', isEqualTo: true)
        .snapshots()
        .handleError((error) {
          print('Article questions error: $error');
        })
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => ArticleQuestionModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();
      } catch (e) {
        print('Question mapping error: $e');
        return [];
      }
    });
  }

  // =========================================================
// TODAY'S DEVOTION
// =========================================================

Stream<DevotionModel?> streamTodayDevotion() {
  return devotionsCollection
      //.where('episodeIsToday', isEqualTo: true)
      .where('isPublished', isEqualTo: true)
      .orderBy('episodeData'  , descending: true)
      .limit(1)
      .snapshots()
      .handleError((error) {
        print('Today devotion stream error: $error');
      })
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;

        try {
          return DevotionModel.fromFirestore(
            snapshot.docs.first
                as DocumentSnapshot<Map<String, dynamic>>,
          );
        } catch (e) {
          print('Today devotion mapping error: $e');
          return null;
        }
      });
}

  // =========================================================
  // SAFE ARTICLE LIST MAPPER
  // =========================================================

  List<ArticleModel> _safeMapArticleList(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return ArticleModel(
          id: doc.id,
          authorId: data['author_id'] ?? '',
          categoryIds: List<String>.from(data['category_ids'] ?? []),
          createdAt:
              (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
          lastUpdatedAt:
              (data['last_updated_at'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          createdBy: data['created_by'] ?? '',
          excerpt: data['excerpt'] ?? '',
          featuredImage: data['featured_image'],
          isPublished: data['isPublished'] ?? false,
          title: data['title'] ?? '',
          source: data['source'] != null
              ? Map<String, dynamic>.from(data['source'])
              : null,
        );
      }).toList();
    } catch (e) {
      print('Article mapping error: $e');
      return [];
    }
  }
}