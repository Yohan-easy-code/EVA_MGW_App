import 'package:flutter/material.dart';
import 'package:mgw_eva/core/assets/app_asset_kind.dart';
import 'package:mgw_eva/core/widgets/app_asset_view.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_canvas_viewport.dart';
import 'package:mgw_eva/features/battleplans/presentation/painters/battle_plan_grid_painter.dart';

class BattlePlanCanvasSurface extends StatelessWidget {
  const BattlePlanCanvasSurface({
    required this.mapAsset,
    required this.viewport,
    required this.onBackgroundTap,
    super.key,
  });

  final MapAsset mapAsset;
  final BattlePlanCanvasViewport viewport;
  final VoidCallback onBackgroundTap;

  static const bool _debugMapChrome = bool.fromEnvironment(
    'DEBUG_BATTLEPLAN_MAP_CHROME',
    defaultValue: true,
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    debugPrint(
      '[BattlePlanCanvasSurface] map="${mapAsset.imagePath}" '
      'rect=${viewport.mapRect} rendered=${viewport.renderedMapSize} '
      'layers=debug-bg>image>grid>tag',
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // The map surface must stay passive for drags. Only tap-to-clear is
      // handled here so element gestures above always keep priority.
      onTap: onBackgroundTap,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fromRect(
            rect: viewport.mapRect,
            child: SizedBox(
              width: viewport.renderedMapSize.width,
              height: viewport.renderedMapSize.height,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color(0xFF10314A), Color(0xFF1E5F3F)],
                        ),
                        border: _debugMapChrome
                            ? Border.all(
                                color: const Color(0xFFFFC857),
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: _debugMapChrome
                            ? Border.all(
                                color: const Color(0xFF12E0A0),
                                width: 2,
                              )
                            : null,
                      ),
                      child: AppAssetView(
                        key: ValueKey<String>(
                          '${mapAsset.id}:${mapAsset.imagePath}',
                        ),
                        assetPath: mapAsset.imagePath,
                        assetKind: AppAssetKind.map,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.all(viewport.scale > 0.75 ? 4 : 3),
                        child: CustomPaint(
                          painter: BattlePlanGridPainter(
                            lineColor: colorScheme.outlineVariant.withAlpha(22),
                            boldLineColor: colorScheme.outlineVariant.withAlpha(
                              52,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _CanvasTag(label: mapAsset.displayName),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CanvasTag extends StatelessWidget {
  const _CanvasTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(145),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
