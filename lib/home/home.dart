import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/components/collectionbutton.dart';
import 'package:theologia_app_1/components/globalscaffold.dart';
import 'package:theologia_app_1/components/questionscontainer.dart';
import 'package:theologia_app_1/components/updatechecker.dart';
import 'package:theologia_app_1/home/DailyAudioCard.dart';
import 'package:theologia_app_1/home/featuredarticles.dart';
import 'package:theologia_app_1/home/recentdevotions.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/models/collection_model.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/widgets/audio_player_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final devotionService = FirestoreService();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return UpdateChecker(
      child: Globalscaffold(
        title: 'Theologia',
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              children: [
                // LISTEN TO DEVOTIONS
                DailyAudioCard(devotionService: devotionService),
                SizedBox(height: 40),
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      'Featured Articles',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right_outlined),
                  ],
                ),
                SizedBox(height: 20),
                const FeaturedArticlesHorizontal(),
                SizedBox(height: 40),
      
                Row(
                  children: [
                    Icon(Icons.grid_3x3_rounded, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      'Collections',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right_outlined),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: StreamBuilder<List<CollectionModel>>(
                    stream: FirestoreService().streamCollectionsforHome(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
      
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }
      
                      final collections = snapshot.data!;
      
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        //padding: const EdgeInsets.symmetric(horizontal: ),
                        itemCount: collections.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 20),
                        itemBuilder: (context, index) {
                          final collection = collections[index];
      
                          return CategoriesButton(
                            topic: collection.title, 
                            id: collection.id, 
                            iconPath: collection.collectionicon,);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.question_mark, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      'Questions',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right_outlined),
                  ],
                ),
                SizedBox(height: 15),
                SizedBox(
                  //height: 140, // adjust to your card height
                  child: StreamBuilder<List<CollectionArticleViewModel>>(
                    stream: FirestoreService().streamCollectionOfArticles(
                      "OhLhrTuFCB66wYaXy9Wl",
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
      
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('no articles');
                      }
      
                      final articles = snapshot.data!;
      
                      return Column(
                        children: List.generate(articles.length, (index) {
                          final article = articles[index];
      
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  'article',
                                  pathParameters: {'id': article.articleId},
                                );
                              },
                              child: QuestionsContainer(
                                title: article.title,
                                description: article.summary,
                                category: 'Theologia',
                                readTime: '5 minutes read',
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Icon(Icons.headphones_outlined, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      'Recent Devotions',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right_outlined),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: StreamBuilder<List<DevotionModel>>(
                    stream: FirestoreService().streamDevotions(5),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
      
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
      
                      final devotions = snapshot.data ?? [];
      
                      if (devotions.isEmpty) {
                        return const Text("No devotions available");
                      }
      
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: devotions.length,
                        itemBuilder: (context, index) {
                          final devotion = devotions[index];
      
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width:
                                  240, // 🔥 IMPORTANT: give horizontal item a width
                              child: RecentDevotions(
                                id: devotion.id,
                                title: devotion.episodeName ?? 'Untitled',
                                description: '',
                                episodeno: devotion.episodeNo.toString(),
                                date: formatDate(devotion.episodeDate),
                                audioUrl: devotion.episodeUrl ?? '',
                                coverUrl: devotion.episodeCoverUrl ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



