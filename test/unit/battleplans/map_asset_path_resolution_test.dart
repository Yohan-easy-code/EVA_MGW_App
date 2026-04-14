import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Map asset path resolution', () {
    test(
      'seeds every available floor asset under assets/images/maps',
      () async {
        final database = createTestDatabase();
        addTearDown(database.close);

        await AppSeedService(database).seedIfNeeded();

        final rows = await database.select(database.mapAssets).get();
        final imagePaths = rows.map((MapAsset row) => row.imagePath).toSet();

        expect(rows, hasLength(17));
        expect(
          imagePaths,
          containsAll(<String>{
            'assets/images/maps/artefact/floor_1.png',
            'assets/images/maps/artefact/floor_2.png',
            'assets/images/maps/atlantis/floor_1.png',
            'assets/images/maps/atlantis/floor_2.png',
            'assets/images/maps/ceres/floor_1.png',
            'assets/images/maps/engine/floor_1.png',
            'assets/images/maps/helios/floor_1.png',
            'assets/images/maps/helios/floor_2.png',
            'assets/images/maps/horizon/floor_1.png',
            'assets/images/maps/horizon/floor_2.png',
            'assets/images/maps/lunar/floor_1.png',
            'assets/images/maps/outlaw/floor_1.png',
            'assets/images/maps/polaris/floor_1.png',
            'assets/images/maps/polaris/floor_2.png',
            'assets/images/maps/silva/floor_1.png',
            'assets/images/maps/the_cliff/floor_1.png',
            'assets/images/maps/the_cliff/floor_2.png',
          }),
        );
      },
    );

    test('finds Atlantis floor 2 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        'assets/images/maps/atlantis/floor_2.png',
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, 'assets/images/maps/atlantis/floor_2.png');
    });

    test('finds Lunar floor 1 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        'assets/images/maps/lunar/floor_1.png',
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, 'assets/images/maps/lunar/floor_1.png');
    });

    test('finds The Cliff floor 2 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        'assets/images/maps/the_cliff/floor_2.png',
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, 'assets/images/maps/the_cliff/floor_2.png');
    });

    test(
      'resolves deprecated assets/maps legacy paths to canonical assets',
      () async {
        final database = createTestDatabase();
        addTearDown(database.close);

        await AppSeedService(database).seedIfNeeded();

        final repository = DriftMapAssetRepository(database);
        final mapAsset = await repository.getMapAssetByImagePath(
          'assets/maps/lunar/floor_1.png',
        );

        expect(mapAsset, isNotNull);
        expect(mapAsset!.imagePath, 'assets/images/maps/lunar/floor_1.png');
      },
    );

    test(
      'migrates legacy database image paths to canonical assets on seed',
      () async {
        final database = createTestDatabase();
        addTearDown(database.close);

        await database
            .into(database.mapAssets)
            .insert(
              MapAssetsCompanion.insert(
                name: 'HELIOS',
                logicalMapName: const Value<String>('HELIOS'),
                floorNumber: const Value<int>(2),
                imagePath: 'assets/maps/helios/floor_2.png',
                width: 1600,
                height: 900,
              ),
            );

        await AppSeedService(database).seedIfNeeded();

        final rows = await database.select(database.mapAssets).get();
        final migratedRow = rows.singleWhere(
          (MapAsset row) =>
              row.logicalMapName == 'HELIOS' && row.floorNumber == 2,
        );

        expect(migratedRow.imagePath, 'assets/images/maps/helios/floor_2.png');
      },
    );
  });
}
