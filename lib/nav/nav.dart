import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your pages
import 'package:theologia_app_1/articlepage/articlepage.dart';
import 'package:theologia_app_1/auth/createaccount.dart';
import 'package:theologia_app_1/auth/forgotpassword.dart';
import 'package:theologia_app_1/categorypage/collectiondetailpage.dart';
import 'package:theologia_app_1/devotionpage/devotiondetailpage.dart';
import 'package:theologia_app_1/devotionpage/devotionpage.dart';
import 'package:theologia_app_1/foryoupage/foryoupage.dart';
import 'package:theologia_app_1/home/home.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/nav/shell.dart';
import 'package:theologia_app_1/profilepage.dart';
import 'package:theologia_app_1/searchpage/searchpage.dart';
import 'package:theologia_app_1/auth/login.dart';
import 'package:theologia_app_1/services/latestdevotionloader.dart'; // Ensure you import your LoginScreen

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  // 1. Listen to Firebase Auth changes to trigger redirects automatically
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  // 2. Redirect Logic: Check if user is logged in
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null && !user.isAnonymous;

    final location = state.uri.toString();
    final isLoggingIn = location == '/login';

    /*
    // 🔒 Routes that REQUIRE login
    final requiresLogin =
        location.startsWith('/search') ||
        location.startsWith('/devotions') ||
        location.startsWith('/profile');
    
    // If trying to access protected route without login
    if (requiresLogin && !isLoggedIn) {
      return '/login';
    }
    */
    // If already logged in and trying to open login page
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null;
  },

  routes: [
    // --- Login Route (Outside the Shell) ---
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

     GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountScreen(),
    ),

    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),


    // --- Article Page (Outside the Shell) ---
    // Updated to accept an ID parameter
    GoRoute(
  path: '/article/:value',
  name: 'article',
  builder: (context, state) {
    final value = state.pathParameters['value'];

    if (value == null || value.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Article not found')),
      );
    }

    return ArticlePage(
      key: ValueKey('article-$value'),
      value: value,
    );
  },
),

GoRoute(
  path: '/devotion',
  name: 'latest-devotion-link',
  builder: (context, state) {
    return const LatestDevotionLoader();
  },
),

GoRoute(
  path: '/devotion/:value',
  name: 'devotion',
  builder: (context, state) {
    final value = state.pathParameters['value']!;
    return DevotionPage(value: value);
  },
),



    // --- Main App Shell (Bottom Navigation) ---
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/collection/:collectionId',
          name: 'collection',
          builder: (BuildContext context, GoRouterState state) {
            final collectionId = state.pathParameters['collectionId']!;

            final collectionTitle = state.extra as String? ?? '';

            return CollectionDetailPage(
              collectionId: collectionId,
              collectionTitle: collectionTitle,
            );
          },
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPage();
          },
        ),
        GoRoute(
          path: '/foryoupage',
          name: 'foryoupage',
          builder: (BuildContext context, GoRouterState state) {
            return const ForYouPage();
          },
        ),
        GoRoute(
          path: '/devotions',
          name: 'devotions',
          builder: (BuildContext context, GoRouterState state) {
            return const Devotionpage();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            // Usually you'd point this to a ProfileScreen()
            return const ProfilePage();
          },
        ),
      ],
    ),
  ],
);

// --- Utility Class for Listening to Firebase Stream ---
// This converts the Firebase Stream into a Listenable that GoRouter can understand
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
