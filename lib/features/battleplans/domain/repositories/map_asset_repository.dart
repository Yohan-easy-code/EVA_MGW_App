import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

abstract interface class MapAssetRepository {
  Stream<List<MapAsset>> watchMapAssets();

  Future<List<MapAsset>> getMapAssets();

  Future<MapAsset?> getMapAssetById(int id);

  Future<MapAsset?> getMapAssetByImagePath(String imagePath);

  Future<int> createMapAsset({
    required String name,
    required String logicalMapName,
    required int floorNumber,
    required String imagePath,
    required int width,
    required int height,
  });

  Future<bool> updateMapAsset(MapAsset mapAsset);

  Future<bool> deleteMapAsset(int id);
}
