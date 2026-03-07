import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  static Future<void> initialize() async {

    print("🚀 PushNotificationService initialization started");

    final messaging = FirebaseMessaging.instance;

    /// Request notification permission
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Notification permission status: ${settings.authorizationStatus}");

    /// Foreground notification presentation (iOS)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// iOS APNS token
    if (Platform.isIOS) {

      print("🍎 Checking APNS token...");

      String? apnsToken = await messaging.getAPNSToken();
      print("🍎 Immediate APNS token: $apnsToken");

      int attempts = 0;

      while (apnsToken == null && attempts < 10) {

        await Future.delayed(const Duration(seconds: 1));
        apnsToken = await messaging.getAPNSToken();
        attempts++;

        print("🍎 Attempt $attempts APNS token: $apnsToken");
      }

      if (apnsToken != null) {
        print("✅ APNS TOKEN RECEIVED:");
        print(apnsToken);
      } else {
        print("❌ APNS token still null after 10 attempts");
      }
    }

    /// Now request FCM token
    final fcmToken = await messaging.getToken();

    print("📱 FCM TOKEN:");
    print(fcmToken);

    /// Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 FCM token refreshed:");
      print(newToken);
    });

    print("✅ PushNotificationService initialization complete");
  }
}