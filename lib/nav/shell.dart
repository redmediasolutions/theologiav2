import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:theologia_app_1/main.dart';
import 'package:theologia_app_1/widgets/mini_player.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String? lastMediaId;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);

    return Scaffold(
      body: Stack(
  children: [
    widget.child,

  ValueListenableBuilder<bool>(
  valueListenable: miniPlayerDismissed,
  builder: (context, dismissed, _) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final media = snapshot.data;

        if (media == null || dismissed) {
          return const SizedBox();
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: Dismissible(
            key: ValueKey(media.id),
            direction: DismissDirection.down,
            onDismissed: (_) async {
              miniPlayerDismissed.value = true;
              await audioHandler.stop();
            },
            child: MiniAudioPlayer(audioHandler: audioHandler),
          ),
        );
      },
    );
  },
)
  ],
),

      bottomNavigationBar: _buildBottomNav(currentIndex),
    );
  }

  Widget _buildBottomNav(int currentIndex) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.surface,
      showSelectedLabels: true,
      showUnselectedLabels: true,

      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurface.withOpacity(0.6),

      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),

      selectedIconTheme: const IconThemeData(size: 18),
      unselectedIconTheme: const IconThemeData(size: 18),

      currentIndex: currentIndex,

      onTap: (index) {
        HapticFeedback.selectionClick();

        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/search');
            break;
          case 2:
            context.go('/foryoupage');
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
            icon: Icons.menu_book_sharp,
            index: 0,
            currentIndex: currentIndex,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: _PressIcon(
            icon: Icons.search,
            index: 1,
            currentIndex: currentIndex,
          ),
          label: "Search",
        ),
         BottomNavigationBarItem(
          icon: _PressIcon(
            icon: Icons.recent_actors,
            index: 2,
            currentIndex: currentIndex,
          ),
          label: "For You",
        ),
        BottomNavigationBarItem(
          icon: _PressIcon(
            icon: Icons.self_improvement_outlined,
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
    );
  }

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location == '/' || location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/foryoupage')) return 2;
    if (location.startsWith('/devotions')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
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

