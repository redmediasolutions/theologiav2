import 'package:flutter/material.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_content.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_header.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/widgets/mini_player.dart';
import 'package:share_plus/share_plus.dart';

class LatestDevotion extends StatelessWidget {
  final Map<String, dynamic> data;

  const LatestDevotion({super.key, required this.data});

  Future<void> _shareDevotion() async {
  final slug = data['slug']; // 🔥 if available
  final id = data['id'];

  final value = (slug != null && slug.toString().isNotEmpty)
      ? slug
      : id;

  final url = "https://theologia.in/devotion/$value";

  final text = "${data['title']}\n\nListen on Theologia:\n$url";

  await Share.share(text);
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        actions: [
           IconButton(
      icon: const Icon(Icons.share_outlined),
      onPressed: _shareDevotion,
    ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 MAIN CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 110, // 👈 space for floating player
              ),
              child: Column(
                children: [
                  DevotionHeader(
                    imageUrl: data['imageUrl'],
                    duration: data['duration'] ?? "12:45",
                    audioUrl: data['audioUrl'],
                    title: data['title'],
                    id: data['id'], 
                  ),

                  /// Add slight separation in dark mode
                  Container(
                    decoration: BoxDecoration(color: colorScheme.surface),
                    child: DevotionContent(data: data),
                  ),
                ],
              ),
            ),

            /// 🔥 FLOATING PLAYER
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                color: theme.colorScheme.surface,
                elevation: 12,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.6 : 0.15,
                ),
                clipBehavior: Clip.antiAlias, // 👈 VERY IMPORTANT
                child: MiniAudioPlayer(audioHandler: audioHandler),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
