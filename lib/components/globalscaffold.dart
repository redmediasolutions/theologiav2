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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,

      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.surface.withOpacity(isDark ? 0.6 : 0.7),

        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: colors.surface.withOpacity(isDark ? 0.6 : 0.75),
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
  image: AssetImage('assets/app_launcher_icon.png'),
  fit: BoxFit.cover,
),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),

            const SizedBox(width: 10),

            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.only(right: 16),

        actions: [
          IconButton(
            onPressed: () {},
            color: colors.onSurface.withOpacity(0.8),
            icon: const Icon(Icons.notifications_none),
          ),

          Container(
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceContainerHighest,
            ),
            child: IconButton(
              onPressed: () {},
              color: colors.primary,
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: body,
      ),
    );
  }
}