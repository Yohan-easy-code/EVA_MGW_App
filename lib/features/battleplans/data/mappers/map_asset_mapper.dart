import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

extension MapAssetDataMapper on db.MapAsset {
  MapAsset toDomain() {
    return MapAsset(
      id: id,
      name: name,
      logicalMapName: logicalMapName,
      floorNumber: floorNumber,
      imagePath: imagePath,
      width: width,
      height: height,
    );
  }
}
