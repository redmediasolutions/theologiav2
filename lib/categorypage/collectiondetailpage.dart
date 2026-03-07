import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/components/categorytopiccard.dart';
import 'package:theologia_app_1/components/collectionherocard.dart';
import 'package:theologia_app_1/components/teritiaryappbar.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/services/firestore.dart';

class CollectionDetailPage extends StatelessWidget {
  final String collectionId;
  final String collectionTitle;

  const CollectionDetailPage({
    super.key,
    required this.collectionId,
    required this.collectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TertiaryAppbar(majortopic: "Collection"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              /// Hero
              CollectionHeroCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
                seriesLabel: "Theology Series",
                title: collectionTitle,
                description:
                    "Explore the depths of theology with this curated collection of articles.",
              ),
        
              const SizedBox(height: 30),
              Text('Articles',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              )
              ),
              const SizedBox(height: 15),
              /// Articles
              StreamBuilder<List<CollectionArticleViewModel>>(
                stream: FirestoreService().streamCollectionOfArticles(
                  collectionId,
                ),
                builder: (context, snapshot) {
                      
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                      
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No articles yet"));
                  }
                      
                  final articles = snapshot.data!;
                      
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      
                      final article = articles[index];
                      
                      return CategoryTopicCard(
                        title: article.title,
                        summary: article.summary,
                        readtime: '3 Minutes',
                        date: '10/10/2023',
                        category: 'Theology',
                        imageUrl:
                            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
                        views: '1.2K', 
                        articleId: article.articleId,
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class ExploreAndIcon extends StatelessWidget {
  final String description;

  const ExploreAndIcon({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF96784B),
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: const TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

