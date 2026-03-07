import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theologia_app_1/components/categorytopiccard.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/services/firestore.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  final FirestoreService firestoreService = FirestoreService();

  final List<ArticleModel> articles = [];
  final ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;

  bool isLoading = false;
  bool hasMore = true;

  final int pageSize = 10;

  @override
  void initState() {
    super.initState();

    _fetchArticles();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        _fetchArticles();
      }
    });
  }

  Future<void> _fetchArticles() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    Query query = FirebaseFirestore.instance
        .collection('Articles')
        .where('isPublished', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;

      final newArticles = snapshot.docs.map((doc) {
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

      articles.addAll(newArticles);

      if (snapshot.docs.length < pageSize) {
        hasMore = false;
      }
    } else {
      hasMore = false;
    }

    setState(() => isLoading = false);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("For You"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: articles.length + 1,
        itemBuilder: (context, index) {
          if (index < articles.length) {
            final article = articles[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CategoryTopicCard(
                title: article.title,
                summary: article.excerpt,
                readtime: "5 min read",
                date: _formatDate(article.createdAt),
                category: "Article",
                imageUrl: article.featuredImage ?? "",
                views: "0", 
                articleId: article.id,
              ),
            );
          }

          /// Loader at bottom
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}