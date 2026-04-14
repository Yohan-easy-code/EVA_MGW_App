import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/data/mappers/battle_plan_step_mapper.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_repository.dart';

class DriftBattlePlanStepRepository implements BattlePlanStepRepository {
  DriftBattlePlanStepRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<BattlePlanStep>> watchSteps(int battlePlanId) {
    final query = _database.select(_database.battlePlanSteps)
      ..where(
        (db.$BattlePlanStepsTable table) =>
            table.battlePlanId.equals(battlePlanId),
      )
      ..orderBy(<OrderClauseGenerator<db.$BattlePlanStepsTable>>[
        (db.$BattlePlanStepsTable table) =>
            OrderingTerm(expression: table.orderIndex, mode: OrderingMode.asc),
      ]);

    return query.watch().map(
      (List<db.BattlePlanStep> rows) => rows
          .map((db.BattlePlanStep row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<List<BattlePlanStep>> getSteps(int battlePlanId) {
    final query = _database.select(_database.battlePlanSteps)
      ..where(
        (db.$BattlePlanStepsTable table) =>
            table.battlePlanId.equals(battlePlanId),
      )
      ..orderBy(<OrderClauseGenerator<db.$BattlePlanStepsTable>>[
        (db.$BattlePlanStepsTable table) =>
            OrderingTerm(expression: table.orderIndex, mode: OrderingMode.asc),
      ]);

    return query.get().then(
      (List<db.BattlePlanStep> rows) => rows
          .map((db.BattlePlanStep row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<BattlePlanStep?> getStepById(int id) {
    return (_database.select(_database.battlePlanSteps)
          ..where((db.$BattlePlanStepsTable table) => table.id.equals(id)))
        .getSingleOrNull()
        .then((db.BattlePlanStep? row) => row?.toDomain());
  }

  @override
  Future<int> createStep({
    required int battlePlanId,
    required String title,
    required int orderIndex,
  }) {
    final DateTime now = DateTime.now().toUtc();

    return _database
        .into(_database.battlePlanSteps)
        .insert(
          db.BattlePlanStepsCompanion.insert(
            battlePlanId: battlePlanId,
            title: title.trim(),
            orderIndex: orderIndex,
            createdAt: Value<DateTime>(now),
            updatedAt: Value<DateTime>(now),
          ),
        );
  }

  @override
  Future<bool> updateStep(BattlePlanStep step) {
    return (_database.update(_database.battlePlanSteps)
          ..where((db.$BattlePlanStepsTable table) => table.id.equals(step.id)))
        .write(
          db.BattlePlanStepsCompanion(
            battlePlanId: Value<int>(step.battlePlanId),
            title: Value<String>(step.title.trim()),
            orderIndex: Value<int>(step.orderIndex),
            updatedAt: Value<DateTime>(DateTime.now().toUtc()),
          ),
        )
        .then((int rows) => rows > 0);
  }

  @override
  Future<bool> deleteStep(int id) {
    return (_database.delete(_database.battlePlanSteps)
          ..where((db.$BattlePlanStepsTable table) => table.id.equals(id)))
        .go()
        .then((int rows) => rows > 0);
  }
}
