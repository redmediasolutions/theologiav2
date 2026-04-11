import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/articlepage/articlerenderer.dart';
import 'package:theologia_app_1/models/singlearticlemodel.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/services/themecontroller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class ArticlePage extends StatefulWidget {
  final String value;

  const ArticlePage({super.key, required this.value});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late Stream<Singlearticlemodel?> _articleStream;

  final ScrollController _scrollController = ScrollController();

  bool _openedTracked = false;
  bool _completedTracked = false;
  String? _resolvedArticleId;
  bool _isFirestoreId(String value) {
    return value.length == 20 && !value.contains('-');
  }

  @override
  void initState() {
    super.initState();

    final service = FirestoreService();

    if (_isFirestoreId(widget.value)) {
      debugPrint("🔵 Loading via ID");
      _articleStream = service.getArticle(widget.value);
    } else {
      debugPrint("🟢 Loading via SLUG");
      _articleStream = service.getArticleBySlug(widget.value);
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_completedTracked) return;

    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Trigger when user reaches ~90% of content
    if (position.pixels >= position.maxScrollExtent * 0.9) {
      _trackCompleted();
    }
  }

  Future<void> _shareArticle(Singlearticlemodel article) async {
    final slug = (article.slug != null && article.slug!.isNotEmpty)
        ? article.slug
        : article.id;

    final url = "https://theologia.in/article/$slug";

    final text = "${article.title}\n\nRead this on Theologia:\n$url";

    await Share.share(text);
  }

  Future<void> _trackOpened() async {
    if (_openedTracked || _resolvedArticleId == null) return;

    _openedTracked = true;

    try {
      await FirebaseFirestore.instance
          .collection('Articles')
          .doc(_resolvedArticleId)
          .set({
            "analytics": {"openedCount": FieldValue.increment(1)},
          }, SetOptions(merge: true));

      debugPrint("📊 Opened count incremented");
    } catch (e) {
      debugPrint("🔥 Error updating openedCount: $e");
    }
  }

  Future<void> _trackCompleted() async {
    if (_completedTracked || _resolvedArticleId == null) return;

    _completedTracked = true;

    try {
      await FirebaseFirestore.instance
          .collection('Articles')
          .doc(_resolvedArticleId)
          .set({
            "analytics": {"completedCount": FieldValue.increment(1)},
          }, SetOptions(merge: true));

      debugPrint("✅ Completed count incremented");
    } catch (e) {
      debugPrint("🔥 Error updating completedCount: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // ✅ FIRST
    _scrollController.dispose(); // ✅ THEN dispose

    debugPrint("🧹 ArticlePage disposed for: ${_resolvedArticleId}");
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
            _resolvedArticleId = article.id;

            // 🔥 Redirect if opened via slug

            if (!_openedTracked) {
              _openedTracked = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _trackOpened();
                }
              });
            }

            int orderedCounter = 0;
            final blocks = article.normalizedBlocks ?? [];

            final isDark = Theme.of(context).brightness == Brightness.dark;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                /// Sliver App Bar
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        context.pop();
                      } else {
                        context.go('/'); // fallback to home
                      }
                    },
                  ),
                  pinned: false,
                  expandedHeight: 80,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  systemOverlayStyle: isDark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () => _shareArticle(article),
                    ),
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
                  sliver: SliverToBoxAdapter(
                    child: SelectionArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                          if (article.featuredImage != null &&
                              article.featuredImage!.isNotEmpty) ...[
                            const SizedBox(height: 20),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 300, // 🔥 IMPORTANT: constrain height
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: article.featuredImage!,
                                  fit: BoxFit.fill,

                                  // 🔥 Prevent large memory usage
                                  memCacheWidth: 800,
                                  memCacheHeight: 400,

                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),

                                  errorWidget: (context, url, error) =>
                                      const Center(
                                        child: Icon(Icons.image, size: 40),
                                      ),
                                ),
                              ),
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
                        ],
                      ),
                    ),
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
