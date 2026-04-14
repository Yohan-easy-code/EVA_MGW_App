import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

abstract interface class PlanElementRepository {
  Stream<List<PlanElement>> watchPlanElements(int battlePlanId);

  Future<List<PlanElement>> getPlanElements(int battlePlanId);

  Future<PlanElement?> getPlanElementById(int id);

  Future<int> createPlanElement({
    required int battlePlanId,
    required String type,
    required double x,
    required double y,
    required double width,
    required double height,
    required double rotation,
    required int color,
    String? label,
    String? extraJson,
  });

  Future<bool> updatePlanElement(PlanElement planElement);

  Future<bool> deletePlanElement(int id);

  Future<int> deleteForBattlePlan(int battlePlanId);
}
