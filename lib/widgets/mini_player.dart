import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:theologia_app_1/widgets/audio_player_sheet.dart';

class MiniAudioPlayer extends StatelessWidget {
  final AudioHandler audioHandler;

  const MiniAudioPlayer({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final mediaItem = mediaSnapshot.data;

        if (mediaItem == null) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, playbackSnapshot) {
            final playback = playbackSnapshot.data;
            final isPlaying = playback?.playing ?? false;

            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AudioPlayerSheet(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// PROGRESS BAR
                    StreamBuilder<Duration>(
                      stream: AudioService.position,
                      builder: (context, positionSnapshot) {
                        final position = positionSnapshot.data ?? Duration.zero;
                        final total =
                            mediaItem.duration ?? const Duration(seconds: 1);

                        return LinearProgressIndicator(
                          value: position.inMilliseconds / total.inMilliseconds,
                          backgroundColor: colors.surfaceContainerHighest,
                          color: colors.primary,
                          minHeight: 4,
                        );
                      },
                    ),

                    /// PLAYER ROW
                    Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          /// COVER IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              mediaItem.artUri?.toString() ?? "",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: colors.surfaceContainerHighest,
                                  child: const Icon(Icons.music_note),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// TITLE + LABEL
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NOW PLAYING",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  mediaItem.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// PREVIOUS
                          IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              color: colors.onSurface.withOpacity(0.6),
                            ),
                            onPressed: () {
                              audioHandler.skipToPrevious();
                            },
                          ),

                          /// PLAY BUTTON
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: colors.onPrimary,
                                size: 28,
                              ),
                              onPressed: () {
                                if (isPlaying) {
                                  audioHandler.pause();
                                } else {
                                  audioHandler.play();
                                }
                              },
                            ),
                          ),

                          /// NEXT
                          IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              color: colors.onSurface.withOpacity(0.6),
                            ),
                            onPressed: () {
                              audioHandler.skipToNext();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
