import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:path/path.dart' as path;

class MapFloorAssetCatalog {
  const MapFloorAssetCatalog._();

  static final RegExp _floorAssetPattern = RegExp(
    r'^floor_(\d+)\.(png|jpg|jpeg|webp)$',
    caseSensitive: false,
  );

  static String floorAssetPath(MapAsset mapAsset, int floorNumber) {
    final String directory = path
        .dirname(mapAsset.imagePath)
        .replaceAll('\\', '/');

    return '$directory/floor_$floorNumber.png';
  }

  static bool hasFloorAsset({
    required MapAsset mapAsset,
    required int floorNumber,
    required Set<String> assetPaths,
  }) {
    return assetPaths.contains(floorAssetPath(mapAsset, floorNumber));
  }

  static Set<int> supportedFloorNumbers({
    required MapAsset mapAsset,
    required Iterable<MapAsset> knownFloors,
    required Set<String> assetPaths,
  }) {
    final Set<int> floorNumbers = <int>{1, 2};
    floorNumbers.addAll(
      knownFloors.map((MapAsset floorAsset) => floorAsset.floorNumber),
    );
    floorNumbers.addAll(
      _detectAssetFloors(mapAsset: mapAsset, assetPaths: assetPaths),
    );
    floorNumbers.removeWhere((int value) => value < 1);

    return floorNumbers;
  }

  static Set<int> _detectAssetFloors({
    required MapAsset mapAsset,
    required Set<String> assetPaths,
  }) {
    final String targetDirectory = path
        .dirname(mapAsset.imagePath)
        .replaceAll('\\', '/');
    final Set<int> detectedFloors = <int>{};

    for (final String assetPath in assetPaths) {
      final String normalizedPath = assetPath.replaceAll('\\', '/');
      if (path.dirname(normalizedPath) != targetDirectory) {
        continue;
      }

      final RegExpMatch? match = _floorAssetPattern.firstMatch(
        path.basename(normalizedPath),
      );
      if (match == null) {
        continue;
      }

      detectedFloors.add(int.parse(match.group(1)!));
    }

    return detectedFloors;
  }
}
