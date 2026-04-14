import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  group('Map asset path resolution', () {
    test('seeds the six canonical floor assets', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final rows = await database.select(database.mapAssets).get();
      final imagePaths = rows.map((MapAsset row) => row.imagePath).toSet();

      expect(rows, hasLength(6));
      expect(
        imagePaths,
        containsAll(<String>{
          AssetPaths.mapAtlantisFloor1,
          AssetPaths.mapAtlantisFloor2,
          AssetPaths.mapHeliosFloor1,
          AssetPaths.mapHeliosFloor2,
          AssetPaths.mapTheCliffFloor1,
          AssetPaths.mapTheCliffFloor2,
        }),
      );
    });

    test('finds Atlantis floor 2 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        AssetPaths.mapAtlantisFloor2,
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, AssetPaths.mapAtlantisFloor2);
    });

    test('finds Helios floor 2 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        AssetPaths.mapHeliosFloor2,
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, AssetPaths.mapHeliosFloor2);
    });

    test('finds The Cliff floor 2 from the canonical route path', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        AssetPaths.mapTheCliffFloor2,
      );

      expect(mapAsset, isNotNull);
      expect(mapAsset!.imagePath, AssetPaths.mapTheCliffFloor2);
    });

    test('rejects deprecated assets/maps legacy paths', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final repository = DriftMapAssetRepository(database);
      final mapAsset = await repository.getMapAssetByImagePath(
        'assets/maps/helios/floor_1.png',
      );

      expect(mapAsset, isNull);
    });
  });
}
