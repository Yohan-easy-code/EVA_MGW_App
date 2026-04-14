import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

extension PlanElementDataMapper on db.PlanElement {
  PlanElement toDomain() {
    return PlanElement(
      id: id,
      battlePlanId: battlePlanId,
      type: type,
      x: x,
      y: y,
      width: width,
      height: height,
      rotation: rotation,
      color: color,
      label: label,
      extraJson: extraJson,
    );
  }
}
