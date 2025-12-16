import 'dart:ui';
import 'package:flutter/material.dart';

class Globalscaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const Globalscaffold({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),

      // 🔑 Allows content to scroll behind AppBar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0, // no solid color on scroll (Material 3 fix)

        // 🔑 Semi-transparent background
        backgroundColor: Colors.white.withOpacity(0.5),

        // 🔑 Blur effect
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ),

        titleSpacing: 16,
        centerTitle: false,

        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://theologia.in/wp-content/uploads/2025/12/For-Website.png',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE0E0E0),
                    blurRadius: 2,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
            ),
          ],
        ),
      ),

      // 🔑 Add top padding so content doesn’t hide under AppBar
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: body,
      ),
    );
  }
}