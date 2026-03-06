import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlerenderer.dart';
import 'package:theologia_app_1/articlepage/articlesilverappbar.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';

class ArticleView extends StatelessWidget {
  final Singlearticlemodel article;
  final String heroTag;


  const ArticleView({super.key, 
  required this.article,
  required this.heroTag
  });

  @override
  Widget build(BuildContext context) {
    int orderedCounter = 0;
    final blocks = article.normalizedBlocks ?? [];

    return CustomScrollView(
      slivers: [
        const ArticleSliverAppBar(),

        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              /// 🔥 Entire article selectable
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    /// Excerpt
                    if (article.excerpt.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        article.excerpt,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    /// Featured Image
                    if (article.featuredImage != null)
  Hero(
    tag: heroTag,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        article.featuredImage!,
        fit: BoxFit.cover,
      ),
    ),
  ),

                    const SizedBox(height: 25),


...blocks.map<Widget>((block) {
  final map = Map<String, dynamic>.from(block);

  if (map['type'] == 'list_item' && map['ordered'] == true) {
    final widget = ArticleBlockRenderer(
      block: map,
      listIndex: orderedCounter,
    );
    orderedCounter++;
    return widget;
  } else {
    // Reset counter when list ends
    orderedCounter = 0;

    return ArticleBlockRenderer(
      block: map,
    );
  }
}),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}