import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theologia_app_1/main.dart';

class DevotionHeader extends StatelessWidget {
  final String? imageUrl;
  final String duration;
  final String audioUrl;
  final String title;
  final String id;
  final String? slug; // ✅ NEW

  const DevotionHeader({
    super.key,
    this.imageUrl,
    required this.duration,
    required this.audioUrl,
    required this.title,
    required this.id,
    this.slug,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          /// IMAGE
          SizedBox(
            height: 360,
            width: double.infinity,
            child: Image.network(
              imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),

          /// GRADIENT
          Container(
            height: 360,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          /// 🔙 BACK BUTTON
          Positioned(
            top: topPadding + 8,
            left: 12,
            child: Material(
              color: Colors.black.withOpacity(0.4),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
               onPressed: () {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    context.go('/'); // 🔥 GoRouter-safe fallback
  }
},
              ),
            ),
          ),

          /// 🔗 SHARE BUTTON
          Positioned(
            top: topPadding + 8,
            right: 12,
            child: Material(
              color: Colors.black.withOpacity(0.4),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () async {
                  final value = (slug != null && slug!.isNotEmpty) ? slug! : id;

                  final url = "https://theologia.in/devotion/$value";

                  final text = "$title\n\nListen on Theologia:\n$url";

                  await Share.share(text);
                },
              ),
            ),
          ),

          /// CONTENT
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// PLAY BUTTON
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      miniPlayerDismissed.value = false;

                      audioHandler.playMedia(
                        id: id,
                        title: title,
                        url: audioUrl,
                        imageUrl: imageUrl,
                      );
                    },
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Listen Now • $duration",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
