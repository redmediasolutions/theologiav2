import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theologia_app_1/auth/login.dart';
import 'package:theologia_app_1/home/home.dart';
// Update these imports to match your actual file paths

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 1. Listen to the stream of authentication changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 2. While Firebase is checking the token, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 3. If snapshot has data, the user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 4. Otherwise, they are logged out
        return const LoginScreen();
      },
    );
  }
}