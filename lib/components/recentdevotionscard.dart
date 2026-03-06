import 'package:flutter/material.dart';

class RecentDevotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String imageUrl;
  final VoidCallback onPlay;

  const RecentDevotionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.imageUrl,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Row(
        children: [

          /// THUMBNAIL
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// DATE
                Text(
                  date.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFE2B24B),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 4),

                /// TITLE
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                /// SUBTITLE
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// PLAY BUTTON
          GestureDetector(
            onTap: onPlay,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFb79260).withOpacity(0.25),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFFb79260),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}