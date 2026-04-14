import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plans_table.dart';

class BattlePlanSteps extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get battlePlanId => integer()
      .named('battle_plan_id')
      .references(BattlePlans, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text().withLength(min: 1, max: 120)();

  IntColumn get orderIndex => integer()
      .named('order_index')
      .customConstraint('NOT NULL CHECK ("order_index" >= 0)')();

  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}
