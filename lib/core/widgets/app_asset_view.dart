import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mgw_eva/core/assets/app_asset_kind.dart';
import 'package:mgw_eva/core/assets/map_asset_path_resolver.dart';

class AppAssetView extends StatelessWidget {
  const AppAssetView({
    required this.assetPath,
    required this.assetKind,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  final String assetPath;
  final AppAssetKind assetKind;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final String normalizedPath = assetKind == AppAssetKind.map
        ? MapAssetPathResolver.normalize(assetPath)
        : assetPath.trim();
    debugPrint('[AppAssetView] kind=${assetKind.name} path="$normalizedPath"');

    if (normalizedPath.isEmpty) {
      return _AssetFallbackView(
        assetKind: assetKind,
        title: assetKind.emptyTitle,
        subtitle: assetKind.emptySubtitle,
        borderRadius: borderRadius,
        width: width,
        height: height,
      );
    }

    final Widget child;
    if (_isSvgPath(normalizedPath)) {
      child = SvgPicture.asset(
        normalizedPath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              debugPrint(
                '[AppAssetView] svg load failed kind=${assetKind.name} '
                'path="$normalizedPath" error=$error',
              );
              return _AssetFallbackView(
                assetKind: assetKind,
                title: assetKind.errorTitle,
                subtitle: assetKind.errorSubtitle,
                borderRadius: borderRadius,
                width: width,
                height: height,
              );
            },
      );
    } else if (_isRasterPath(normalizedPath)) {
      child = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          debugPrint(
            '[AppAssetView] raster layout kind=${assetKind.name} '
            'path="$normalizedPath" constraints='
            '${constraints.maxWidth}x${constraints.maxHeight}',
          );
          return Image(
            image: AssetImage(normalizedPath),
            fit: fit,
            width: width,
            height: height,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            frameBuilder:
                (
                  BuildContext context,
                  Widget child,
                  int? frame,
                  bool wasSynchronouslyLoaded,
                ) {
                  debugPrint(
                    '[AppAssetView] raster frame kind=${assetKind.name} '
                    'path="$normalizedPath" frame=$frame '
                    'sync=$wasSynchronouslyLoaded',
                  );
                  return child;
                },
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  debugPrint(
                    '[AppAssetView] raster loading kind=${assetKind.name} '
                    'path="$normalizedPath" progress='
                    '${loadingProgress?.cumulativeBytesLoaded ?? 'done'}',
                  );
                  return child;
                },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  debugPrint(
                    '[AppAssetView] raster load failed kind=${assetKind.name} '
                    'path="$normalizedPath" error=$error',
                  );
                  return _AssetFallbackView(
                    assetKind: assetKind,
                    title: assetKind.errorTitle,
                    subtitle: assetKind.errorSubtitle,
                    borderRadius: borderRadius,
                    width: width,
                    height: height,
                  );
                },
          );
        },
      );
    } else {
      child = Image.asset(
        normalizedPath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              debugPrint(
                '[AppAssetView] asset load failed kind=${assetKind.name} '
                'path="$normalizedPath" error=$error',
              );
              return _AssetFallbackView(
                assetKind: assetKind,
                title: assetKind.errorTitle,
                subtitle: assetKind.errorSubtitle,
                borderRadius: borderRadius,
                width: width,
                height: height,
              );
            },
      );
    }

    if (borderRadius == null) {
      return child;
    }

    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  bool _isSvgPath(String value) {
    return value.toLowerCase().endsWith('.svg');
  }

  bool _isRasterPath(String value) {
    final String lowerCaseValue = value.toLowerCase();

    return lowerCaseValue.endsWith('.png') ||
        lowerCaseValue.endsWith('.jpg') ||
        lowerCaseValue.endsWith('.jpeg');
  }
}

class _AssetFallbackView extends StatelessWidget {
  const _AssetFallbackView({
    required this.assetKind,
    required this.title,
    required this.subtitle,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final AppAssetKind assetKind;
  final String title;
  final String subtitle;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool usesSvgPlaceholder =
        assetKind != AppAssetKind.map &&
        _isSvgPath(assetKind.placeholderAssetPath);

    final Widget content = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.surfaceContainerHighest.withAlpha(150),
            const Color(0xFF15202A),
          ],
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (usesSvgPlaceholder)
              IgnorePointer(
                child: Opacity(
                  opacity: 0.55,
                  child: SvgPicture.asset(
                    assetKind.placeholderAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          debugPrint(
                            '[AppAssetView] placeholder missing kind=${assetKind.name} '
                            'path="${assetKind.placeholderAssetPath}" error=$error',
                          );
                          return const SizedBox.shrink();
                        },
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(assetKind.icon, size: 36, color: colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (borderRadius == null) {
      return content;
    }

    return ClipRRect(borderRadius: borderRadius!, child: content);
  }
}

bool _isSvgPath(String value) {
  return value.toLowerCase().endsWith('.svg');
}
