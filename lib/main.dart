import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/apptheme.dart';
import 'package:theologia_app_1/firebase_options.dart';
import 'package:theologia_app_1/nav/nav.dart';
import 'package:theologia_app_1/services/audiohandler.dart';
import 'package:theologia_app_1/services/push_service.dart';
import 'package:theologia_app_1/services/themecontroller.dart';

late final TheologiaAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// AUDIO SERVICE
  audioHandler = await AudioService.init(
    builder: () => TheologiaAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'theologia.audio',
      androidNotificationChannelName: 'Devotion Playback',
      androidNotificationOngoing: true,
    ),
  );

  /// FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 🔐 Ensure user exists (anonymous login)
  await _ensureUser();

  /// 🔔 Push Notifications
  await PushNotificationService.initialize();

  runApp(const MainApp());
}

Future<void> _ensureUser() async {
  final auth = FirebaseAuth.instance;

  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
   return ValueListenableBuilder<ThemeMode>(
  valueListenable: ThemeController.themeMode,
  builder: (context, mode, _) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      routerConfig: appRouter,
    );
  },
);
  }
}
 