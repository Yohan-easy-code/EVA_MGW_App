import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/data/mappers/battle_plan_step_element_state_mapper.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step_element_state.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_element_state_repository.dart';

class DriftBattlePlanStepElementStateRepository
    implements BattlePlanStepElementStateRepository {
  DriftBattlePlanStepElementStateRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<PlanElement>> watchStepPlanElements(int stepId) {
    return _statesForStep(stepId).watch().asyncMap(_resolvePlanElements);
  }

  @override
  Future<List<PlanElement>> getStepPlanElements(int stepId) async {
    final List<db.BattlePlanStepElementState> states = await _statesForStep(
      stepId,
    ).get();
    return _resolvePlanElements(states);
  }

  @override
  Future<List<BattlePlanStepElementState>> getStatesForStep(int stepId) {
    return _statesForStep(stepId).get().then(
      (List<db.BattlePlanStepElementState> rows) => rows
          .map((db.BattlePlanStepElementState row) => row.toDomain())
          .toList(growable: false),
    );
  }

  @override
  Future<void> createStateForPlanElement({
    required int stepId,
    required PlanElement element,
    bool isVisible = true,
  }) async {
    await _upsertState(stepId: stepId, element: element, isVisible: isVisible);
  }

  @override
  Future<void> updateStateFromPlanElement({
    required int stepId,
    required PlanElement element,
    bool isVisible = true,
  }) async {
    await _upsertState(stepId: stepId, element: element, isVisible: isVisible);
  }

  @override
  Future<void> seedStepFromPlanElements({
    required int stepId,
    required List<PlanElement> elements,
  }) async {
    if (elements.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      batch.insertAll(
        _database.battlePlanStepElementStates,
        elements
            .map(
              (PlanElement element) =>
                  db.BattlePlanStepElementStatesCompanion.insert(
                    stepId: stepId,
                    planElementId: element.id,
                    x: element.x,
                    y: element.y,
                    width: element.width,
                    height: element.height,
                    rotation: Value<double>(element.rotation),
                    color: element.color,
                    label: Value<String?>(element.label),
                    isVisible: const Value<bool>(true),
                  ),
            )
            .toList(growable: false),
      );
    });
  }

  @override
  Future<void> duplicateStates({
    required int fromStepId,
    required int toStepId,
  }) async {
    final List<db.BattlePlanStepElementState> sourceStates =
        await _statesForStep(fromStepId).get();
    if (sourceStates.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      batch.insertAll(
        _database.battlePlanStepElementStates,
        sourceStates
            .map(
              (db.BattlePlanStepElementState state) =>
                  db.BattlePlanStepElementStatesCompanion.insert(
                    stepId: toStepId,
                    planElementId: state.planElementId,
                    x: state.x,
                    y: state.y,
                    width: state.width,
                    height: state.height,
                    rotation: Value<double>(state.rotation),
                    color: state.color,
                    label: Value<String?>(state.label),
                    isVisible: Value<bool>(state.isVisible),
                  ),
            )
            .toList(growable: false),
      );
    });
  }

  @override
  Future<int> deleteStatesForStep(int stepId) {
    return (_database.delete(_database.battlePlanStepElementStates)..where(
          (db.$BattlePlanStepElementStatesTable table) =>
              table.stepId.equals(stepId),
        ))
        .go();
  }

  SimpleSelectStatement<
    db.$BattlePlanStepElementStatesTable,
    db.BattlePlanStepElementState
  >
  _statesForStep(int stepId) {
    return _database.select(_database.battlePlanStepElementStates)
      ..where(
        (db.$BattlePlanStepElementStatesTable table) =>
            table.stepId.equals(stepId) & table.isVisible.equals(true),
      )
      ..orderBy(<OrderClauseGenerator<db.$BattlePlanStepElementStatesTable>>[
        (db.$BattlePlanStepElementStatesTable table) =>
            OrderingTerm(expression: table.id, mode: OrderingMode.asc),
      ]);
  }

  Future<List<PlanElement>> _resolvePlanElements(
    List<db.BattlePlanStepElementState> states,
  ) async {
    if (states.isEmpty) {
      return <PlanElement>[];
    }

    final List<int> planElementIds = states
        .map((db.BattlePlanStepElementState state) => state.planElementId)
        .toList(growable: false);
    final List<db.PlanElement> elementRows =
        await (_database.select(_database.planElements)..where(
              (db.$PlanElementsTable table) => table.id.isIn(planElementIds),
            ))
            .get();
    final Map<int, db.PlanElement> elementsById = <int, db.PlanElement>{
      for (final db.PlanElement element in elementRows) element.id: element,
    };

    final List<PlanElement> resolved = <PlanElement>[];
    for (final db.BattlePlanStepElementState state in states) {
      final db.PlanElement? element = elementsById[state.planElementId];
      if (element == null) {
        continue;
      }
      resolved.add(mapResolvedStepElement(element: element, state: state));
    }

    return resolved;
  }

  Future<void> _upsertState({
    required int stepId,
    required PlanElement element,
    required bool isVisible,
  }) async {
    final db.BattlePlanStepElementState? existingState =
        await (_database.select(_database.battlePlanStepElementStates)..where(
              (db.$BattlePlanStepElementStatesTable table) =>
                  table.stepId.equals(stepId) &
                  table.planElementId.equals(element.id),
            ))
            .getSingleOrNull();

    if (existingState == null) {
      await _database
          .into(_database.battlePlanStepElementStates)
          .insert(
            db.BattlePlanStepElementStatesCompanion.insert(
              stepId: stepId,
              planElementId: element.id,
              x: element.x,
              y: element.y,
              width: element.width,
              height: element.height,
              rotation: Value<double>(element.rotation),
              color: element.color,
              label: Value<String?>(element.label),
              isVisible: Value<bool>(isVisible),
            ),
          );
      return;
    }

    await (_database.update(_database.battlePlanStepElementStates)..where(
          (db.$BattlePlanStepElementStatesTable table) =>
              table.id.equals(existingState.id),
        ))
        .write(
          db.BattlePlanStepElementStatesCompanion(
            stepId: Value<int>(stepId),
            planElementId: Value<int>(element.id),
            x: Value<double>(element.x),
            y: Value<double>(element.y),
            width: Value<double>(element.width),
            height: Value<double>(element.height),
            rotation: Value<double>(element.rotation),
            color: Value<int>(element.color),
            label: Value<String?>(element.label),
            isVisible: Value<bool>(isVisible),
          ),
        );
  }
}
