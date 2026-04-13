import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AudioAnalyticsService {
  static final _collection =
      FirebaseFirestore.instance.collection('DevotionAnalytics');

  /// ▶️ PLAY
  static Future<void> incrementAudioPlay(String id) async {
    debugPrint("🎧 Play: $id");

    try {
      await _collection.doc(id).set({
        "audio.playCount": FieldValue.increment(1),
        "audio.lastPlayedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Play error: $e");
    }
  }

  /// ⏸ PAUSE
  static Future<void> incrementAudioPause(String id) async {
    debugPrint("⏸ Pause: $id");

    try {
      await _collection.doc(id).set({
        "audio.pauseCount": FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Pause error: $e");
    }
  }

  /// ▶️ RESUME
  static Future<void> incrementAudioResume(String id) async {
    debugPrint("▶️ Resume: $id");

    try {
      await _collection.doc(id).set({
        "audio.resumeCount": FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Resume error: $e");
    }
  }

  /// ✅ COMPLETE
  static Future<void> incrementAudioCompleted(String id) async {
    debugPrint("✅ Completed: $id");

    try {
      await _collection.doc(id).set({
        "audio.completionCount": FieldValue.increment(1),
        "audio.lastCompletedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Completion error: $e");
    }
  }

  /// ⏱ LISTEN SESSION
  static Future<void> trackListenSession({
    required String id,
    required int seconds,
    required String bucket,
  }) async {
    debugPrint("⏱ Listen session: $id ($seconds sec)");

    try {
      await _collection.doc(id).set({
        "audio.totalListenTime": FieldValue.increment(seconds),
        "audio.listenBuckets.$bucket": FieldValue.increment(1),
        "audio.lastStopPosition": seconds,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ Session error: $e");
    }
  }
}