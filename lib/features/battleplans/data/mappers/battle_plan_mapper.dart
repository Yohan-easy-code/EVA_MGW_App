import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';

extension BattlePlanDataMapper on db.BattlePlan {
  BattlePlan toDomain() {
    return BattlePlan(
      id: id,
      name: name,
      mapId: mapId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
