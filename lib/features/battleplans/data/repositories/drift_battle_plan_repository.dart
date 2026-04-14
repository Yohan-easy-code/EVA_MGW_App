import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/data/mappers/battle_plan_mapper.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_repository.dart';

class DriftBattlePlanRepository implements BattlePlanRepository {
  DriftBattlePlanRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<BattlePlan>> watchBattlePlans() {
    final query = _database.select(_database.battlePlans)
      ..orderBy(<OrderClauseGenerator<db.$BattlePlansTable>>[
        (db.$BattlePlansTable table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch().map(
      (List<db.BattlePlan> rows) => rows
          .map((db.BattlePlan row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<List<BattlePlan>> getBattlePlans() {
    final query = _database.select(_database.battlePlans)
      ..orderBy(<OrderClauseGenerator<db.$BattlePlansTable>>[
        (db.$BattlePlansTable table) =>
            OrderingTerm(expression: table.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.get().then(
      (List<db.BattlePlan> rows) => rows
          .map((db.BattlePlan row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<BattlePlan?> getBattlePlanById(int id) {
    return (_database.select(_database.battlePlans)
          ..where((db.$BattlePlansTable table) => table.id.equals(id)))
        .getSingleOrNull()
        .then((db.BattlePlan? row) => row?.toDomain());
  }

  @override
  Future<BattlePlan?> getBattlePlanByNameAndMapId({
    required String name,
    required int mapId,
  }) {
    final String normalizedName = name.trim();

    return (_database.select(_database.battlePlans)..where(
          (db.$BattlePlansTable table) =>
              table.name.equals(normalizedName) & table.mapId.equals(mapId),
        ))
        .getSingleOrNull()
        .then((db.BattlePlan? row) => row?.toDomain());
  }

  @override
  Future<int> createBattlePlan({required String name, required int mapId}) {
    final DateTime now = DateTime.now().toUtc();

    return _database
        .into(_database.battlePlans)
        .insert(
          db.BattlePlansCompanion.insert(
            name: name.trim(),
            mapId: mapId,
            createdAt: Value<DateTime>(now),
            updatedAt: Value<DateTime>(now),
          ),
        );
  }

  @override
  Future<bool> updateBattlePlan(BattlePlan battlePlan) {
    return (_database.update(_database.battlePlans)..where(
          (db.$BattlePlansTable table) => table.id.equals(battlePlan.id),
        ))
        .write(
          db.BattlePlansCompanion(
            name: Value<String>(battlePlan.name.trim()),
            mapId: Value<int>(battlePlan.mapId),
            updatedAt: Value<DateTime>(DateTime.now().toUtc()),
          ),
        )
        .then((int rows) => rows > 0);
  }

  @override
  Future<bool> deleteBattlePlan(int id) {
    return (_database.delete(_database.battlePlans)
          ..where((db.$BattlePlansTable table) => table.id.equals(id)))
        .go()
        .then((int rows) => rows > 0);
  }
}
