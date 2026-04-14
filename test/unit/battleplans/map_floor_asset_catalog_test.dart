import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/assets/map_floor_asset_catalog.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

void main() {
  group('MapFloorAssetCatalog', () {
    const MapAsset lunarFloor1 = MapAsset(
      id: 1,
      name: 'LUNAR',
      logicalMapName: 'LUNAR',
      floorNumber: 1,
      imagePath: 'assets/images/maps/lunar/floor_1.png',
      width: 1600,
      height: 900,
    );
    const MapAsset atlantisFloor1 = MapAsset(
      id: 2,
      name: 'ATLANTIS',
      logicalMapName: 'ATLANTIS',
      floorNumber: 1,
      imagePath: AssetPaths.mapAtlantisFloor1,
      width: 1600,
      height: 900,
    );
    const MapAsset atlantisFloor2 = MapAsset(
      id: 3,
      name: 'ATLANTIS',
      logicalMapName: 'ATLANTIS',
      floorNumber: 2,
      imagePath: AssetPaths.mapAtlantisFloor2,
      width: 1600,
      height: 900,
    );

    test('detects missing second floor from asset manifest', () {
      const Set<String> assetPaths = <String>{
        'assets/images/maps/lunar/floor_1.png',
      };

      expect(
        MapFloorAssetCatalog.hasFloorAsset(
          mapAsset: lunarFloor1,
          floorNumber: 2,
          assetPaths: assetPaths,
        ),
        isFalse,
      );
      expect(
        MapFloorAssetCatalog.supportedFloorNumbers(
          mapAsset: lunarFloor1,
          knownFloors: const <MapAsset>[lunarFloor1],
          assetPaths: assetPaths,
        ),
        containsAll(<int>[1, 2]),
      );
    });

    test('detects second floor when asset exists', () {
      const Set<String> assetPaths = <String>{
        AssetPaths.mapAtlantisFloor1,
        AssetPaths.mapAtlantisFloor2,
      };

      expect(
        MapFloorAssetCatalog.hasFloorAsset(
          mapAsset: atlantisFloor1,
          floorNumber: 2,
          assetPaths: assetPaths,
        ),
        isTrue,
      );
      expect(
        MapFloorAssetCatalog.supportedFloorNumbers(
          mapAsset: atlantisFloor1,
          knownFloors: const <MapAsset>[atlantisFloor1, atlantisFloor2],
          assetPaths: assetPaths,
        ),
        containsAll(<int>[1, 2]),
      );
    });
  });
}
