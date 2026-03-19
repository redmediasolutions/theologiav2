import 'package:flutter/material.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_actionbutton.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_transcript.dart';
import 'package:theologia_app_1/latestdevotion/songcard.dart';


class DevotionContent extends StatelessWidget {
  final Map<String, dynamic> data;

  const DevotionContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TitleSection(title: data['title']),
          DescriptionSection(description: data['description']),
          const SizedBox(height: 20),
          VerseSection(
            verse: data['verse'],
            verseReference: data['verseReference'],
          ),

          

          const SizedBox(height: 24),

          SongOfDayCard(
            title: data['songTitle'],
            artist: data['songArtist'], 
            songurl: data['songurl'],
            
          ),

          const SizedBox(height: 24),

          TranscriptSection(text: data['transcript']),

          const SizedBox(height: 20),

          //const ActionButtons(),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String title;

  const TitleSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  final String description;

  const DescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: colorScheme.onSurface.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

class TranscriptSection extends StatelessWidget {
  final String text;

  const TranscriptSection({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "TRANSCRIPT",
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.5,
            fontSize: 14,
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.8,
            
            color: colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class VerseSection extends StatelessWidget {
  final String verseReference;
  final String verse;

  const VerseSection({super.key, required this.verseReference, required this.verse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          verseReference.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 14,
            letterSpacing: 1.5,
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        Text(
          verse,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.8,
            color: colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}