import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlerenderer.dart';
import 'package:theologia_app_1/articlepage/articlesilverappbar.dart';
import 'package:theologia_app_1/askquestions/articlequestionslist.dart';
import 'package:theologia_app_1/askquestions/askquestions.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';

class ArticleView extends StatefulWidget {
  final Singlearticlemodel article;
  final String heroTag;

  const ArticleView({super.key, required this.article, required this.heroTag});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ScrollController _scrollController = ScrollController();
  bool completedTracked = false;

  @override
  void initState() {
    super.initState();

    /// Detect when user reaches end of article
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0 &&
          _scrollController.position.extentAfter < 200) {
        if (!completedTracked) {
          completedTracked = true;
          debugPrint("Article completion triggered");
          incrementArticleCompleted();
        }
      }
    });
  }

  Future<void> incrementArticleCompleted() async {
    try {
      await FirebaseFirestore.instance
          .collection('Articles')
          .doc(widget.article.id)
          .update({'analytics.completedCount': FieldValue.increment(1)});
    } catch (e) {
      debugPrint("Completion analytics error: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int orderedCounter = 0;
    final blocks = widget.article.normalizedBlocks ?? [];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const ArticleSliverAppBar(),

        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              /// 🔥 Entire article selectable
              SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      widget.article.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    /// Excerpt
                    if (widget.article.excerpt.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.article.excerpt,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    /// Featured Image
                    if (widget.article.featuredImage != null)
                      Hero(
                        tag: widget.heroTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.article.featuredImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    const SizedBox(height: 25),

                    ...blocks.map<Widget>((block) {
                      final map = Map<String, dynamic>.from(block);

                      if (map['type'] == 'list_item' &&
                          map['ordered'] == true) {
                        final widget = ArticleBlockRenderer(
                          block: map,
                          listIndex: orderedCounter,
                        );
                        orderedCounter++;
                        return widget;
                      } else {
                        // Reset counter when list ends
                        orderedCounter = 0;

                        return ArticleBlockRenderer(block: map);
                      }
                    }),

                    const SizedBox(height: 30),

AskQuestionBox(articleId: widget.article.id),

const SizedBox(height: 20),

ArticleQuestionsList(articleId: widget.article.id),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
