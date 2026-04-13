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
  final ScrollController _scrollController = ScrollController();

  bool _openedTracked = false;
  bool _completedTracked = false;
  bool _sessionTracked = false;

  String? _currentArticleId;

  double _maxScrollDepth = 0.0;
  DateTime? _startTime;

  bool _isFirestoreId(String value) {
    return value.length == 20 && !value.contains('-');
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  /// 🔥 Ensure analytics doc exists
  Future<void> _ensureAnalyticsDoc(String articleId) async {
    final docRef = FirebaseFirestore.instance
        .collection('ArticleAnalytics')
        .doc(articleId);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        "openedCount": 0,
        "completedCount": 0,
        "totalReadTime": 0,
        "maxScrollDepth": 0,
        "readTimeBuckets": {
          "0_10": 0,
          "10_30": 0,
          "30_60": 0,
          "60_plus": 0,
        },
        "createdAt": FieldValue.serverTimestamp(),
      });

      debugPrint("🆕 Analytics doc created");
    }
  }

  /// 🧠 Bucket helper
  String _getReadTimeBucket(int seconds) {
    if (seconds <= 10) return "0_10";
    if (seconds <= 30) return "10_30";
    if (seconds <= 60) return "30_60";
    return "60_plus";
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    final maxExtent = position.maxScrollExtent;
    if (maxExtent == 0) return;

    final currentDepth =
        (position.pixels / maxExtent).clamp(0.0, 1.0);

    if (currentDepth > _maxScrollDepth) {
      _maxScrollDepth = currentDepth;
    }

    if (!_completedTracked && currentDepth >= 0.9) {
      _trackCompleted();
    }
  }

  Future<void> _trackOpened(String articleId) async {
    if (_openedTracked) return;
    _openedTracked = true;

    try {
      await _ensureAnalyticsDoc(articleId);

      await FirebaseFirestore.instance
          .collection('ArticleAnalytics')
          .doc(articleId)
          .set({
        "openedCount": FieldValue.increment(1),
        "lastOpenedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("📊 Opened tracked");
    } catch (e) {
      debugPrint("🔥 Opened error: $e");
    }
  }

  Future<void> _trackCompleted() async {
    if (_completedTracked || _currentArticleId == null) return;
    _completedTracked = true;

    try {
      await _ensureAnalyticsDoc(_currentArticleId!);

      await FirebaseFirestore.instance
          .collection('ArticleAnalytics')
          .doc(_currentArticleId)
          .set({
        "completedCount": FieldValue.increment(1),
        "lastCompletedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("✅ Completed tracked");
    } catch (e) {
      debugPrint("🔥 Completed error: $e");
    }
  }

  /// 🔥 Track session
  Future<void> _trackReadSession() async {
    if (_sessionTracked) return;
    _sessionTracked = true;

    if (_currentArticleId == null || _startTime == null) return;

    final duration =
        DateTime.now().difference(_startTime!).inSeconds;

    if (duration < 2) return;

    final bucket = _getReadTimeBucket(duration);

    try {
      await _ensureAnalyticsDoc(_currentArticleId!);

      await FirebaseFirestore.instance
          .collection('ArticleAnalytics')
          .doc(_currentArticleId)
          .set({
        "totalReadTime": FieldValue.increment(duration),
        "readTimeBuckets.$bucket": FieldValue.increment(1),
        "maxScrollDepth": (_maxScrollDepth * 100).round(),
        "lastReadAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("⏱️ Session tracked: $duration sec");
      debugPrint("🧠 Bucket: $bucket");
    } catch (e) {
      debugPrint("🔥 Session error: $e");
    }
  }

  Future<void> _shareArticle(Singlearticlemodel article) async {
    final slug = (article.slug != null && article.slug!.isNotEmpty)
        ? article.slug
        : article.id;

    final url = "https://theologia.in/article/$slug";

    await Share.share(
      "${article.title}\n\nRead this on Theologia:\n$url",
    );
  }

  @override
  void dispose() {
    _trackReadSession();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    final stream = _isFirestoreId(widget.value)
        ? service.getArticle(widget.value)
        : service.getArticleBySlug(widget.value);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        _trackReadSession();

        if (Navigator.canPop(context)) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      child: Scaffold(
        body: StreamBuilder<Singlearticlemodel?>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final article = snapshot.data!;

            /// 🔥 Reset on article change
            if (_currentArticleId != article.id) {
              _currentArticleId = article.id;

              _openedTracked = false;
              _completedTracked = false;
              _sessionTracked = false;
              _maxScrollDepth = 0.0;

              _startTime = DateTime.now();

              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) _trackOpened(article.id);
              });
            }

            final blocks = article.normalizedBlocks ?? [];
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _trackReadSession();
                        context.pop();
                      },
                    ),
                    expandedHeight: 80,
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
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
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge,
                          ),

                          if (article.excerpt.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(article.excerpt),
                          ],

                          if (article.featuredImage != null &&
                              article.featuredImage!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                height: 450,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: article.featuredImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),

                          ...blocks.map((block) {
                            return ArticleBlockRenderer(
                              block: Map<String, dynamic>.from(block),
                            );
                          }),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}