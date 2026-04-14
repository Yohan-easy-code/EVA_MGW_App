import 'package:mgw_eva/data/local/seed/seed_models.dart';
import 'package:path/path.dart' as path;

const int defaultMapWidth = 1600;
const int defaultMapHeight = 900;
const Set<String> fallbackMapAssetPaths = <String>{
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
};

final RegExp _mapFloorAssetPattern = RegExp(
  r'^assets/images/maps/([^/]+)/floor_(\d+)\.png$',
  caseSensitive: false,
);

List<MapAssetSeed> buildDefaultMapAssets(Iterable<String> assetPaths) {
  final Map<String, Map<int, String>> mapFloorPaths =
      <String, Map<int, String>>{};

  for (final String assetPath in assetPaths) {
    final String normalizedPath = assetPath.trim().replaceAll('\\', '/');
    final RegExpMatch? match = _mapFloorAssetPattern.firstMatch(normalizedPath);
    if (match == null) {
      continue;
    }

    final String mapDirectory = match.group(1)!;
    final int floorNumber = int.parse(match.group(2)!);
    mapFloorPaths.putIfAbsent(
      mapDirectory,
      () => <int, String>{},
    )[floorNumber] = normalizedPath;
  }

  final List<MapAssetSeed> seeds = <MapAssetSeed>[];
  final List<String> sortedDirectories = mapFloorPaths.keys.toList()..sort();

  for (final String mapDirectory in sortedDirectories) {
    final Map<int, String> floorPaths = mapFloorPaths[mapDirectory]!;
    if (!floorPaths.containsKey(1)) {
      continue;
    }

    final List<int> sortedFloors = floorPaths.keys.toList()..sort();
    for (final int floorNumber in sortedFloors) {
      seeds.add(
        MapAssetSeed(
          name: _displayNameForDirectory(mapDirectory),
          logicalMapName: _displayNameForDirectory(mapDirectory),
          floorNumber: floorNumber,
          imagePath: floorPaths[floorNumber]!,
          width: defaultMapWidth,
          height: defaultMapHeight,
        ),
      );
    }
  }

  return seeds;
}

String _displayNameForDirectory(String mapDirectory) {
  return path.basename(mapDirectory).replaceAll('_', ' ').toUpperCase();
}
