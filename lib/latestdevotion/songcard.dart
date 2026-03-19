import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SongOfDayCard extends StatelessWidget {
  final String title;
  final String artist;
  final String songurl;

  const SongOfDayCard({
    super.key,
    required this.title,
    required this.artist,
    required this.songurl,
  });

  Future<void> _openUrl() async {
    final uri = Uri.parse(songurl);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $songurl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// LABEL
        Text(
          "SONG",
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.5,
            fontSize: 14,
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        /// CARD
        Material(
          color: colorScheme.surfaceContainerHighest, // ✅ FIXED
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,

          /// subtle elevation feel
          child: InkWell(
            onTap: _openUrl,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),

                /// 🔥 helps in dark mode separation
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// TITLE
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// ARTIST
                        Text(
                          artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// ACTION ICON
                  Icon(
                    Icons.open_in_new,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}