import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_content.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion_header.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/widgets/mini_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theologia_app_1/models/devotion_model.dart';

class DevotionPage extends StatefulWidget {
  final DevotionModel? devotion;
  final String? value;

  const DevotionPage({
    super.key,
    this.devotion,
    this.value,
  });

  @override
  State<DevotionPage> createState() => _DevotionPageState();
}

class _DevotionPageState extends State<DevotionPage> {
  final ScrollController _scrollController = ScrollController();

  DevotionModel? _devotion;
  bool _isLoading = true;

  /// 📖 READING
  bool _openedTracked = false;
  bool _completedTracked = false;
  String? _currentDevotionId;
  double _maxScrollDepth = 0.0;
  DateTime? _startTime;

  /// 🎧 AUDIO
  bool _audioStarted = false;
  bool _audioCompleted = false;
  DateTime? _audioStartTime;

  bool _isFirestoreId(String value) {
    return value.length == 20 && !value.contains('-');
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _init();
  }

  /// 🔥 INIT
  Future<void> _init() async {
    if (widget.devotion != null) {
      _devotion = widget.devotion;
      _isLoading = false;

      _startTracking(_devotion!);

      setState(() {});
      return;
    }

    final value = widget.value;

    if (value == null || value.isEmpty) {
      _isLoading = false;
      setState(() {});
      return;
    }

    final service = FirestoreService();

    DevotionModel? result;

    if (_isFirestoreId(value)) {
      result = await service.getDevotionById(value);
    } else {
      result = await service.getDevotionBySlug(value);
    }

    _devotion = result;
    _isLoading = false;

    if (_devotion != null) {
      _startTracking(_devotion!);
    }

    setState(() {});
  }

  /// 🔥 START TRACKING (SAFE)
  void _startTracking(DevotionModel devotion) {
    _currentDevotionId = devotion.id;

    _openedTracked = false;
    _completedTracked = false;
    _audioStarted = false;
    _audioCompleted = false;

    _maxScrollDepth = 0.0;

    _startTime = DateTime.now();
    _audioStartTime = DateTime.now();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      _trackOpened(devotion.id);
      _trackAudioPlay(devotion.id);
    });
  }

  /// 🔗 SHARE
  Future<void> _shareDevotion() async {
    if (_devotion == null) return;

    final value = (_devotion!.slug != null &&
            _devotion!.slug!.isNotEmpty)
        ? _devotion!.slug
        : _devotion!.id;

    final url = "https://theologia.in/devotion/$value";

    final text =
        "${_devotion!.episodeName}\n\nListen on Theologia:\n$url";

    await Share.share(text);
  }

  /// 📜 SCROLL TRACKING
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    final depth =
        (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);

    if (depth > _maxScrollDepth) {
      _maxScrollDepth = depth;
    }

    if (!_completedTracked && depth >= 0.9) {
      _trackCompleted();
    }
  }

  /// 📖 OPEN
  Future<void> _trackOpened(String id) async {
    if (_openedTracked) return;

    _openedTracked = true;

    await FirebaseFirestore.instance
        .collection('DevotionAnalytics')
        .doc(id)
        .set({
      "openedCount": FieldValue.increment(1),
      "lastOpenedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🎧 PLAY
  Future<void> _trackAudioPlay(String id) async {
    if (_audioStarted) return;

    _audioStarted = true;

    await FirebaseFirestore.instance
        .collection('DevotionAnalytics')
        .doc(id)
        .set({
      "audio.playCount": FieldValue.increment(1),
      "audio.lastPlayedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 📖 COMPLETION
  Future<void> _trackCompleted() async {
    if (_completedTracked || _currentDevotionId == null) return;

    _completedTracked = true;

    await FirebaseFirestore.instance
        .collection('DevotionAnalytics')
        .doc(_currentDevotionId)
        .set({
      "completedCount": FieldValue.increment(1),
      "lastCompletedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🧠 BUCKET
  String _getBucket(int seconds) {
    if (seconds <= 10) return "0_10";
    if (seconds <= 30) return "10_30";
    if (seconds <= 60) return "30_60";
    return "60_plus";
  }

  /// 🔥 SESSION TRACK
  Future<void> _trackSession() async {
    if (_currentDevotionId == null) return;

    /// 📖 READ
    if (_startTime != null) {
      final readSeconds =
          DateTime.now().difference(_startTime!).inSeconds;

      if (readSeconds > 2) {
        final bucket = _getBucket(readSeconds);

        await FirebaseFirestore.instance
            .collection('DevotionAnalytics')
            .doc(_currentDevotionId)
            .set({
          "totalReadTime": FieldValue.increment(readSeconds),
          "readTimeBuckets.$bucket": FieldValue.increment(1),
          "maxScrollDepth": (_maxScrollDepth * 100).round(),
          "lastReadAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }

    /// 🎧 AUDIO
    if (_audioStartTime != null) {
      final listenSeconds =
          DateTime.now().difference(_audioStartTime!).inSeconds;

      if (listenSeconds > 2) {
        final bucket = _getBucket(listenSeconds);

        await FirebaseFirestore.instance
            .collection('DevotionAnalytics')
            .doc(_currentDevotionId)
            .set({
          "audio.totalListenTime":
              FieldValue.increment(listenSeconds),
          "audio.listenBuckets.$bucket":
              FieldValue.increment(1),
        }, SetOptions(merge: true));

        /// 🔥 OPTIONAL COMPLETION
        if (!_audioCompleted && listenSeconds > 30) {
          _audioCompleted = true;

          await FirebaseFirestore.instance
              .collection('DevotionAnalytics')
              .doc(_currentDevotionId)
              .set({
            "audio.completionCount": FieldValue.increment(1),
            "audio.lastCompletedAt":
                FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
    }
  }

  @override
  void dispose() {
    _trackSession();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    /// 🔥 LOADING
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🔥 NOT FOUND
    if (_devotion == null) {
      return const Scaffold(
        body: Center(child: Text("Devotion not found")),
      );
    }

    final devotion = _devotion!;

    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) {
          _trackSession();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Stack(
            children: [
              /// 🔹 CONTENT
              SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  children: [
                    DevotionHeader(
                      imageUrl: devotion.episodeCoverUrl,
                      duration: devotion.episodeduration.isNotEmpty
                          ? devotion.episodeduration
                          : "12:45",
                      audioUrl: devotion.episodeUrl,
                      title: devotion.episodeName,
                      id: devotion.id,
                      slug: devotion.slug,
                    ),

                    Container(
                      color: colorScheme.surface,
                      child: DevotionContent(
                        data: {
                          "title": devotion.episodeName,
                          "description": devotion.episodeDesc,
                          "transcript":
                              devotion.episodeTranscript,
                          "verse": devotion.verse,
                          "verseReference":
                              devotion.verseReference,
                          "songTitle":
                              devotion.episodesongTitle,
                          "songArtist":
                              devotion.episodesongArtist,
                          "songUrl": devotion.episodesongUrl,
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// 🎧 PLAYER
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Material(
                  color: theme.colorScheme.surface,
                  elevation: 12,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: MiniAudioPlayer(
                    audioHandler: audioHandler,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}