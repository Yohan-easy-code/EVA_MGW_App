import 'package:mgw_eva/core/constants/asset_paths.dart';

abstract final class MapAssetPathResolver {
  static const Set<String> _supportedCanonicalPaths = <String>{
    AssetPaths.mapAtlantisFloor1,
    AssetPaths.mapAtlantisFloor2,
    AssetPaths.mapHeliosFloor1,
    AssetPaths.mapHeliosFloor2,
    AssetPaths.mapTheCliffFloor1,
    AssetPaths.mapTheCliffFloor2,
  };

  static String sanitize(String assetPath) {
    return assetPath.trim().replaceAll('\\', '/');
  }

  static String normalize(String assetPath) {
    return tryResolveCanonicalPath(assetPath) ?? sanitize(assetPath);
  }

  static bool isSupported(String assetPath) {
    return tryResolveCanonicalPath(assetPath) != null;
  }

  static String? tryResolveCanonicalPath(String assetPath) {
    final String normalizedPath = sanitize(assetPath);
    if (normalizedPath.isEmpty) {
      return null;
    }

    final String lowerCasePath = normalizedPath.toLowerCase();
    if (_supportedCanonicalPaths.contains(lowerCasePath)) {
      return lowerCasePath;
    }

    final int? floorNumber = _extractFloorNumber(lowerCasePath);
    if (floorNumber == null) {
      return null;
    }

    if (_matchesMap(lowerCasePath, mapKey: 'atlantis')) {
      return _canonicalPathFor('atlantis', floorNumber);
    }
    if (_matchesMap(lowerCasePath, mapKey: 'helios')) {
      return _canonicalPathFor('helios', floorNumber);
    }
    if (_matchesMap(
      lowerCasePath,
      mapKey: 'the_cliff',
      alternateMapKeys: const <String>['the cliff', 'the-cliff'],
    )) {
      return _canonicalPathFor('the_cliff', floorNumber);
    }

    return null;
  }

  static bool _matchesMap(
    String assetPath, {
    required String mapKey,
    List<String> alternateMapKeys = const <String>[],
  }) {
    return assetPath.contains(mapKey) ||
        alternateMapKeys.any(assetPath.contains);
  }

  static int? _extractFloorNumber(String assetPath) {
    if (assetPath.contains('floor_1')) {
      return 1;
    }
    if (assetPath.contains('floor_2')) {
      return 2;
    }

    return null;
  }

  static String? _canonicalPathFor(String mapKey, int floorNumber) {
    return switch ('$mapKey#$floorNumber') {
      'atlantis#1' => AssetPaths.mapAtlantisFloor1,
      'atlantis#2' => AssetPaths.mapAtlantisFloor2,
      'helios#1' => AssetPaths.mapHeliosFloor1,
      'helios#2' => AssetPaths.mapHeliosFloor2,
      'the_cliff#1' => AssetPaths.mapTheCliffFloor1,
      'the_cliff#2' => AssetPaths.mapTheCliffFloor2,
      _ => null,
    };
  }
}
