import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/versecontainer.dart';

class ArticleBlockRenderer extends StatelessWidget {
  final Map<String, dynamic> block;
  final int? listIndex;

  const ArticleBlockRenderer({
    super.key,
    required this.block,
    this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    final type = block['type'];

    switch (type) {
      case 'paragraph':
        return _buildParagraph(context);

      case 'heading':
        return _buildHeading(context);

      case 'quote':
        return _buildQuote(context);

      case 'list_item':
        return _buildListItem(context);

      case 'image':
        return _buildImage();

      case 'verse':
        return VerseContainer(
          verse: _plainText(block['content']),
          verselocation: block['reference']?.toString() ?? '',
        );

      default:
        return const SizedBox.shrink();
    }
  }

  /// 🔹 PARAGRAPH
  Widget _buildParagraph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: _buildRichText(
        context,
        block['content'],
        baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              height: 1.6,
              letterSpacing: 0,
            ),
      ),
    );
  }

  /// 🔹 HEADING
  Widget _buildHeading(BuildContext context) {
    final level = block['level'] ?? 1;

    double fontSize;
    FontWeight weight;

    switch (level) {
      case 1:
        fontSize = 30;
        weight = FontWeight.bold;
        break;
      case 2:
        fontSize = 28;
        weight = FontWeight.w700;
        break;
      case 3:
        fontSize = 24;
        weight = FontWeight.w600;
        break;
      default:
        fontSize = 22;
        weight = FontWeight.bold;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
      child: _buildRichText(
        context,
        block['content'],
        baseStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: fontSize,
              fontWeight: weight,
              letterSpacing: 0,
            ),
      ),
    );
  }

  /// 🔹 QUOTE
  Widget _buildQuote(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.3),
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 4,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _buildRichText(
          context,
          block['content'],
          baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  /// 🔹 LIST ITEM
  Widget _buildListItem(BuildContext context) {
    final ordered = block['ordered'] == true;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ordered ? '${(listIndex ?? 0) + 1}. ' : '• ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 17,
                  height: 1.6,
                  letterSpacing: 0,
                ),
          ),
          Expanded(
            child: _buildRichText(
              context,
              block['content'],
              baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    height: 1.6,
                    letterSpacing: 0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 IMAGE (FIXED + OPTIMIZED)
  Widget _buildImage() {
    final url = block['url'];

    if (url == null || url.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 220, // 🔥 constrain height (important)
          width: double.infinity,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.image, size: 40),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔹 RICH TEXT (SAFE PARSING)
  Widget _buildRichText(
    BuildContext context,
    List<dynamic>? content, {
    TextStyle? baseStyle,
  }) {
    final style = baseStyle ?? Theme.of(context).textTheme.bodyLarge;

    final registrar = SelectionContainer.maybeOf(context);

    return RichText(
      selectionRegistrar: registrar,
      selectionColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.3),
      text: TextSpan(
        style: style,
        children: (content ?? []).map<TextSpan>((rawSpan) {
          if (rawSpan is! Map) {
            return const TextSpan(text: '');
          }

          final span = Map<String, dynamic>.from(rawSpan);

          return TextSpan(
            text: span['text']?.toString() ?? '',
            style: style?.copyWith(
              fontWeight: span['bold'] == true
                  ? FontWeight.bold
                  : style.fontWeight,
              fontStyle: span['italic'] == true
                  ? FontStyle.italic
                  : style.fontStyle,
              decoration: span['underline'] == true
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 🔹 SAFE TEXT EXTRACTION
  String _plainText(List<dynamic>? content) {
    return (content ?? []).map((span) {
      if (span is Map && span['text'] != null) {
        return span['text'].toString();
      }
      return '';
    }).join();
  }
}