import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TertiaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String majortopic;

  const TertiaryAppbar({
    super.key,
    required this.majortopic,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,

      systemOverlayStyle: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.colorScheme.onSurface,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Text(
        majortopic,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),

      centerTitle: false,
    );
  }
}