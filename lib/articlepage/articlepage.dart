import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/article_repository.dart';
import 'package:theologia_app_1/articlepage/articleview.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';
// ANALYTICS
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;


  const ArticlePage({super.key, 
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
      incrementArticleOpened();   // analytics
    _loadArticle();
  }

  void _loadArticle() {
    _articleFuture = ArticleRepository(
      FirebaseFirestore.instance,
    ).fetchArticle(widget.articleId);
  }

  Future<void> incrementArticleOpened() async {
  try {
    await FirebaseFirestore.instance
        .collection('Articles')
        .doc(widget.articleId)
        .update({
      'analytics.openedCount': FieldValue.increment(1),
    });
  } catch (e) {
    debugPrint("Analytics error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Singlearticlemodel?>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Scaffold(
              body: Center(child: Text('Article not found')),
            );
          }

          return ArticleView(
            article: snapshot.data!,
            heroTag: "article-${widget.articleId}",

);
        },
      ),
    );
  }
}