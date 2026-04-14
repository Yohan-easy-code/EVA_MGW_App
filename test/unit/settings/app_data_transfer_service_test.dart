import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/data/local/storage/app_data_transfer_service.dart';
import 'package:mgw_eva/data/local/storage/json_transfer_models.dart';

import '../../helpers/test_database.dart';

void main() {
  group('AppDataTransferService', () {
    test('exports a complete versioned JSON payload', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      final seedService = AppSeedService(database);
      final service = AppDataTransferService(database, seedService);

      final int mapId = await database
          .into(database.mapAssets)
          .insert(
            MapAssetsCompanion.insert(
              name: 'ATLANTIS',
              logicalMapName: const Value<String>('ATLANTIS'),
              floorNumber: const Value<int>(1),
              imagePath: AssetPaths.mapAtlantisFloor1,
              width: 1600,
              height: 900,
            ),
          );
      final int battlePlanId = await database
          .into(database.battlePlans)
          .insert(
            BattlePlansCompanion.insert(name: 'Alpha Push', mapId: mapId),
          );
      await database
          .into(database.planElements)
          .insert(
            PlanElementsCompanion.insert(
              battlePlanId: battlePlanId,
              type: 'marker',
              x: 120,
              y: 240,
              width: 42,
              height: 42,
              color: 0xFFFFB84D,
              label: const Value<String?>('A'),
              extraJson: const Value<String?>('{"role":"entry"}'),
            ),
          );
      final int weaponId = await database
          .into(database.weapons)
          .insert(
            WeaponsCompanion.insert(
              name: 'Helios AR',
              category: 'Assault Rifle',
              imagePath: 'assets/images/weapons/weapon_helios_rifle.svg',
              damage: 32,
              fireRate: 8.6,
              ammo: 30,
              reloadTime: 2.1,
              range: 72,
              description: 'Polyvalent.',
            ),
          );

      final payload = await service.exportToJsonMap();

      expect(payload['app_id'], JsonTransferFormat.appId);
      expect(payload['schema_version'], JsonTransferFormat.version);
      expect(DateTime.parse(payload['exported_at']! as String).isUtc, isTrue);

      final mapAssets = (payload['map_assets']! as List<Object?>)
          .cast<Map<String, Object?>>();
      final battlePlans = (payload['battle_plans']! as List<Object?>)
          .cast<Map<String, Object?>>();
      final planElements = (payload['plan_elements']! as List<Object?>)
          .cast<Map<String, Object?>>();
      final weapons = (payload['weapons']! as List<Object?>)
          .cast<Map<String, Object?>>();

      expect(mapAssets, hasLength(1));
      expect(battlePlans, hasLength(1));
      expect(planElements, hasLength(1));
      expect(weapons, hasLength(1));

      expect(mapAssets.single['id'], mapId);
      expect(battlePlans.single['id'], battlePlanId);
      expect(battlePlans.single['map_id'], mapId);
      expect(planElements.single['battle_plan_id'], battlePlanId);
      expect(planElements.single['label'], 'A');
      expect(weapons.single['id'], weaponId);
      expect(weapons.single['name'], 'Helios AR');
    });

    test(
      'resetDatabase clears battleplans and reseeds only catalogue data',
      () async {
        final database = createTestDatabase();
        addTearDown(database.close);

        final seedService = AppSeedService(database);
        final service = AppDataTransferService(database, seedService);

        await seedService.seedIfNeeded();

        final int mapId =
            (await database.select(database.mapAssets).get()).first.id;
        final int battlePlanId = await database
            .into(database.battlePlans)
            .insert(
              BattlePlansCompanion.insert(name: 'Legacy Plan', mapId: mapId),
            );
        final int stepId = await database
            .into(database.battlePlanSteps)
            .insert(
              BattlePlanStepsCompanion.insert(
                battlePlanId: battlePlanId,
                title: 'Etape 1',
                orderIndex: 0,
              ),
            );
        final int elementId = await database
            .into(database.planElements)
            .insert(
              PlanElementsCompanion.insert(
                battlePlanId: battlePlanId,
                type: 'marker',
                x: 120,
                y: 240,
                width: 42,
                height: 42,
                color: 0xFFFFB84D,
              ),
            );
        await database
            .into(database.battlePlanStepElementStates)
            .insert(
              BattlePlanStepElementStatesCompanion.insert(
                stepId: stepId,
                planElementId: elementId,
                x: 120,
                y: 240,
                width: 42,
                height: 42,
                color: 0xFFFFB84D,
              ),
            );

        await service.resetDatabase();

        expect(await database.select(database.battlePlans).get(), isEmpty);
        expect(await database.select(database.planElements).get(), isEmpty);
        expect(await database.select(database.battlePlanSteps).get(), isEmpty);
        expect(
          await database.select(database.battlePlanStepElementStates).get(),
          isEmpty,
        );
        expect(await database.select(database.mapAssets).get(), hasLength(6));
        expect(await database.select(database.weapons).get(), isNotEmpty);
      },
    );

    test(
      'purgeBattlePlans removes local plans and keeps seeded maps',
      () async {
        final database = createTestDatabase();
        addTearDown(database.close);

        final seedService = AppSeedService(database);
        final service = AppDataTransferService(database, seedService);

        await seedService.seedIfNeeded();

        final int mapId =
            (await database.select(database.mapAssets).get()).first.id;
        final int battlePlanId = await database
            .into(database.battlePlans)
            .insert(
              BattlePlansCompanion.insert(name: 'Plan Dev', mapId: mapId),
            );
        await database
            .into(database.planElements)
            .insert(
              PlanElementsCompanion.insert(
                battlePlanId: battlePlanId,
                type: 'marker',
                x: 10,
                y: 20,
                width: 42,
                height: 42,
                color: 0xFFFFB84D,
              ),
            );

        await service.purgeBattlePlans();

        expect(await database.select(database.battlePlans).get(), isEmpty);
        expect(await database.select(database.planElements).get(), isEmpty);
        expect(await database.select(database.battlePlanSteps).get(), isEmpty);
        expect(
          await database.select(database.battlePlanStepElementStates).get(),
          isEmpty,
        );
        expect(await database.select(database.mapAssets).get(), hasLength(6));
        expect(await database.select(database.weapons).get(), isNotEmpty);
      },
    );
  });
}
