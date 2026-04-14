import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_canvas_viewport.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/player_render_metrics.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/plan_element_view.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/player_aim_indicator.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_view_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanElementGestureLayer extends StatelessWidget {
  const BattlePlanElementGestureLayer({
    required this.renderElement,
    required this.viewport,
    required this.viewState,
    required this.isReadOnly,
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

  final BattlePlanRenderElement renderElement;
  final BattlePlanCanvasViewport viewport;
  final BattlePlanEditorViewState viewState;
  final bool isReadOnly;
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

  @override
  Widget build(BuildContext context) {
    final PlanElement element = renderElement.element;
    final PlanElementType? type = PlanElementType.fromStorageKey(element.type);
    final Offset logicalPosition = isReadOnly
        ? Offset(element.x, element.y)
        : viewState.positionFor(element);
    final Size logicalSize = isReadOnly
        ? Size(element.width, element.height)
        : viewState.sizeFor(element);
    final double logicalRotation = isReadOnly
        ? element.rotation
        : viewState.rotationFor(element);
    final bool isSelected = !isReadOnly && viewState.isSelected(element);
    final bool isZoneCircle = type == PlanElementType.zoneCircle;
    final bool isPlayer = type == PlanElementType.player;

    final Offset screenPosition = viewport.toViewportOffset(logicalPosition);
    final Size screenSize = viewport.toViewportSize(logicalSize);
    final PlayerRenderMetrics? playerMetrics = isPlayer
        ? PlayerRenderMetrics.fromSize(screenSize)
        : null;
    final double interactionWidth = isPlayer && isSelected
        ? math.max(screenSize.width, playerMetrics!.aimExtent * 2)
        : isZoneCircle && isSelected
        ? screenSize.width + 40
        : screenSize.width;
    final double interactionHeight = isPlayer && isSelected
        ? math.max(screenSize.height, playerMetrics!.aimExtent * 2)
        : isZoneCircle && isSelected
        ? screenSize.height + 24
        : screenSize.height;
    final Offset interactionTopLeft = Offset(
      screenPosition.dx - (interactionWidth - screenSize.width) / 2,
      screenPosition.dy - (interactionHeight - screenSize.height) / 2,
    );
    final Rect bodyRect = Rect.fromCenter(
      center: Offset(interactionWidth / 2, interactionHeight / 2),
      width: screenSize.width,
      height: screenSize.height,
    );

    return Positioned(
      left: interactionTopLeft.dx,
      top: interactionTopLeft.dy,
      child: Builder(
        builder: (BuildContext interactionContext) {
          return SizedBox(
            width: interactionWidth,
            height: interactionHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fromRect(
                  rect: bodyRect,
                  child: _ElementBodyGestureTarget(
                    element: element,
                    screenSize: screenSize,
                    rotation: logicalRotation,
                    isSelected: isSelected,
                    isDragging: !isReadOnly && viewState.isDragging(element),
                    opacity: renderElement.opacity,
                    canMove: !isReadOnly && !isZoneCircle,
                    onSelect: () => onSelectElement(element.id),
                    onStartDragging: () => onStartDragging(element.id),
                    onUpdateDragging: (Offset delta) => onUpdateDragging(
                      element,
                      viewport.toLogicalVector(delta),
                    ),
                    onCommitDragging: () => onCommitDragging(element),
                    onCancelDragging: () => onCancelDragging(element),
                  ),
                ),
                if (isPlayer)
                  Positioned(
                    left: interactionWidth / 2 - playerMetrics!.aimExtent,
                    top: interactionHeight / 2 - playerMetrics.aimExtent,
                    // Rotation stays above the body target so the aim handle
                    // wins the gesture arena before move drags can start.
                    child: PlayerAimIndicator(
                      angle: logicalRotation,
                      metrics: playerMetrics,
                      color: Color(element.color),
                      showHandle: isSelected && !isReadOnly,
                      onStartRotating: isReadOnly
                          ? null
                          : () => onStartRotating(element.id),
                      onUpdateRotating: isReadOnly
                          ? null
                          : (Offset globalPosition) {
                              final RenderBox? box =
                                  interactionContext.findRenderObject()
                                      as RenderBox?;
                              if (box == null || !box.hasSize) {
                                return;
                              }

                              final Offset localPointer = box.globalToLocal(
                                globalPosition,
                              );
                              final Offset logicalPointer = viewport
                                  .toLogicalPoint(
                                    interactionTopLeft + localPointer,
                                  );

                              onUpdateRotating(element, logicalPointer);
                            },
                      onCommitRotating: isReadOnly
                          ? null
                          : () => onCommitRotating(element),
                      onCancelRotating: isReadOnly
                          ? null
                          : () => onCancelRotating(element),
                    ),
                  ),
                if (isZoneCircle && isSelected)
                  Positioned.fromRect(
                    rect: bodyRect.inflate(16),
                    // Resize and move handles are layered above the element
                    // body so circle editing never falls through.
                    child: _ZoneCircleHandles(
                      onStartDragging: isReadOnly
                          ? null
                          : () => onStartDragging(element.id),
                      onUpdateDragging: isReadOnly
                          ? null
                          : (Offset delta) => onUpdateDragging(
                              element,
                              viewport.toLogicalVector(delta),
                            ),
                      onCommitDragging: isReadOnly
                          ? null
                          : () => onCommitDragging(element),
                      onCancelDragging: isReadOnly
                          ? null
                          : () => onCancelDragging(element),
                      onStartResizing: isReadOnly
                          ? null
                          : () => onStartResizing(element.id),
                      onUpdateResizing: isReadOnly
                          ? null
                          : (Offset delta) => onUpdateResizing(
                              element,
                              viewport.toLogicalVector(delta),
                            ),
                      onCommitResizing: isReadOnly
                          ? null
                          : () => onCommitResizing(element),
                      onCancelResizing: isReadOnly
                          ? null
                          : () => onCancelResizing(element),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ElementBodyGestureTarget extends StatelessWidget {
  const _ElementBodyGestureTarget({
    required this.element,
    required this.screenSize,
    required this.rotation,
    required this.isSelected,
    required this.isDragging,
    required this.opacity,
    required this.canMove,
    required this.onSelect,
    required this.onStartDragging,
    required this.onUpdateDragging,
    required this.onCommitDragging,
    required this.onCancelDragging,
  });

  final PlanElement element;
  final Size screenSize;
  final double rotation;
  final bool isSelected;
  final bool isDragging;
  final double opacity;
  final bool canMove;
  final VoidCallback onSelect;
  final VoidCallback onStartDragging;
  final ValueChanged<Offset> onUpdateDragging;
  final VoidCallback onCommitDragging;
  final VoidCallback onCancelDragging;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      // The body handles selection and move only. The map surface behind it
      // is tap-only, so background drags can never steal element gestures.
      onPanStart: canMove ? (_) => onStartDragging() : null,
      onPanUpdate: canMove
          ? (DragUpdateDetails details) => onUpdateDragging(details.delta)
          : null,
      onPanEnd: canMove ? (_) => onCommitDragging() : null,
      onPanCancel: canMove ? onCancelDragging : null,
      child: RepaintBoundary(
        child: PlanElementView(
          element: element.copyWith(
            width: screenSize.width,
            height: screenSize.height,
            rotation: rotation,
          ),
          isSelected: isSelected,
          isDragging: isDragging,
          opacity: opacity,
        ),
      ),
    );
  }
}

class _ZoneCircleHandles extends StatelessWidget {
  const _ZoneCircleHandles({
    required this.onStartDragging,
    required this.onUpdateDragging,
    required this.onCommitDragging,
    required this.onCancelDragging,
    required this.onStartResizing,
    required this.onUpdateResizing,
    required this.onCommitResizing,
    required this.onCancelResizing,
  });

  final VoidCallback? onStartDragging;
  final ValueChanged<Offset>? onUpdateDragging;
  final VoidCallback? onCommitDragging;
  final VoidCallback? onCancelDragging;
  final VoidCallback? onStartResizing;
  final ValueChanged<Offset>? onUpdateResizing;
  final VoidCallback? onCommitResizing;
  final VoidCallback? onCancelResizing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: _CircleHandle(
            icon: BattlePlanEditorIcons.move,
            onPanStart: onStartDragging == null
                ? null
                : (_) => onStartDragging!(),
            onPanUpdate: onUpdateDragging == null
                ? null
                : (DragUpdateDetails details) =>
                      onUpdateDragging!(details.delta),
            onPanEnd: onCommitDragging == null
                ? null
                : (_) => onCommitDragging!(),
            onPanCancel: onCancelDragging,
          ),
        ),
        Positioned(
          right: -14,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: _CircleHandle(
              icon: BattlePlanEditorIcons.resize,
              accentColor: Theme.of(context).colorScheme.secondary,
              onPanStart: onStartResizing == null
                  ? null
                  : (_) => onStartResizing!(),
              onPanUpdate: onUpdateResizing == null
                  ? null
                  : (DragUpdateDetails details) =>
                        onUpdateResizing!(details.delta),
              onPanEnd: onCommitResizing == null
                  ? null
                  : (_) => onCommitResizing!(),
              onPanCancel: onCancelResizing,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleHandle extends StatelessWidget {
  const _CircleHandle({
    required this.icon,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPanCancel,
    this.accentColor,
  });

  final IconData icon;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final VoidCallback? onPanCancel;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color color = accentColor ?? colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withAlpha(235),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(220), width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
