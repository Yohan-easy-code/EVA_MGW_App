import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

import '../../helpers/test_database.dart';

void main() {
  group('battle_plan_steps_providers', () {
    test('createStep adds and selects the new step immediately', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      final mapAssetRepository = DriftMapAssetRepository(database);
      final battlePlanRepository = DriftBattlePlanRepository(database);

      final int mapId = await mapAssetRepository.createMapAsset(
        name: 'Map',
        logicalMapName: 'Map',
        floorNumber: 1,
        imagePath: AssetPaths.mapTheCliffFloor1,
        width: 1600,
        height: 900,
      );
      final int battlePlanId = await battlePlanRepository.createBattlePlan(
        name: 'Plan test',
        mapId: mapId,
      );

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWith((ref) => database)],
      );
      addTearDown(container.dispose);

      final stepsSubscription = container.listen(
        battlePlanStepsProvider(battlePlanId),
        (previous, next) {},
      );
      addTearDown(stepsSubscription.close);

      final timelineSubscription = container.listen(
        battlePlanTimelineStateProvider(battlePlanId),
        (previous, next) {},
      );
      addTearDown(timelineSubscription.close);

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final BattlePlanStep? initialStep = container.read(
        currentBattlePlanStepProvider(battlePlanId),
      );
      expect(initialStep, isNotNull);
      expect(
        container.read(battlePlanStepsProvider(battlePlanId)).requireValue,
        hasLength(1),
      );

      await container
          .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
          .createStep(battlePlanId);

      await Future<void>.delayed(Duration.zero);

      final List<BattlePlanStep> stepsAfterFirstCreate = container
          .read(battlePlanStepsProvider(battlePlanId))
          .requireValue;
      expect(stepsAfterFirstCreate, hasLength(2));
      expect(
        container.read(currentBattlePlanStepProvider(battlePlanId))?.id,
        stepsAfterFirstCreate.last.id,
      );

      await container
          .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
          .createStep(battlePlanId);

      await Future<void>.delayed(Duration.zero);

      final List<BattlePlanStep> stepsAfterSecondCreate = container
          .read(battlePlanStepsProvider(battlePlanId))
          .requireValue;
      expect(stepsAfterSecondCreate, hasLength(3));
      expect(
        container.read(currentBattlePlanStepProvider(battlePlanId))?.id,
        stepsAfterSecondCreate.last.id,
      );
    });
  });
}
