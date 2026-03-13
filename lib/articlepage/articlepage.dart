import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/article_repository.dart';
import 'package:theologia_app_1/articlepage/articleview.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;

  const ArticlePage({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Future<Singlearticlemodel?> _articleFuture;

  @override
  void initState() {
    super.initState();

    debugPrint("📄 ArticlePage initState()");
    debugPrint("📄 Article ID: ${widget.articleId}");

    incrementArticleOpened();   // analytics
    _loadArticle();
  }

  void _loadArticle() {
    debugPrint("🚀 Starting article fetch for ID: ${widget.articleId}");

    _articleFuture = ArticleRepository(
      FirebaseFirestore.instance,
    ).fetchArticle(widget.articleId).then((article) {

      if (article == null) {
        debugPrint("❌ Article fetch returned NULL");
      } else {
        debugPrint("✅ Article fetched successfully");
        debugPrint("📄 Title: ${article.title}");
      }

      return article;
    }).catchError((error) {

      debugPrint("🔥 ERROR fetching article: $error");

      return null;
    });
  }

  Future<void> incrementArticleOpened() async {
    try {

      debugPrint("📊 Incrementing openedCount for article: ${widget.articleId}");

      await FirebaseFirestore.instance
          .collection('Articles')
          .doc(widget.articleId)
          .update({
        'analytics.openedCount': FieldValue.increment(1),
      });

      debugPrint("✅ openedCount increment success");

    } catch (e) {

      debugPrint("🔥 Analytics error: $e");

    }
  }

  @override
  void dispose() {
    debugPrint("🧹 ArticlePage disposed for ID: ${widget.articleId}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("🔄 ArticlePage build() called");

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Singlearticlemodel?>(
        future: _articleFuture,
        builder: (context, snapshot) {

          debugPrint("📡 FutureBuilder state: ${snapshot.connectionState}");

          if (snapshot.connectionState == ConnectionState.waiting) {

            debugPrint("⏳ Waiting for article...");

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {

            debugPrint("🔥 FutureBuilder error: ${snapshot.error}");

            return const Scaffold(
              body: Center(child: Text('Error loading article')),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {

            debugPrint("❌ Article data is null");

            return const Scaffold(
              body: Center(child: Text('Article not found')),
            );
          }

          debugPrint("📖 Rendering ArticleView for: ${snapshot.data!.title}");

          return ArticleView(
            article: snapshot.data!,
            heroTag: "article-${widget.articleId}",
          );
        },
      ),
    );
  }
}