import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/services/audio_analytics_service.dart';
import 'package:share_plus/share_plus.dart';

class TodaysDevotionContainer extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String audioUrl;
  final String? imageUrl;

  const TodaysDevotionContainer({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    this.imageUrl,
  });

  Future<void> _shareDevotion(BuildContext context) async {
  final url = "https://theologia.in/devotion/$id";

  final text = "$title\n\nListen on Theologia:\n$url";

  await Share.share(text);
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [

          /// BACKGROUND IMAGE
          SizedBox(
            height: 220,
            width: double.infinity,
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/theologia-logo.png',
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

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

          /// DARK OVERLAY
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.25),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

/// 🔗 SHARE BUTTON (TOP RIGHT)
Positioned(
  top: 12,
  right: 12,
  child: IconButton(
    icon: const Icon(Icons.share, color: Colors.white),
    onPressed: () => _shareDevotion(context),
    style: IconButton.styleFrom(
      backgroundColor: Colors.black.withOpacity(0.4),
    ),
  ),
),
          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb79260).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "TODAY'S DEVOTION",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const Spacer(),

                /// TITLE + PLAY BUTTON
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    /// TEXT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// PLAY / LOCK BUTTON
                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {

                        final user = snapshot.data;
                        final isAnonymous = user == null || user.isAnonymous;

                        return GestureDetector(
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

                          child: Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isAnonymous
                                  ? Colors.grey
                                  : const Color(0xFFb79260),
                            ),
                            child: Icon(
                              isAnonymous
                                  ? Icons.lock
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}