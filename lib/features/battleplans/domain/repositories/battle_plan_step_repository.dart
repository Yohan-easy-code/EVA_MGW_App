import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';

abstract interface class BattlePlanStepRepository {
  Stream<List<BattlePlanStep>> watchSteps(int battlePlanId);

  Future<List<BattlePlanStep>> getSteps(int battlePlanId);

  Future<BattlePlanStep?> getStepById(int id);

  Future<int> createStep({
    required int battlePlanId,
    required String title,
    required int orderIndex,
  });

  Future<bool> updateStep(BattlePlanStep step);

  Future<bool> deleteStep(int id);
}
