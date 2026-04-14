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

  static String normalize(String assetPath) {
    final String normalizedPath = assetPath.trim().replaceAll('\\', '/');
    final String lowerCasePath = normalizedPath.toLowerCase();

    if (_supportedCanonicalPaths.contains(lowerCasePath)) {
      return lowerCasePath;
    }

    return lowerCasePath;
  }

  static bool isSupported(String assetPath) {
    return _supportedCanonicalPaths.contains(normalize(assetPath));
  }
}
