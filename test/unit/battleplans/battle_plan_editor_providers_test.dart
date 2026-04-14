import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

import '../../helpers/test_database.dart';

void main() {
  group('battlePlanEditorSessionProvider', () {
    test('does not create a missing battleplan implicitly', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWith((Ref ref) => database)],
      );
      addTearDown(container.dispose);

      const args = BattlePlanEditorArgs(
        battlePlanId: null,
        battlePlanName: 'Plan fantome',
        mapAssetPath: AssetPaths.mapAtlantisFloor1,
      );

      await expectLater(
        container.read(battlePlanEditorSessionProvider(args).future),
        throwsA(isA<StateError>()),
      );

      final battlePlans = await database.select(database.battlePlans).get();
      expect(battlePlans, isEmpty);
    });

    test('keeps the same battleplan when switching map floor', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();
      final battlePlanRepository = DriftBattlePlanRepository(database);
      final mapAssets = await database.select(database.mapAssets).get();
      final atlantis = mapAssets.firstWhere(
        (map) => map.imagePath == AssetPaths.mapAtlantisFloor1,
      );
      final theCliffFloor2 = mapAssets.firstWhere(
        (map) => map.imagePath == AssetPaths.mapTheCliffFloor2,
      );
      final battlePlanId = await battlePlanRepository.createBattlePlan(
        name: '2',
        mapId: atlantis.id,
      );

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWith((Ref ref) => database)],
      );
      addTearDown(container.dispose);

      final session = await container.read(
        battlePlanEditorSessionProvider(
          BattlePlanEditorArgs(
            battlePlanId: battlePlanId,
            battlePlanName: '2',
            mapAssetPath: AssetPaths.mapTheCliffFloor2,
          ),
        ).future,
      );

      expect(session.battlePlan.id, battlePlanId);
      expect(session.battlePlan.mapId, theCliffFloor2.id);
      expect(session.mapAsset.id, theCliffFloor2.id);

      final refreshedBattlePlan = await battlePlanRepository.getBattlePlanById(
        battlePlanId,
      );
      expect(refreshedBattlePlan, isNotNull);
      expect(refreshedBattlePlan!.mapId, theCliffFloor2.id);
    });
  });
}
