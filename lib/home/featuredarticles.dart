import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/components/featuredarticlecard.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/models/articlepreviewmodel.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/services/firestore.dart';

class FeaturedArticlesHorizontal extends StatefulWidget {
  final String collectionId;

  const FeaturedArticlesHorizontal({
    super.key,
    required this.collectionId,
  });

  @override
  State<FeaturedArticlesHorizontal> createState() =>
      _FeaturedArticlesHorizontalState();
}

class _FeaturedArticlesHorizontalState
    extends State<FeaturedArticlesHorizontal> {

  final FirestoreService _service = FirestoreService();
  late Future<List<ArticlePreviewModel>> _future;

  @override
void initState() {
  super.initState();
  _future = _service.newstreamArticlesForCollection(
    widget.collectionId, // 🔥 dynamic
  );
}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FutureBuilder<List<ArticlePreviewModel>>(
        future: _future,
        builder: (context, snapshot) {

          /// 🔄 LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ ERROR
          if (snapshot.hasError) {
            debugPrint("🔥 FutureBuilder error: ${snapshot.error}");
            return const Center(child: Text("Error loading articles"));
          }

          /// ❌ NO DATA
          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          /// ⚠️ EMPTY
          if (snapshot.data!.isEmpty) {
            debugPrint("⚠️ Articles list is empty");
            return const Center(child: Text("No articles found"));
          }

          final articles = snapshot.data!;

          /// ✅ SUCCESS
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            separatorBuilder: (_, _) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final article = articles[index];

              return FeaturedArticleCard(
                article: article, // ✅ ensure this accepts preview model
              );
            },
          );
        },
      ),
    );
  }
}
