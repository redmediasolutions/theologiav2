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
import 'package:theologia_app_1/services/updateservice.dart';

late final TheologiaAudioHandler audioHandler;

final ValueNotifier<bool> miniPlayerDismissed = ValueNotifier(false);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE FIRST
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Ensure anonymous user exists
  await _ensureUser();

  /// AUDIO SERVICE
  audioHandler = await AudioService.init(
    builder: () => TheologiaAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'theologia.audio',
      androidNotificationChannelName: 'Devotion Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(const MainApp());
}

Future<void> _ensureUser() async {
  final auth = FirebaseAuth.instance;

  print("🔐 Checking Firebase user...");

  if (auth.currentUser == null) {
    print("👤 No user found. Signing in anonymously...");
    final credential = await auth.signInAnonymously();

    print("✅ Anonymous login success");
    print("UID: ${credential.user?.uid}");
  } else {
    print("👤 Existing user detected");
    print("UID: ${auth.currentUser?.uid}");
    print("Anonymous: ${auth.currentUser?.isAnonymous}");
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      /// Push notifications
      PushNotificationService.initialize();

    });
  }



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


