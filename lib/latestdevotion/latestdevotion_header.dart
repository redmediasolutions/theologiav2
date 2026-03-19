import 'dart:ui';

import 'package:flutter/material.dart';

class DevotionHeader extends StatelessWidget {
  final String? imageUrl;
  final String duration;
  final String audioUrl;
  final String title;
  final String id;

  const DevotionHeader({
    super.key,
    this.imageUrl,
    required this.duration,
    required this.audioUrl,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// IMAGE
        SizedBox(
          height: 320,
          width: double.infinity,
          child: Image.network(imageUrl ?? '', fit: BoxFit.cover),
        ),

        /// DARK OVERLAY
        Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        /// PLAY BUTTON + TEXT
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// PLAY BUTTON
              ClipOval(
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

              const SizedBox(height: 16),

              Text(
                "Listen Now • $duration",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
