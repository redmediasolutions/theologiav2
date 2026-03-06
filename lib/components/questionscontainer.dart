
import 'package:flutter/material.dart';

class QuestionsContainer extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String readTime;

  const QuestionsContainer({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEFE7DB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: const Color(0xff8A6B3D),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                readTime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// TITLE
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 18),

          /// READ MORE
          Row(
            children: [
              Text(
                "Read full answer",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff8A6B3D),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward,
                size: 18,
                color: Color(0xff8A6B3D),
              ),
            ],
          ),
        ],
      ),
    );
  }
}