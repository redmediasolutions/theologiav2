import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/models/articlepreviewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedArticleCard extends StatelessWidget {
  final ArticlePreviewModel article;

  const FeaturedArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final heroTag = "article-${article.id}";

    return SizedBox(
      height: 360, // 🔽 reduced
      width: 340, // 🔽 reduced
      child: Hero(
        tag: heroTag,
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
    extra: heroTag,
  );
},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 340,
                child: AspectRatio(
                  aspectRatio:
                      3 / 4, // 🔥 keeps proportions like your screenshot
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// ✅ IMAGE (no stretch, proper fill)
                      CachedNetworkImage(
                        height: 360,
                        width: double.infinity,
                        imageUrl: article.featuredImage ?? '',
                        fit: BoxFit.fill,

                        memCacheWidth: 600,
                        memCacheHeight: 800,

                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),

                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 50),
                      ),

                      /// ✅ GRADIENT OVERLAY
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

                      /// ✅ TEXT (BOTTOM)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
        ),
      ),
    );
  }
}
