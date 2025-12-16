import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);

    return Scaffold(
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,

        selectedItemColor: const Color(0xFFbc9a73),
        unselectedItemColor: const Color(0xFF7f7f7f),

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),

        selectedIconTheme: const IconThemeData(size: 18),
        unselectedIconTheme: const IconThemeData(size: 18),

        currentIndex: currentIndex,

        onTap: (index) {
          // 🔹 Light haptic feedback (no ripple)
          HapticFeedback.selectionClick();

          switch (index) {
            case 0:
              context.go('/category');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/');
              break;
            case 3:
              context.go('/devotions');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: _PressIcon(
              icon: Icons.grid_on_outlined,
              index: 0,
              currentIndex: currentIndex,
            ),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: _PressIcon(
              icon: Icons.category,
              index: 1,
              currentIndex: currentIndex,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: _PressIcon(
              icon: Icons.menu_book_sharp,
              index: 2,
              currentIndex: currentIndex,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _PressIcon(
              icon: Icons.headphones,
              index: 3,
              currentIndex: currentIndex,
            ),
            label: "Devotions",
          ),
          BottomNavigationBarItem(
            icon: _PressIcon(
              icon: Icons.person_2_outlined,
              index: 4,
              currentIndex: currentIndex,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/category')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location == '/' || location.startsWith('/home')) return 2;
    if (location.startsWith('/devotions')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 2; // fallback to Home
  }
}

/// 🔹 Press / bounce icon (NO ripple, NO ink)
class _PressIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;

  const _PressIcon({
    required this.icon,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return AnimatedScale(
      scale: isSelected ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.85,
        duration: const Duration(milliseconds: 120),
        child: Icon(icon),
      ),
    );
  }
}