import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';

abstract interface class BattlePlanRepository {
  Stream<List<BattlePlan>> watchBattlePlans();

  Future<List<BattlePlan>> getBattlePlans();

  Future<BattlePlan?> getBattlePlanById(int id);

  Future<BattlePlan?> getBattlePlanByNameAndMapId({
    required String name,
    required int mapId,
  });

  Future<int> createBattlePlan({required String name, required int mapId});

  Future<bool> updateBattlePlan(BattlePlan battlePlan);

  Future<bool> deleteBattlePlan(int id);
}
