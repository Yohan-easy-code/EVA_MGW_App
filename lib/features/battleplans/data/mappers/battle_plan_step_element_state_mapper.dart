import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step_element_state.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

extension BattlePlanStepElementStateDataMapper
    on db.BattlePlanStepElementState {
  BattlePlanStepElementState toDomain() {
    return BattlePlanStepElementState(
      id: id,
      stepId: stepId,
      planElementId: planElementId,
      x: x,
      y: y,
      width: width,
      height: height,
      rotation: rotation,
      color: color,
      label: label,
      isVisible: isVisible,
    );
  }
}

PlanElement mapResolvedStepElement({
  required db.PlanElement element,
  required db.BattlePlanStepElementState state,
}) {
  return PlanElement(
    id: element.id,
    battlePlanId: element.battlePlanId,
    type: element.type,
    x: state.x,
    y: state.y,
    width: state.width,
    height: state.height,
    rotation: state.rotation,
    color: state.color,
    label: state.label,
    extraJson: element.extraJson,
  );
}
