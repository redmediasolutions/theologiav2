import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theologia_app_1/apptheme.dart';
import 'package:theologia_app_1/auth/login.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/services/audio_analytics_service.dart';
import 'package:theologia_app_1/services/audiohandler.dart';
import 'package:theologia_app_1/services/firestore.dart';

class DailyAudioCard extends StatelessWidget {
  final FirestoreService devotionService;

  const DailyAudioCard({super.key, required this.devotionService});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return StreamBuilder<List<DevotionModel>>(
      stream: devotionService.streamDevotions(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final devotion = snapshot.data!.first;

        return Padding(
          padding: const EdgeInsets.all(0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppTheme.bgDark, colorScheme.surface]
                          : [AppTheme.bgLight, Color(0xFFf5f2e8)],
                    ),
                    border: Border.all(color: colorScheme.outline, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: isWide
                        ? Row(
                            children: [
                              _buildImage(devotion.episodeCoverUrl),
                              Expanded(child: _buildContent(context, devotion)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildImage(devotion.episodeCoverUrl),
                              _buildContent(context, devotion),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImage(String? imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        (imageUrl != null && imageUrl.isNotEmpty)
            ? imageUrl
            : "https://via.placeholder.com/800x450",
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Image.asset(
            "assets/images/theologia-default-cover.png",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DevotionModel devotion) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "DAILY AUDIO",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            devotion.episodeName ?? "Untitled Devotion",
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.textTheme.headlineMedium?.color?.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            devotion.episodeDesc ?? "",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Row(
  children: [
    StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    final user = snapshot.data;
    final isAnonymous = user == null || user.isAnonymous;

    return 
    
    Row(
  children: [
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isAnonymous = user == null || user.isAnonymous;

        final value =
            (devotion.slug != null && devotion.slug!.isNotEmpty)
                ? devotion.slug!
                : devotion.id;

        return Row(
          children: [
            /// ▶️ PLAY BUTTON
            ElevatedButton.icon(
              onPressed: () {
                if (isAnonymous) {
                  context.push('/login');
                  return;
                }

                miniPlayerDismissed.value = false;

                AudioAnalyticsService.incrementAudioOpened(
                  devotion.id,
                );

                audioHandler.playMedia(
                  id: devotion.id,
                  title: devotion.episodeName ?? "",
                  url: devotion.episodeUrl ?? "",
                  imageUrl: devotion.episodeCoverUrl ?? "",
                );

                context.pushNamed(
                  'devotion',
                  pathParameters: {'value': value},
                );
              },
              icon: Icon(
                  isAnonymous ? Icons.lock : Icons.play_arrow),
              label: Text(
                  isAnonymous ? "Login to Play" : "Play Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnonymous
                    ? Colors.grey.shade600
                    : colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
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
                final url =
                    "https://theologia.in/devotion/$value";

                final text =
                    "${devotion.episodeName}\n\nListen on Theologia:\n$url";

                await Share.share(text);
              },
              icon: const Icon(Icons.share_outlined),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surface,
                padding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(width: 16),

            /// ⏱️ DURATION
            Text(
              devotion.episodeduration ?? "",
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color
                    ?.withOpacity(0.6),
              ),
            ),
          ],
        );
      },
    ),
  ],
);
  },
),
  ],
)
        ],
      ),
    );
  }
}
