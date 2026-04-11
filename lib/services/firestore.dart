import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:theologia_app_1/models/article_question_model.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/models/articlepreviewmodel.dart';
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
            featuredImage: data['featured_image'],
          );
        }).toList();
      } catch (e) {
        print('Collection article mapping error: $e');
        return [];
      }
    });
  }

  // Collection article -- similar to top but more efficient

  Stream<List<ArticleModel>> streamArticlesForCollection(String collectionId) {
  return _db
      .collection('collection_articles')
      .where('collectionId', isEqualTo: collectionId)
      .orderBy('order')
      .snapshots()
      .asyncMap((snapshot) async {
    try {
      final docs = snapshot.docs;

      if (docs.isEmpty) return [];

      // 👉 Step 1: Extract IDs in order
      final articleIds = docs
          .map((doc) => doc['articleId'] as String)
          .toList();

      // 👉 Step 2: Fetch Articles
      final articlesSnap = await _db
    .collection('Articles')
    .where(FieldPath.documentId, whereIn: articleIds)
    .get();

final articlesMap = {
  for (var doc in articlesSnap.docs) doc.id: doc
};

return articleIds.map((id) {
  final doc = articlesMap[id];
  if (doc == null) return null;

  return ArticleModel.fromFirestore(doc);
}).whereType<ArticleModel>().toList();
    } catch (e) {
      print('Error fetching collection articles: $e');
      return [];
    }
  });
}


// NEW ARTICLES STREAM

 Future<List<ArticlePreviewModel>> fetchArticlesForCollection(
    String collectionId) async {
  try {
    debugPrint("🚀 Fetching articles for collection: $collectionId");

    // 👉 Step 1: Get collection_articles
    final snapshot = await _db
        .collection('collection_articles')
        .where('collectionId', isEqualTo: collectionId)
        .orderBy('order')
        .get();

    debugPrint("📦 collection_articles fetched: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty) {
      debugPrint("⚠️ No documents found in collection_articles");
      return [];
    }

    // 👉 Log documents
    for (var doc in snapshot.docs) {
      debugPrint("📄 Doc ID: ${doc.id} | Data: ${doc.data()}");
    }

    // 👉 Step 2: Extract article IDs
    final articleIds = snapshot.docs.map((doc) {
      final id = doc['articleId'] as String?;
      debugPrint("🔑 Extracted articleId: $id");
      return id;
    }).whereType<String>().toList();

    debugPrint("🧾 Total article IDs: ${articleIds.length}");
    debugPrint("🧾 Article IDs: $articleIds");

    if (articleIds.isEmpty) {
      debugPrint("❌ No valid article IDs found");
      return [];
    }

    // 👉 Step 3: Fetch articles (chunked)
    debugPrint("🚀 Starting chunk fetch...");
    final articleDocs = await _fetchArticlesInChunks(articleIds);

    debugPrint("📚 Articles fetched: ${articleDocs.length}");

    // 👉 Step 4: Map by ID
    final articlesMap = {
      for (var doc in articleDocs) doc.id: doc
    };

    debugPrint("🗂️ Articles map keys: ${articlesMap.keys}");

    // 👉 Step 5: Convert to PREVIEW model safely
    final orderedArticles = articleIds.map((id) {
      final doc = articlesMap[id];

      if (doc == null) {
        debugPrint("⚠️ Missing article for ID: $id");
        return null;
      }

      try {
        final data = doc.data() as Map<String, dynamic>?;

        final article = ArticlePreviewModel(
          id: doc.id,
          title: data?['title'] ?? 'Untitled',
          featuredImage: data?['featured_image'],
        );

        debugPrint("✅ Preview parsed: ${article.title}");
        return article;
      } catch (e) {
        debugPrint("🔥 Error parsing preview $id: $e");
        return null;
      }
    }).whereType<ArticlePreviewModel>().toList();

    debugPrint("🎯 Final preview articles count: ${orderedArticles.length}");

    return orderedArticles;
  } catch (e, stack) {
    debugPrint("🔥 ERROR fetching collection articles: $e");
    debugPrintStack(stackTrace: stack);
    rethrow;
  }
}
  /// 🔥 INTERNAL: handles Firestore whereIn limit (10)
  Future<List<QueryDocumentSnapshot>> _fetchArticlesInChunks(
    List<String> ids) async {
  List<QueryDocumentSnapshot> allDocs = [];

  debugPrint("🔄 Fetching articles in chunks...");
  debugPrint("📊 Total IDs: ${ids.length}");

  for (int i = 0; i < ids.length; i += 10) {
    final chunk = ids.sublist(
      i,
      i + 10 > ids.length ? ids.length : i + 10,
    );

    debugPrint("📦 Fetching chunk: $chunk");

    try {
      final snap = await _db
          .collection('Articles')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      debugPrint("📥 Chunk result count: ${snap.docs.length}");

      for (var doc in snap.docs) {
        debugPrint("📘 Found article: ${doc.id}");
      }

      allDocs.addAll(snap.docs);
    } catch (e) {
      debugPrint("🔥 Chunk fetch error: $e");
    }
  }

  debugPrint("📊 Total fetched articles: ${allDocs.length}");

  return allDocs;
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

  Stream<Singlearticlemodel?> getArticle(String articleId) {
    return _db
        .collection('Articles')
        .doc(articleId)
        .snapshots()
        .map((doc) {
          if (!doc.exists || doc.data() == null) return null;

          return Singlearticlemodel.fromFirestore(doc);
        });
  }
// FETCH ARTICLE BY SLUG
  Stream<Singlearticlemodel?> getArticleBySlug(String slug) {
  return FirebaseFirestore.instance
      .collection('Articles')
      .where('slug', isEqualTo: slug)
      .limit(1)
      .snapshots()
      .map((snapshot) {
        try {
          // 🔥 No result
          if (snapshot.docs.isEmpty) {
            debugPrint("❌ No article found for slug: $slug");
            return null;
          }

          final doc = snapshot.docs.first;

          debugPrint("✅ Article found via slug: ${doc.id}");

          return Singlearticlemodel.fromFirestore(doc);
        } catch (e) {
          debugPrint("🔥 Error parsing article (slug): $e");
          return null;
        }
      })
      .handleError((error) {
        debugPrint("🔥 Firestore stream error (slug): $error");
      });
}

/// 🔥 GET BY ID
  Future<DevotionModel?> getDevotionById(String id) async {
    try {
      final doc = await _db.collection('Devotions').doc(id).get();

      if (!doc.exists) {
        print("❌ Devotion not found for ID: $id");
        return null;
      }

      print("✅ Devotion loaded via ID: $id");

      return DevotionModel.fromFirestore(doc);
    } catch (e) {
      print("🔥 Error fetching devotion by ID: $e");
      return null;
    }
  }

  /// 🔥 GET BY SLUG
  Future<DevotionModel?> getDevotionBySlug(String slug) async {
    try {
      print("🔍 Fetching devotion by slug: $slug");

      final snapshot = await _db
          .collection('Devotions')
          .where('slug', isEqualTo: slug)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print("❌ No devotion found for slug: $slug");
        return null;
      }

      final doc = snapshot.docs.first;

      print("✅ Devotion found for slug: ${doc.id}");

      return DevotionModel.fromFirestore(doc);
    } catch (e) {
      print("🔥 Error fetching devotion by slug: $e");
      return null;
    }
  }
}