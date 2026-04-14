import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_plan_element_repository.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_service.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_timeline_service.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

import '../../helpers/test_database.dart';

void main() {
  group('BattlePlanEditorService', () {
    test('persists create, update, duplicate and delete flows', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      final mapAssetRepository = DriftMapAssetRepository(database);
      final battlePlanRepository = DriftBattlePlanRepository(database);
      final planElementRepository = DriftPlanElementRepository(database);
      final stepRepository = DriftBattlePlanStepRepository(database);
      final stepStateRepository = DriftBattlePlanStepElementStateRepository(
        database,
      );
      final timelineService = BattlePlanTimelineService(
        stepRepository,
        stepStateRepository,
        planElementRepository,
      );
      final service = BattlePlanEditorService(
        planElementRepository,
        stepStateRepository,
      );

      final int mapId = await mapAssetRepository.createMapAsset(
        name: 'Test Map',
        logicalMapName: 'Test Map',
        floorNumber: 1,
        imagePath: AssetPaths.mapHeliosFloor1,
        width: 400,
        height: 600,
      );
      final int battlePlanId = await battlePlanRepository.createBattlePlan(
        name: '  Alpha Push  ',
        mapId: mapId,
      );
      final int stepId = (await timelineService.ensureInitialTimeline(
        battlePlanId,
      )).first.id;

      await service.createElement(
        battlePlanId: battlePlanId,
        stepId: stepId,
        type: PlanElementType.player,
        mapWidth: 400,
        mapHeight: 600,
      );

      final createdBattlePlan = await battlePlanRepository
          .getBattlePlanByNameAndMapId(name: 'Alpha Push', mapId: mapId);
      expect(createdBattlePlan, isNotNull);

      final createdElements = await planElementRepository.getPlanElements(
        battlePlanId,
      );
      expect(createdElements, hasLength(1));
      expect(createdElements.first.type, PlanElementType.player.storageKey);
      expect(createdElements.first.label, 'Player');
      expect(createdElements.first.x, closeTo(171, 0.001));
      expect(createdElements.first.y, closeTo(271, 0.001));

      await service.updatePosition(
        stepId: stepId,
        element: createdElements.first,
        position: const Offset(32, 48),
      );

      final movedElement = (await stepStateRepository.getStepPlanElements(
        stepId,
      )).first;
      expect(movedElement.x, 32);
      expect(movedElement.y, 48);

      await service.updateAppearance(
        stepId: stepId,
        element: movedElement,
        color: 0xFF123456,
        label: 'Hold Angle',
      );
      final updatedElement = (await stepStateRepository.getStepPlanElements(
        stepId,
      )).first;
      await service.duplicateElement(
        stepId: stepId,
        source: updatedElement,
        duplicatedPosition: const Offset(84, 96),
      );

      final duplicatedElements = await stepStateRepository.getStepPlanElements(
        stepId,
      );
      expect(duplicatedElements, hasLength(2));
      expect(duplicatedElements.first.color, 0xFF123456);
      expect(duplicatedElements.first.label, 'Hold Angle');
      expect(duplicatedElements.last.x, 84);
      expect(duplicatedElements.last.y, 96);

      await service.deleteElement(duplicatedElements.first.id);

      final remainingElements = await stepStateRepository.getStepPlanElements(
        stepId,
      );
      expect(remainingElements, hasLength(1));
      expect(remainingElements.single.label, 'Hold Angle');
      expect(remainingElements.single.x, 84);
      expect(remainingElements.single.y, 96);
    });
  });
}
