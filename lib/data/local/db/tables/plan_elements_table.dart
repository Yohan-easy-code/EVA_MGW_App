import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plans_table.dart';

class PlanElements extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get battlePlanId => integer()
      .named('battle_plan_id')
      .references(BattlePlans, #id, onDelete: KeyAction.cascade)();

  TextColumn get type => text().withLength(min: 1, max: 80)();

  RealColumn get x => real()();

  RealColumn get y => real()();

  RealColumn get width =>
      real().customConstraint('NOT NULL CHECK ("width" >= 0)')();

  RealColumn get height =>
      real().customConstraint('NOT NULL CHECK ("height" >= 0)')();

  RealColumn get rotation => real().withDefault(const Constant(0))();

  IntColumn get color => integer()();

  TextColumn get label => text().nullable().withLength(min: 0, max: 120)();

  TextColumn get extraJson => text().named('extra_json').nullable()();
}
