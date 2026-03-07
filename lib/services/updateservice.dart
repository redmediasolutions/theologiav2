import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {

  static Future<UpdateStatus> checkForUpdate() async {

    print("🔄 Starting update check...");

    final remoteConfig = FirebaseRemoteConfig.instance;

    try {

      /// Remote config settings (disable cache during testing)
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      /// Default values (fallback if remote config fails)
      await remoteConfig.setDefaults({
        'min_android_version': '0.0.0',
        'latest_android_version': '0.0.0',
        'min_ios_version': '0.0.0',
        'latest_ios_version': '0.0.0',
      });

      print("📡 Fetching Remote Config...");
      await remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      print("📱 Current App Version: $currentVersion");

      String minVersion;
      String latestVersion;

      if (Platform.isAndroid) {

        print("🤖 Platform: ANDROID");

        minVersion = remoteConfig.getString('min_android_version');
        latestVersion = remoteConfig.getString('latest_android_version');

        print("📦 Android Remote Config:");
        print("   min_android_version = $minVersion");
        print("   latest_android_version = $latestVersion");

      } else if (Platform.isIOS) {

        print("🍎 Platform: IOS");

        minVersion = remoteConfig.getString('min_ios_version');
        latestVersion = remoteConfig.getString('latest_ios_version');

        print("📦 iOS Remote Config:");
        print("   min_ios_version = $minVersion");
        print("   latest_ios_version = $latestVersion");

      } else {

        print("⚠️ Unsupported platform");
        return UpdateStatus.none;

      }

      /// Force update check
      if (_isOlder(currentVersion, minVersion)) {

        print("⛔ Force update required!");
        return UpdateStatus.force;

      }

      /// Soft update check
      if (_isOlder(currentVersion, latestVersion)) {

        print("⬆️ Soft update available.");
        return UpdateStatus.soft;

      }

      print("✅ App is up to date.");
      return UpdateStatus.none;

    } catch (e) {

      print("❌ Update check failed: $e");
      return UpdateStatus.none;

    }

  }

  /// Safe version comparison
  static bool _isOlder(String current, String target) {

    try {

      final currentParts =
          current.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final targetParts =
          target.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final length =
          currentParts.length > targetParts.length
              ? currentParts.length
              : targetParts.length;

      for (int i = 0; i < length; i++) {

        final currentValue =
            i < currentParts.length ? currentParts[i] : 0;

        final targetValue =
            i < targetParts.length ? targetParts[i] : 0;

        if (currentValue < targetValue) return true;
        if (currentValue > targetValue) return false;

      }

      return false;

    } catch (e) {

      print("⚠️ Version comparison error: $e");
      return false;

    }

  }

}

enum UpdateStatus {
  none,
  soft,
  force,
}