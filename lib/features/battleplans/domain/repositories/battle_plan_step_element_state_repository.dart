import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step_element_state.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

abstract interface class BattlePlanStepElementStateRepository {
  Stream<List<PlanElement>> watchStepPlanElements(int stepId);

  Future<List<PlanElement>> getStepPlanElements(int stepId);

  Future<List<BattlePlanStepElementState>> getStatesForStep(int stepId);

  Future<void> createStateForPlanElement({
    required int stepId,
    required PlanElement element,
    bool isVisible = true,
  });

  Future<void> updateStateFromPlanElement({
    required int stepId,
    required PlanElement element,
    bool isVisible = true,
  });

  Future<void> seedStepFromPlanElements({
    required int stepId,
    required List<PlanElement> elements,
  });

  Future<void> duplicateStates({
    required int fromStepId,
    required int toStepId,
  });

  Future<int> deleteStatesForStep(int stepId);
}
