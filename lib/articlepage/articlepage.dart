import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theologia_app_1/articlepage/articlerenderer.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';
import 'package:theologia_app_1/services/themecontroller.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;

  const ArticlePage({super.key, required this.articleId});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Stream<Singlearticlemodel?> _articleStream;

  @override
  void initState() {
    super.initState();

    debugPrint("📄 ArticlePage initState()");
    debugPrint("📄 ArticleId: ${widget.articleId}");

    _articleStream = _createStream();
  }

  Stream<Singlearticlemodel?> _createStream() {
    debugPrint("📡 Article stream CREATED: ${widget.articleId}");

    return FirebaseFirestore.instance
        .collection('Articles')
        .doc(widget.articleId)
        .snapshots()
        .map((doc) {
          debugPrint("📡 Firestore snapshot received");

          if (!doc.exists || doc.data() == null) {
            debugPrint("❌ Article not found");
            return null;
          }

          try {
            final article = Singlearticlemodel.fromFirestore(doc);
            debugPrint("✅ Article parsed: ${article.title}");
            return article;
          } catch (e) {
            debugPrint("🔥 Article parsing error: $e");
            return null;
          }
        })
        .handleError((error) {
          debugPrint("🔥 Firestore stream error: $error");
        });
  }

  @override
  void dispose() {
    debugPrint("🧹 ArticlePage disposed for: ${widget.articleId}");
    super.dispose();
  }

  Future<bool> _handleBack() async {
    debugPrint("⬅️ Back pressed on ArticlePage");
    return true; // allow navigation
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🔄 ArticlePage build()");

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        body: StreamBuilder<Singlearticlemodel?>(
          stream: _articleStream,
          builder: (context, snapshot) {
            debugPrint("📡 StreamBuilder state: ${snapshot.connectionState}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Article not found"));
            }

            final article = snapshot.data!;
            int orderedCounter = 0;
            final blocks = article.normalizedBlocks ?? [];

            final isDark = Theme.of(context).brightness == Brightness.dark;

            return CustomScrollView(
              slivers: [
                /// Sliver App Bar
                SliverAppBar(
                  pinned: false,
                  expandedHeight: 80,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  systemOverlayStyle: isDark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                  actions: [
                    IconButton(
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                      onPressed: ThemeController.toggleTheme,
                    ),
                  ],
                  /*
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding:
                        const EdgeInsetsDirectional.only(start: 16, bottom: 16,),
                    title: Text(
                      article.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),*/
                ),

                /// Article Content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      /// Title
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      /// Excerpt
                      if (article.excerpt.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          article.excerpt,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],

                      if (article.featuredImage != null) ...[
                        const SizedBox(height: 20),
                        Image.network(
                          article.featuredImage!,
                          fit: BoxFit.cover,
                        ),
                      ],

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      /// Blocks
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
                          orderedCounter = 0;
                          return ArticleBlockRenderer(block: map);
                        }
                      }),

                      const SizedBox(height: 60),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
