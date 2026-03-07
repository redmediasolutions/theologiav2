import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _emailController = TextEditingController();
  bool _loading = false;

  Future<void> _resetPassword() async {

    if (_emailController.text.isEmpty) return;

    setState(() => _loading = true);

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent")),
      );

      context.pop();

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed")),
      );

    } finally {

      if (mounted) setState(() => _loading = false);

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1A1511),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Container(
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2B2118),
                  Color(0xFF1A1511)
                ],
              ),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(Icons.lock_reset,
                    color: Color(0xFFB89261), size: 36),

                const SizedBox(height: 16),

                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFFB89261),
                  ),
                ),

                const SizedBox(height: 28),

                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF2B2118),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(

                    onPressed: _loading ? null : _resetPassword,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB89261),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Send Reset Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: Color(0xFFB89261)),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}