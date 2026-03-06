import 'package:flutter/material.dart';
import 'package:theologia_app_1/main.dart';

class RecentDevotions extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String date;
  final String audioUrl;
  final String coverUrl;
  final String episodeno;

  const RecentDevotions({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.audioUrl,
    required this.coverUrl,
    required this.episodeno,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          audioHandler.playMedia(
            id: id,
            title: title,
            url: audioUrl,
            imageUrl: coverUrl,
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outline, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOP IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  coverUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.unsplash.com/photo-1772289935663-80aa987be656?q=80&w=2340&auto=format&fit=crop',
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    );
                  },
                ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// CATEGORY
                    Text(
                      "MORNING REFLECTION",
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// TITLE
                    Text(
                      title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    /// BOTTOM ROW
                    Row(
                      children: [

                        /// READ TIME
                        Text(
                          "4 min read",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: colors.onSurface.withOpacity(0.7),
                          ),
                        ),

                        const Spacer(),

                        /// BOOKMARK
                        Icon(
                          Icons.bookmark_border,
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}