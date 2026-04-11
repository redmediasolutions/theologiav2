import 'package:flutter/material.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_content.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_header.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/widgets/mini_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theologia_app_1/models/devotion_model.dart';


class DevotionPage extends StatefulWidget {
  final DevotionModel? devotion; // 🔥 optional now
  final String? value;

  const DevotionPage({
    super.key,
    this.devotion,
    this.value,
  });

  @override
  State<DevotionPage> createState() => _DevotionPageState();
}

class _DevotionPageState extends State<DevotionPage> {
  DevotionModel? _devotion;
  bool _isLoading = true;

  bool _isFirestoreId(String value) {
    return value.length == 20 && !value.contains('-');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    /// 🔥 Case 1: Already have data (fast navigation)
    if (widget.devotion != null) {
      _devotion = widget.devotion;
      _isLoading = false;
      setState(() {});
      return;
    }

    /// 🔥 Case 2: Deep link
    final value = widget.value;

    if (value == null || value.isEmpty) {
      _isLoading = false;
      setState(() {});
      return;
    }

    final service = FirestoreService();

    DevotionModel? result;

    if (_isFirestoreId(value)) {
      result = await service.getDevotionById(value);
    } else {
      result = await service.getDevotionBySlug(value);
    }

    _devotion = result;
    _isLoading = false;
    setState(() {});
  }

  /// 🔗 SHARE
  Future<void> _shareDevotion() async {
    if (_devotion == null) return;

    final value = (_devotion!.slug != null &&
            _devotion!.slug!.isNotEmpty)
        ? _devotion!.slug
        : _devotion!.id;

    final url = "https://theologia.in/devotion/$value";

    final text =
        "${_devotion!.episodeName}\n\nListen on Theologia:\n$url";

    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    /// 🔥 LOADING
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🔥 NOT FOUND
    if (_devotion == null) {
      return const Scaffold(
        body: Center(child: Text("Devotion not found")),
      );
    }

    final devotion = _devotion!;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 MAIN CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                children: [
                  /// 🔥 HEADER
                  DevotionHeader(
                    imageUrl: devotion.episodeCoverUrl,
                    duration: devotion.episodeduration.isNotEmpty
                        ? devotion.episodeduration
                        : "12:45",
                    audioUrl: devotion.episodeUrl,
                    title: devotion.episodeName,
                    id: devotion.id,
                    slug: devotion.slug,
                  ),

                  /// 🔥 CONTENT
                  Container(
                    decoration:
                        BoxDecoration(color: colorScheme.surface),
                    child: DevotionContent(
                      data: {
                        "title": devotion.episodeName,
                        "description": devotion.episodeDesc,
                        "transcript": devotion.episodeTranscript,
                        "verse": devotion.verse,
                        "verseReference":
                            devotion.verseReference,
                        "songTitle":
                            devotion.episodesongTitle,
                        "songArtist":
                            devotion.episodesongArtist,
                        "songUrl": devotion.episodesongUrl,
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// 🎧 FLOATING PLAYER
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                color: theme.colorScheme.surface,
                elevation: 12,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark
                      ? 0.6
                      : 0.15,
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    MiniAudioPlayer(audioHandler: audioHandler),
              ),
            ),
          ],
        ),
      ),
    );
  }
}