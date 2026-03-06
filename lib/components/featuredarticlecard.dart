import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/models/collectionarticleview.dart';

class FeaturedArticleCard extends StatelessWidget {
  final CollectionArticleViewModel article;

  const FeaturedArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = "article-${article.articleId}";

    return SizedBox(
      height: 400,
      width: 300,
      child: Hero(
        tag: heroTag,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.08),
            onTap: () {
              context.pushNamed(
                'article',
                pathParameters: {'id': article.articleId},
                extra: heroTag, // pass hero tag
              );
            },
            child: Ink.image(
              image: NetworkImage(
                article.featuredImage ??
                    'https://images.unsplash.com/photo-1533000971552-6a962ff0b9f9',
              ),
              fit: BoxFit.cover,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}