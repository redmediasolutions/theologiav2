import 'package:flutter/material.dart';
import 'package:theologia_app_1/home/featuredarticles.dart';

class HomeSectionBlock extends StatelessWidget {
  final String title;
  final String description;
  final String collectionId;

  const HomeSectionBlock({
    required this.title,
    required this.description,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: Colors.brown),
                  const SizedBox(width: 10),
                  Text(
                    title,
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
              if (description.isNotEmpty)
                Text(
                  description,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          ),
        ),

        /// 🔹 ARTICLES LIST (reuse your widget)
        FeaturedArticlesHorizontal(
          collectionId: collectionId, // 👈 dynamic now
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
