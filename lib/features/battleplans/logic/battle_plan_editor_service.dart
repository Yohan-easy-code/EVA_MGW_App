import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/plan_element_repository.dart';
import 'package:mgw_eva/features/battleplans/logic/player_vision_codec.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

class BattlePlanEditorService {
  const BattlePlanEditorService(
    this._planElementRepository,
    this._stepElementStateRepository,
  );

  final PlanElementRepository _planElementRepository;
  final BattlePlanStepElementStateRepository _stepElementStateRepository;

  Future<void> createElement({
    required int battlePlanId,
    required int stepId,
    required PlanElementType type,
    required double mapWidth,
    required double mapHeight,
  }) async {
    final NewPlanElementDefaults defaults = type.defaults(
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );
    final String? extraJson = type == PlanElementType.player
        ? PlayerVisionCodec.defaultsJson()
        : null;

    final int createdElementId = await _planElementRepository.createPlanElement(
      battlePlanId: battlePlanId,
      type: type.storageKey,
      x: defaults.x,
      y: defaults.y,
      width: defaults.width,
      height: defaults.height,
      rotation: 0,
      color: defaults.color,
      label: defaults.label,
      extraJson: extraJson,
    );
    await _stepElementStateRepository.createStateForPlanElement(
      stepId: stepId,
      element: PlanElement(
        id: createdElementId,
        battlePlanId: battlePlanId,
        type: type.storageKey,
        x: defaults.x,
        y: defaults.y,
        width: defaults.width,
        height: defaults.height,
        rotation: 0,
        color: defaults.color,
        label: defaults.label,
        extraJson: extraJson,
      ),
    );
  }

  Future<void> updatePosition({
    required int stepId,
    required PlanElement element,
    required Offset position,
  }) async {
    await _stepElementStateRepository.updateStateFromPlanElement(
      stepId: stepId,
      element: element.copyWith(x: position.dx, y: position.dy),
    );
  }

  Future<void> updateGeometry({
    required int stepId,
    required PlanElement element,
    required Offset position,
    required Size size,
    required double rotation,
  }) async {
    await _stepElementStateRepository.updateStateFromPlanElement(
      stepId: stepId,
      element: element.copyWith(
        x: position.dx,
        y: position.dy,
        width: size.width,
        height: size.height,
        rotation: rotation,
      ),
    );
  }

  Future<void> updateAppearance({
    required int stepId,
    required PlanElement element,
    required int color,
    required String? label,
  }) async {
    await _stepElementStateRepository.updateStateFromPlanElement(
      stepId: stepId,
      element: element.copyWith(color: color, label: label),
    );
  }

  Future<void> duplicateElement({
    required int stepId,
    required PlanElement source,
    required Offset duplicatedPosition,
  }) async {
    final int createdElementId = await _planElementRepository.createPlanElement(
      battlePlanId: source.battlePlanId,
      type: source.type,
      x: duplicatedPosition.dx,
      y: duplicatedPosition.dy,
      width: source.width,
      height: source.height,
      rotation: source.rotation,
      color: source.color,
      label: source.label,
      extraJson: source.extraJson,
    );
    await _stepElementStateRepository.createStateForPlanElement(
      stepId: stepId,
      element: source.copyWith(
        id: createdElementId,
        x: duplicatedPosition.dx,
        y: duplicatedPosition.dy,
      ),
    );
  }

  Future<void> deleteElement(int id) async {
    await _planElementRepository.deletePlanElement(id);
  }
}

final battlePlanEditorServiceProvider = Provider<BattlePlanEditorService>((
  Ref ref,
) {
  return BattlePlanEditorService(
    ref.watch(planElementRepositoryProvider),
    ref.watch(battlePlanStepElementStateRepositoryProvider),
  );
});
