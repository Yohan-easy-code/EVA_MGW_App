import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/player_vision_settings.dart';
import 'package:mgw_eva/features/battleplans/logic/player_vision_codec.dart';
import 'package:mgw_eva/features/battleplans/logic/player_vision_service.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_canvas_viewport.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/player_vision_render_data.dart';
import 'package:mgw_eva/features/battleplans/presentation/painters/player_vision_painter.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_view_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanPlayerVisionLayer extends StatelessWidget {
  const BattlePlanPlayerVisionLayer({
    required this.viewport,
    required this.renderElements,
    required this.viewState,
    required this.isReadOnly,
    super.key,
  });

  final BattlePlanCanvasViewport viewport;
  final List<BattlePlanRenderElement> renderElements;
  final BattlePlanEditorViewState viewState;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final List<(PlayerVisionRenderData, PlayerVisionResult)> visionResults =
        <(PlayerVisionRenderData, PlayerVisionResult)>[];

    for (final BattlePlanRenderElement renderElement in renderElements) {
      final PlanElement element = renderElement.element;
      final PlanElementType? type = PlanElementType.fromStorageKey(
        element.type,
      );
      if (type != PlanElementType.player) {
        continue;
      }

      final Offset position = isReadOnly
          ? Offset(element.x, element.y)
          : viewState.positionFor(element);
      final Size size = isReadOnly
          ? Size(element.width, element.height)
          : viewState.sizeFor(element);
      final double rotation = isReadOnly
          ? element.rotation
          : viewState.rotationFor(element);
      final PlayerVisionSettings settings = PlayerVisionCodec.fromExtraJson(
        element.extraJson,
      );

      if (!settings.showAimLine && !settings.showVisionCone) {
        continue;
      }

      final PlayerVisionRenderData data = PlayerVisionRenderData(
        origin: Offset(
          position.dx + size.width / 2,
          position.dy + size.height / 2,
        ),
        rotation: rotation,
        range: settings.visionRange,
        fovDegrees: settings.visionFovDegrees,
        color: Color(element.color),
        showCone: settings.showVisionCone,
        showAimLine: settings.showAimLine,
        isSelected: !isReadOnly && viewState.isSelected(element),
      );

      final PlayerVisionResult result = PlayerVisionService.compute(
        origin: data.origin,
        angle: data.rotation,
        range: data.range,
        fovDegrees: data.fovDegrees,
      );
      visionResults.add((data, result));
    }

    return Positioned.fromRect(
      rect: viewport.mapRect,
      child: IgnorePointer(
        child: visionResults.isEmpty
            ? const SizedBox.expand()
            : RepaintBoundary(
                child: CustomPaint(
                  size: viewport.renderedMapSize,
                  painter: PlayerVisionPainter(
                    viewport: viewport,
                    visionResults: visionResults,
                  ),
                ),
              ),
      ),
    );
  }
}
