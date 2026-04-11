import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:theologia_app_1/nav/nav.dart';

class PushNotificationService {

  static Future<void> initialize() async {

    print("🚀 PushNotificationService initialization started");

    final messaging = FirebaseMessaging.instance;

    /// Request permission
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Notification permission status: ${settings.authorizationStatus}");

    /// iOS foreground behavior
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// iOS APNS
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      print("🍎 APNS token: $apnsToken");
    }

    /// FCM token
    final fcmToken = await messaging.getToken();
    print("📱 FCM TOKEN: $fcmToken");

    /// 🔥 Subscribe topics
    final topics = ['devotions', 'articles', 'media'];

    for (final topic in topics) {
      await messaging.subscribeToTopic(topic);
      print("✅ Subscribed to $topic");
    }

    /// 🔥 HANDLE BACKGROUND TAP
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification clicked (background)");

      final deepLink = message.data['deepLink'];
      print("🔗 DeepLink: $deepLink");

      if (deepLink != null && deepLink.isNotEmpty) {
        _handleNavigation(deepLink);
      }
    });

    /// 🔥 HANDLE TERMINATED STATE
    final initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      print("🚀 App opened from terminated state");

      final deepLink = initialMessage.data['deepLink'];
      print("🔗 DeepLink: $deepLink");

      if (deepLink != null && deepLink.isNotEmpty) {
        _handleNavigation(deepLink);
      }
    }

    /// Token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 FCM token refreshed: $newToken");
    });

    print("✅ PushNotificationService initialization complete");
  }

  /// 🔥 NAVIGATION HANDLER
  static void _handleNavigation(String deepLink) {
    print("➡️ Navigating to: $deepLink");

    appRouter.go(deepLink); // 👈 your GoRouter instance
  }
}