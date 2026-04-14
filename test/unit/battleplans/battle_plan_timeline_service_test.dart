import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_plan_element_repository.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_timeline_service.dart';

import '../../helpers/test_database.dart';

void main() {
  group('BattlePlanTimelineService', () {
    test('creates initial step, duplicates and deletes safely', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      final mapAssetRepository = DriftMapAssetRepository(database);
      final battlePlanRepository = DriftBattlePlanRepository(database);
      final planElementRepository = DriftPlanElementRepository(database);
      final stepRepository = DriftBattlePlanStepRepository(database);
      final stepStateRepository = DriftBattlePlanStepElementStateRepository(
        database,
      );
      final service = BattlePlanTimelineService(
        stepRepository,
        stepStateRepository,
        planElementRepository,
      );

      final int mapId = await mapAssetRepository.createMapAsset(
        name: 'Map',
        logicalMapName: 'Map',
        floorNumber: 1,
        imagePath: AssetPaths.mapAtlantisFloor1,
        width: 800,
        height: 800,
      );
      final int battlePlanId = await battlePlanRepository.createBattlePlan(
        name: 'Plan',
        mapId: mapId,
      );
      await planElementRepository.createPlanElement(
        battlePlanId: battlePlanId,
        type: 'player',
        x: 10,
        y: 20,
        width: 40,
        height: 40,
        rotation: 0,
        color: 0xFFFFFFFF,
        label: 'P1',
      );

      final initialSteps = await service.ensureInitialTimeline(battlePlanId);
      expect(initialSteps, hasLength(1));
      expect(initialSteps.first.title, 'Etape 1');

      final initialElements = await stepStateRepository.getStepPlanElements(
        initialSteps.first.id,
      );
      expect(initialElements, hasLength(1));
      expect(initialElements.first.label, 'P1');

      final duplicatedStep = await service.duplicateStep(initialSteps.first);
      expect(duplicatedStep.title, 'Etape 2');
      final duplicatedElements = await stepStateRepository.getStepPlanElements(
        duplicatedStep.id,
      );
      expect(duplicatedElements, hasLength(1));

      final remainingSteps = await service.deleteStep(
        battlePlanId: battlePlanId,
        stepId: duplicatedStep.id,
      );
      expect(remainingSteps, hasLength(1));
      expect(remainingSteps.first.title, 'Etape 1');
    });
  });
}
