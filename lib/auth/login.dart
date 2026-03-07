import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// EMAIL LOGIN
  Future<void> _handleLogin() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    final user = _auth.currentUser;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    if (user != null && user.isAnonymous) {
      try {
        /// Try linking anonymous → email
        await user.linkWithCredential(credential);

      } on FirebaseAuthException catch (e) {

        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {

          /// IMPORTANT: remove anonymous session first
          await _auth.signOut();

          /// Then sign in normally
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

        } else {
          rethrow;
        }
      }

    } else {

      /// Normal login
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    await _updateUserRecord();

    if (mounted) context.pop();

  } on FirebaseAuthException catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Login Failed")),
    );

  } finally {

    if (mounted) setState(() => _isLoading = false);

  }
}

  /// GOOGLE LOGIN

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      /// If user is anonymous → link account
      if (user != null && user.isAnonymous) {
        await user.linkWithCredential(credential);
      } else {
        await auth.signInWithCredential(credential);
      }

      if (mounted) context.pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        await FirebaseAuth.instance.signInWithCredential(e.credential!);
        if (mounted) context.pop();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Google Login Failed")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleLogin() async {

  setState(() => _isLoading = true);

  try {

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final user = _auth.currentUser;

    /// Link if anonymous
    if (user != null && user.isAnonymous) {

      await user.linkWithCredential(oauthCredential);

    } else {

      await _auth.signInWithCredential(oauthCredential);

    }

    await _updateUserRecord();

    if (mounted) context.pop();

  } on FirebaseAuthException catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Apple login failed")),
    );

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Apple login failed")),
    );

  } finally {

    if (mounted) setState(() => _isLoading = false);

  }
}

  /// Update Firestore User Document
  Future<void> _updateUserRecord() async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      "email": user.email,
      "name": user.displayName,
      "isAnonymous": user.isAnonymous,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1511),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Container(
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B2118), Color(0xFF1A1511)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    /// LOGO
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB89261).withOpacity(.15),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Color(0xFFB89261),
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Theologia",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB89261),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "STUDY THE WORD",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Color(0xFFB89261),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const SizedBox(height: 30),

                    /// EMAIL
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "EMAIL ADDRESS",
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1,
                          color: Color(0xFFB89261),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    _inputField(
                      controller: _emailController,
                      hint: "john@gmail.com",
                    ),

                    const SizedBox(height: 18),

                    /// PASSWORD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "PASSWORD",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            color: Color(0xFFB89261),
                          ),
                        ),

                        TextButton(
  onPressed: () => context.push('/forgot-password'),
  style: TextButton.styleFrom(
    foregroundColor: const Color(0xFFB89261),
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
  child: const Text(
    "Forgot?",
    style: TextStyle(
      fontSize: 12,
    ),
  ),
)
                      ],
                    ),

                    const SizedBox(height: 8),

                    _inputField(
                      controller: _passwordController,
                      hint: "••••••••",
                      isPassword: true,
                    ),

                    const SizedBox(height: 26),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB89261),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "OR LOGIN VIA",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 22),

                    /// GOOGLE LOGIN
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _handleGoogleLogin,
                            child: _socialButton("Google", Icons.mail),
                          ),
                        ),

                        const SizedBox(width: 12),

                      if (Platform.isIOS) ...[
      const SizedBox(width: 12),

      Expanded(
        child: GestureDetector(
          onTap: _handleAppleLogin,
          child: _socialButton("Apple", Icons.apple),
        ),
      )
                      ]
    ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "New to Theologia? ",
                          style: TextStyle(color: Colors.grey),
                        ),

                        TextButton(
                          onPressed: () => context.push('/create-account'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFB89261),
                            padding: EdgeInsets
                                .zero, // keeps it tight next to the text
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),

        filled: true,
        fillColor: const Color(0xFF2B2118),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _socialButton(String text, IconData icon) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3026)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),

          const SizedBox(width: 8),

          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
