import 'package:flutter/material.dart';
import 'package:theologia_app_1/models/article_question_model.dart';
import 'package:theologia_app_1/services/firestore.dart';

class ArticleQuestionsList extends StatelessWidget {
  final String articleId;

  const ArticleQuestionsList({
    super.key,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<ArticleQuestionModel>>(
      stream: FirestoreService().streamArticleQuestions(articleId),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final questions = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            /// SECTION TITLE
            Text(
              "Questions & Answers",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            /// QUESTIONS
            ...questions.map((question) {

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// QUESTION
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.help_outline,
                          size: 20,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            question.question,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// ASKED BY
                    Text(
                      "Asked by ${question.askedBy}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.6),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Divider(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                    ),

                    const SizedBox(height: 10),

                    /// ANSWER
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            question.answer,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}