import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/services/audio_analytics_service.dart';

class RecentDevotionCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String audioUrl;
  final String? imageUrl;

  const RecentDevotionCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.audioUrl,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsedDate = DateTime.parse(date);

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
            child: SizedBox(
              width: 60,
              height: 60,
              child: (imageUrl?.isNotEmpty ?? false)
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/theologia-logo.png',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/theologia-logo.png',
                      fit: BoxFit.cover,
                    ),
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
                  formatDevotionDate(parsedDate).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                /// SUBTITLE
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// PLAY / LOCK BUTTON
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {

              final user = snapshot.data;
              final isAnonymous = user == null || user.isAnonymous;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),

                  onTap: () {

                    if (isAnonymous) {
                      context.push('/login');
                      return;
                    }

                    /// Show mini player
                    miniPlayerDismissed.value = false;

                    /// Analytics
                    AudioAnalyticsService.incrementAudioOpened(id);

                    /// Play audio
                    audioHandler.playMedia(
                      id: id,
                      title: title,
                      url: audioUrl,
                      imageUrl: imageUrl,
                    );
                  },

                  child: Ink(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAnonymous
                          ? Colors.grey.withOpacity(0.25)
                          : const Color(0xFFb79260).withOpacity(0.25),
                    ),

                    child: Icon(
                      isAnonymous ? Icons.lock : Icons.play_arrow,
                      color: isAnonymous
                          ? Colors.grey
                          : const Color(0xFFb79260),
                      size: 26,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String formatDevotionDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays == 0) {
    return "Today";
  }

  if (difference.inDays == 1) {
    return "Yesterday";
  }

  if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  }

  if (difference.inDays < 14) {
    return "Last week";
  }

  return DateFormat("d MMM, yyyy").format(date);
}