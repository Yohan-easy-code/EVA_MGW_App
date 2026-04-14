import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plan_steps_table.dart';
import 'package:mgw_eva/data/local/db/tables/plan_elements_table.dart';

class BattlePlanStepElementStates extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get stepId => integer()
      .named('step_id')
      .references(BattlePlanSteps, #id, onDelete: KeyAction.cascade)();

  IntColumn get planElementId => integer()
      .named('plan_element_id')
      .references(PlanElements, #id, onDelete: KeyAction.cascade)();

  RealColumn get x => real()();

  RealColumn get y => real()();

  RealColumn get width =>
      real().customConstraint('NOT NULL CHECK ("width" >= 0)')();

  RealColumn get height =>
      real().customConstraint('NOT NULL CHECK ("height" >= 0)')();

  RealColumn get rotation => real().withDefault(const Constant(0))();

  IntColumn get color => integer()();

  TextColumn get label => text().nullable().withLength(min: 0, max: 120)();

  BoolColumn get isVisible =>
      boolean().named('is_visible').withDefault(const Constant(true))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{stepId, planElementId},
  ];
}
