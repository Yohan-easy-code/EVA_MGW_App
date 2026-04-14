import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';

class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({
    this.size = 56,
    this.borderRadius,
    this.backgroundColor,
    super.key,
  });

  final double size;
  final double? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double effectiveRadius = borderRadius ?? size * 0.22;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Image.asset(
          AssetPaths.logo,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (BuildContext context, Object error, StackTrace? _) {
            return SizedBox(
              width: size,
              height: size,
              child: Icon(
                Icons.broken_image_outlined,
                size: size * 0.5,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}
