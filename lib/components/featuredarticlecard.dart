import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/models/articlepreviewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedArticleCard extends StatelessWidget {
  final ArticlePreviewModel article;

  const FeaturedArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, // 👈 keep card width
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            final slug = article.slug?.trim();

            final value = (slug != null && slug.isNotEmpty)
                ? slug
                : article.id;

            context.pushNamed(
              'article',
              pathParameters: {'value': value},
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 240, // 🔥 FIX: control height instead of ratio
              child: Stack(
                fit: StackFit.expand,
                children: [

                  /// ✅ IMAGE
                  CachedNetworkImage(
                    imageUrl: article.featuredImage ?? '',
                    fit: BoxFit.cover, // 🔥 IMPORTANT (no stretch)
                    memCacheWidth: 600,
                    memCacheHeight: 500,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.image)),
                  ),

                  /// ✅ GRADIENT
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  /// ✅ TITLE
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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