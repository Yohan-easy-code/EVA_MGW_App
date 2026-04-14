import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/data/mappers/plan_element_mapper.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/plan_element_repository.dart';

class DriftPlanElementRepository implements PlanElementRepository {
  DriftPlanElementRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<PlanElement>> watchPlanElements(int battlePlanId) {
    final query = _database.select(_database.planElements)
      ..where(
        (db.$PlanElementsTable table) =>
            table.battlePlanId.equals(battlePlanId),
      )
      ..orderBy(<OrderClauseGenerator<db.$PlanElementsTable>>[
        (db.$PlanElementsTable table) =>
            OrderingTerm(expression: table.id, mode: OrderingMode.asc),
      ]);

    return query.watch().map(
      (List<db.PlanElement> rows) => rows
          .map((db.PlanElement row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<List<PlanElement>> getPlanElements(int battlePlanId) {
    final query = _database.select(_database.planElements)
      ..where(
        (db.$PlanElementsTable table) =>
            table.battlePlanId.equals(battlePlanId),
      )
      ..orderBy(<OrderClauseGenerator<db.$PlanElementsTable>>[
        (db.$PlanElementsTable table) =>
            OrderingTerm(expression: table.id, mode: OrderingMode.asc),
      ]);

    return query.get().then(
      (List<db.PlanElement> rows) => rows
          .map((db.PlanElement row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<PlanElement?> getPlanElementById(int id) {
    return (_database.select(_database.planElements)
          ..where((db.$PlanElementsTable table) => table.id.equals(id)))
        .getSingleOrNull()
        .then((db.PlanElement? row) => row?.toDomain());
  }

  @override
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
  }) {
    return _database
        .into(_database.planElements)
        .insert(
          db.PlanElementsCompanion.insert(
            battlePlanId: battlePlanId,
            type: type.trim(),
            x: x,
            y: y,
            width: width,
            height: height,
            rotation: Value<double>(rotation),
            color: color,
            label: Value<String?>(label?.trim()),
            extraJson: Value<String?>(extraJson),
          ),
        );
  }

  @override
  Future<bool> updatePlanElement(PlanElement planElement) {
    return (_database.update(_database.planElements)..where(
          (db.$PlanElementsTable table) => table.id.equals(planElement.id),
        ))
        .write(
          db.PlanElementsCompanion(
            battlePlanId: Value<int>(planElement.battlePlanId),
            type: Value<String>(planElement.type.trim()),
            x: Value<double>(planElement.x),
            y: Value<double>(planElement.y),
            width: Value<double>(planElement.width),
            height: Value<double>(planElement.height),
            rotation: Value<double>(planElement.rotation),
            color: Value<int>(planElement.color),
            label: Value<String?>(planElement.label?.trim()),
            extraJson: Value<String?>(planElement.extraJson),
          ),
        )
        .then((int rows) => rows > 0);
  }

  @override
  Future<bool> deletePlanElement(int id) {
    return (_database.delete(_database.planElements)
          ..where((db.$PlanElementsTable table) => table.id.equals(id)))
        .go()
        .then((int rows) => rows > 0);
  }

  @override
  Future<int> deleteForBattlePlan(int battlePlanId) {
    return (_database.delete(_database.planElements)..where(
          (db.$PlanElementsTable table) =>
              table.battlePlanId.equals(battlePlanId),
        ))
        .go();
  }
}
