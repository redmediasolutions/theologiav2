import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesButton extends StatelessWidget {
  final String topic;
  final String id;
  final String iconPath;

  const CategoriesButton({
    super.key,
    required this.topic,
    required this.id,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 100,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                context.push('/collection/$id', extra: topic);
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colors.primaryContainer,
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: iconPath.isNotEmpty
                        ? SvgPicture.asset(
                            iconPath,
                            width: 36,
                            height: 36,
                            colorFilter: ColorFilter.mode(
                              colors.primary,
                              BlendMode.srcIn,
                            ),
                            placeholderBuilder: (context) => const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.menu_book,
                                size: 32,
                                color: colors.primary,
                              );
                            },
                          )
                        : Icon(
                            Icons.menu_book,
                            size: 32,
                            color: colors.primary,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            topic,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
