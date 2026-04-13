import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theologia_app_1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theologia_app_1/services/audio_analytics_service.dart';
import 'package:go_router/go_router.dart';

class RecentDevotions extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String date;
  final String audioUrl;
  final String coverUrl;
  final String episodeno;

  final String slug;

  const RecentDevotions({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.audioUrl,
    required this.coverUrl,
    required this.episodeno,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final user = FirebaseAuth.instance.currentUser;
    final bool isAuthenticated = user != null && !user.isAnonymous;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (!isAuthenticated) {
            context.push('/login');
            return;
          }

          /// 🔥 Resolve slug or fallback to id
          final value = (slug.isNotEmpty) ? slug : id;

          /// 🔥 Show mini player
          miniPlayerDismissed.value = false;

          /// 🔥 Analytics
          //AudioAnalyticsService.incrementAudioOpened(id);

          /// 🔥 Play audio
          audioHandler.playMedia(
            id: id,
            title: title,
            url: audioUrl,
            imageUrl: coverUrl,
          );

          /// 🚀 Navigate to detail page
          context.pushNamed('devotion', pathParameters: {'value': value});
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
              /// IMAGE
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

                    /// PLAY BUTTON ROW
                    Row(
  children: [
    /// ▶️ PLAY BUTTON
    ElevatedButton.icon(
      onPressed: () {
        if (!isAuthenticated) {
          context.push('/login');
          return;
        }

        final value = (slug.isNotEmpty) ? slug : id;

        miniPlayerDismissed.value = false;

        //AudioAnalyticsService.incrementAudioOpened(id);

        audioHandler.playMedia(
          id: id,
          title: title,
          url: audioUrl,
          imageUrl: coverUrl,
        );

        context.pushNamed(
          'devotion',
          pathParameters: {'value': value},
        );
      },
      icon: Icon(
        isAuthenticated ? Icons.play_arrow : Icons.lock,
      ),
      label: Text(
        isAuthenticated ? "Play Now" : "Login to Play",
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAuthenticated
            ? colors.primary
            : Colors.grey.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),

    const SizedBox(width: 12),

    /// 🔗 SHARE BUTTON
    IconButton(
      onPressed: () async {
        final value = (slug.isNotEmpty) ? slug : id;

        final url = "https://theologia.in/devotion/$value";

        final text = "$title\n\nListen on Theologia:\n$url";

        await Share.share(text);
      },
      icon: const Icon(Icons.share_outlined),
      style: IconButton.styleFrom(
        backgroundColor: colors.surface,
        padding: const EdgeInsets.all(12),
      ),
    ),
  ],
)
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
