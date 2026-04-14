import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_controller.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_canvas.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_playback_controls.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';

class BattlePlanEditorWorkspace extends StatelessWidget {
  const BattlePlanEditorWorkspace({
    required this.mapAsset,
    required this.renderElements,
    required this.controller,
    required this.isCompact,
    required this.playbackState,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
    super.key,
  });

  final MapAsset mapAsset;
  final List<BattlePlanRenderElement> renderElements;
  final BattlePlanEditorController controller;
  final bool isCompact;
  final BattlePlanPlaybackState playbackState;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    debugPrint(
      '[BattlePlanEditorWorkspace] activeMapId=${mapAsset.id} '
      'displayName="${mapAsset.displayName}" path="${mapAsset.imagePath}"',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isCompact ? 24 : 30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.surface.withAlpha(110),
            colorScheme.surfaceContainerHighest.withAlpha(54),
          ],
        ),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(90)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 4 : 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(60),
                borderRadius: BorderRadius.circular(isCompact ? 18 : 22),
                border: Border.all(
                  color: colorScheme.outlineVariant.withAlpha(70),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 12,
                  vertical: isCompact ? 8 : 10,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      mapAsset.displayName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const _WorkspaceBadge(
                      icon: BattlePlanEditorIcons.fixedSurface,
                      label: 'Surface fixe',
                    ),
                    _WorkspaceBadge(
                      icon: BattlePlanEditorIcons.layers,
                      label: '${renderElements.length} elements',
                    ),
                    BattlePlanPlaybackControls(
                      state: playbackState,
                      compact: isCompact,
                      onPlay: onPlay,
                      onPause: onPause,
                      onStop: onStop,
                      onPreviousStep: onPreviousStep,
                      onNextStep: onNextStep,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isCompact ? 4 : 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isCompact ? 22 : 26),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withAlpha(36),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isCompact ? 22 : 26),
                  child: BattlePlanCanvas(
                    key: ValueKey<String>(
                      '${mapAsset.id}:${mapAsset.imagePath}',
                    ),
                    mapAsset: mapAsset,
                    renderElements: renderElements,
                    viewState: controller.viewState,
                    isReadOnly: playbackState.isLocked,
                    onBackgroundTap: controller.clearSelection,
                    onSelectElement: controller.selectElement,
                    onStartDragging: controller.startDragging,
                    onUpdateDragging: (PlanElement element, Offset delta) {
                      controller.updateDragging(
                        element: element,
                        delta: delta,
                        mapWidth: mapAsset.width.toDouble(),
                        mapHeight: mapAsset.height.toDouble(),
                      );
                    },
                    onCommitDragging: controller.commitDragging,
                    onCancelDragging: controller.cancelDragging,
                    onStartResizing: controller.startResizing,
                    onUpdateResizing: (PlanElement element, Offset delta) {
                      controller.updateResizing(
                        element: element,
                        delta: delta,
                        mapWidth: mapAsset.width.toDouble(),
                        mapHeight: mapAsset.height.toDouble(),
                      );
                    },
                    onCommitResizing: controller.commitResizing,
                    onCancelResizing: controller.cancelResizing,
                    onStartRotating: controller.startRotating,
                    onUpdateRotating: (PlanElement element, Offset aimPoint) {
                      controller.updateRotating(
                        element: element,
                        aimPoint: aimPoint,
                      );
                    },
                    onCommitRotating: controller.commitRotating,
                    onCancelRotating: controller.cancelRotating,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceBadge extends StatelessWidget {
  const _WorkspaceBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(70)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: BattlePlanEditorIcons.compactIconSize,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
