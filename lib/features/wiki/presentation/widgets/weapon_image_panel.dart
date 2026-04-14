import 'package:flutter/material.dart';
import 'package:mgw_eva/core/assets/app_asset_kind.dart';
import 'package:mgw_eva/core/widgets/app_asset_view.dart';

class WeaponImagePanel extends StatelessWidget {
  const WeaponImagePanel({
    required this.imagePath,
    required this.height,
    this.placeholderLabel,
    super.key,
  });

  final String imagePath;
  final double height;
  final String? placeholderLabel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[WeaponImagePanel] assetPath="$imagePath"');
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.surfaceContainerHighest.withAlpha(140),
              const Color(0xFF15202A),
            ],
          ),
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AppAssetView(
                assetPath: imagePath,
                assetKind: AppAssetKind.weapon,
                fit: BoxFit.cover,
              ),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        const Color(0xFF0A1016).withAlpha(36),
                        const Color(0xFF0A1016).withAlpha(180),
                      ],
                    ),
                  ),
                ),
              ),
              if (placeholderLabel != null &&
                  placeholderLabel!.trim().isNotEmpty)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Text(
                    placeholderLabel!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
