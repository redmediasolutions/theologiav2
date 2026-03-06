import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:theologia_app_1/main.dart';

class AudioPlayerSheet extends StatelessWidget {
  const AudioPlayerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.6,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🔥 ARTWORK
                StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final item = snapshot.data;

                    if (item?.artUri == null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/theologia-logo.png', // 👈 your asset
                          height: 260,
                          width: 260,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        item!.artUri.toString(),
                        height: 260,
                        width: 260,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                /// 🔥 TITLE
                StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final item = snapshot.data;
                    return Text(
                      item?.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    );
                  },
                ),

                const SizedBox(height: 40),

                /// 🔥 SEEK BAR
                StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final position = state?.updatePosition ?? Duration.zero;
                    final duration =
                        audioHandler.mediaItem.value?.duration ?? Duration.zero;

                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                          max: duration.inMilliseconds.toDouble().clamp(
                            1,
                            double.infinity,
                          ),
                          activeColor: const Color(0xFFbc9a73),
                          onChanged: (value) {
                            audioHandler.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                        ),

                        /// Time Labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                /// 🔥 PLAYER CONTROLS
                StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// ⏪ REWIND 10s
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.replay_10),
                          onPressed: () async {
                            final current =
                                snapshot.data?.updatePosition ?? Duration.zero;

                            audioHandler.seek(
                              current - const Duration(seconds: 10),
                            );
                          },
                        ),

                        /// ▶️ PLAY / PAUSE
                        IconButton(
                          iconSize: 72,
                          icon: Icon(
                            playing
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: const Color(0xFFbc9a73),
                          ),
                          onPressed: () {
                            if (playing) {
                              audioHandler.pause();
                            } else {
                              audioHandler.play();
                            }
                          },
                        ),

                        /// ⏩ FORWARD 10s
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.forward_10),
                          onPressed: () async {
                            final current =
                                snapshot.data?.updatePosition ?? Duration.zero;

                            audioHandler.seek(
                              current + const Duration(seconds: 10),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔥 Duration Formatter
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
