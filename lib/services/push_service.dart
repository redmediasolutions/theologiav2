import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationService {
  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// iOS requires APNS token first
    if (Platform.isIOS) {
      String? apnsToken;

      while (apnsToken == null) {
        await Future.delayed(const Duration(milliseconds: 500));
        apnsToken = await messaging.getAPNSToken();
      }
    }

    /// Now it is safe to request the FCM token
    final fcmToken = await messaging.getToken();

    final user = FirebaseAuth.instance.currentUser;

    if (fcmToken != null && user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set({
        "fcmToken": fcmToken,
      }, SetOptions(merge: true));
    }

    /// Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .set({
          "fcmToken": newToken,
        }, SetOptions(merge: true));
      }
    });
  }
}