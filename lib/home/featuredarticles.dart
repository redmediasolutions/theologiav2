import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/components/featuredarticlecard.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/services/firestore.dart';

class FeaturedArticlesHorizontal extends StatelessWidget {
  const FeaturedArticlesHorizontal({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: StreamBuilder<List<CollectionArticleViewModel>>(
        stream: FirestoreService().streamCollectionOfArticles(
          "zdqLM4v4r9vlosO1alF5",
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          final articles = snapshot.data!;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: articles.length,
            separatorBuilder: (_, _) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final article = articles[index];

              return GestureDetector(
                onTap: () {
                  
                },
                child: FeaturedArticleCard(article: article),
              );
            },
          );
        },
      ),
    );
  }
}
