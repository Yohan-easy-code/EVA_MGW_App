import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_canvas_viewport.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_canvas_surface.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_element_gesture_layer.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_player_vision_layer.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_view_state.dart';

class BattlePlanCanvas extends StatelessWidget {
  const BattlePlanCanvas({
    required this.mapAsset,
    required this.renderElements,
    required this.viewState,
    required this.isReadOnly,
    required this.onBackgroundTap,
    required this.onSelectElement,
    required this.onStartDragging,
    required this.onUpdateDragging,
    required this.onCommitDragging,
    required this.onCancelDragging,
    required this.onStartResizing,
    required this.onUpdateResizing,
    required this.onCommitResizing,
    required this.onCancelResizing,
    required this.onStartRotating,
    required this.onUpdateRotating,
    required this.onCommitRotating,
    required this.onCancelRotating,
    super.key,
  });

  final MapAsset mapAsset;
  final List<BattlePlanRenderElement> renderElements;
  final BattlePlanEditorViewState viewState;
  final bool isReadOnly;
  final VoidCallback onBackgroundTap;
  final ValueChanged<int> onSelectElement;
  final ValueChanged<int> onStartDragging;
  final void Function(PlanElement element, Offset delta) onUpdateDragging;
  final ValueChanged<PlanElement> onCommitDragging;
  final ValueChanged<PlanElement> onCancelDragging;
  final ValueChanged<int> onStartResizing;
  final void Function(PlanElement element, Offset delta) onUpdateResizing;
  final ValueChanged<PlanElement> onCommitResizing;
  final ValueChanged<PlanElement> onCancelResizing;
  final ValueChanged<int> onStartRotating;
  final void Function(PlanElement element, Offset aimVector) onUpdateRotating;
  final ValueChanged<PlanElement> onCommitRotating;
  final ValueChanged<PlanElement> onCancelRotating;

  static const bool _debugMapOnly = bool.fromEnvironment(
    'DEBUG_BATTLEPLAN_MAP_ONLY',
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double mapWidth = mapAsset.width.toDouble();
    final double mapHeight = mapAsset.height.toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF091016), Color(0xFF111A24)],
          ),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(140)),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final BattlePlanCanvasViewport viewport =
                BattlePlanCanvasViewport.fromConstraints(
                  constraints: constraints,
                  mapWidth: mapWidth,
                  mapHeight: mapHeight,
                );
            debugPrint(
              '[BattlePlanCanvas] map="${mapAsset.imagePath}" '
              'constraints=${constraints.maxWidth}x${constraints.maxHeight} '
              'rendered=${viewport.renderedMapSize.width}x${viewport.renderedMapSize.height} '
              'rect=${viewport.mapRect} '
              'layers=image>grid>${_debugMapOnly ? 'debug-map-only' : 'vision>elements'}',
            );

            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: BattlePlanCanvasSurface(
                    mapAsset: mapAsset,
                    viewport: viewport,
                    onBackgroundTap: onBackgroundTap,
                  ),
                ),
                if (!_debugMapOnly)
                  BattlePlanPlayerVisionLayer(
                    viewport: viewport,
                    renderElements: renderElements,
                    viewState: viewState,
                    isReadOnly: isReadOnly,
                  ),
                if (!_debugMapOnly)
                  ...renderElements.map(
                    (BattlePlanRenderElement renderElement) =>
                        BattlePlanElementGestureLayer(
                          renderElement: renderElement,
                          viewport: viewport,
                          viewState: viewState,
                          isReadOnly: isReadOnly,
                          onSelectElement: onSelectElement,
                          onStartDragging: onStartDragging,
                          onUpdateDragging: onUpdateDragging,
                          onCommitDragging: onCommitDragging,
                          onCancelDragging: onCancelDragging,
                          onStartResizing: onStartResizing,
                          onUpdateResizing: onUpdateResizing,
                          onCommitResizing: onCommitResizing,
                          onCancelResizing: onCancelResizing,
                          onStartRotating: onStartRotating,
                          onUpdateRotating: onUpdateRotating,
                          onCommitRotating: onCommitRotating,
                          onCancelRotating: onCancelRotating,
                        ),
                  ),
                if (kDebugMode && _debugMapOnly)
                  const Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: IgnorePointer(
                      child: _DebugCanvasBanner(
                        label:
                            'DEBUG_BATTLEPLAN_MAP_ONLY actif: overlays desactives',
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DebugCanvasBanner extends StatelessWidget {
  const _DebugCanvasBanner({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC0B1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFC857), width: 1.4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
