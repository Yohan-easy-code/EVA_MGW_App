import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';

extension BattlePlanStepDataMapper on db.BattlePlanStep {
  BattlePlanStep toDomain() {
    return BattlePlanStep(
      id: id,
      battlePlanId: battlePlanId,
      title: title,
      orderIndex: orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
