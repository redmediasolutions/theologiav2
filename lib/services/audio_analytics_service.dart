import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AudioAnalyticsService {

  static Future<void> incrementAudioOpened(String audioId) async {
    debugPrint("🎧 incrementAudioOpened called for: $audioId");

    try {
      await FirebaseFirestore.instance
          .collection('Devotions')
          .doc(audioId)
          .update({
        'analytics.openedCount': FieldValue.increment(1),
      });

      debugPrint("✅ Audio opened count incremented for: $audioId");

    } catch (e) {
      debugPrint("❌ Audio open analytics error: $e");
    }
  }

  static Future<void> incrementAudioCompleted(String audioId) async {
    debugPrint("🎧 incrementAudioCompleted called for: $audioId");

    try {
      await FirebaseFirestore.instance
          .collection('Devotions')
          .doc(audioId)
          .update({
        'analytics.completedCount': FieldValue.increment(1),
      });

      debugPrint("✅ Audio completion count incremented for: $audioId");

    } catch (e) {
      debugPrint("❌ Audio completion analytics error: $e");
    }
  }

}