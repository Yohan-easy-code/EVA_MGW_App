abstract final class MapAssetPathResolver {
  static final RegExp _canonicalMapAssetPattern = RegExp(
    r'^assets/images/maps/([a-z0-9_]+)/floor_(\d+)\.png$',
    caseSensitive: false,
  );
  static final RegExp _legacyMapAssetPattern = RegExp(
    r'^assets/maps/([a-z0-9_ -]+)/floor_(\d+)\.png$',
    caseSensitive: false,
  );

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
    if (_canonicalMapAssetPattern.hasMatch(lowerCasePath)) {
      return lowerCasePath;
    }

    final RegExpMatch? legacyMatch = _legacyMapAssetPattern.firstMatch(
      lowerCasePath,
    );
    if (legacyMatch == null) {
      return null;
    }

    final String mapDirectory = legacyMatch.group(1)!.replaceAll(' ', '_');
    final String floorNumber = legacyMatch.group(2)!;
    return 'assets/images/maps/$mapDirectory/floor_$floorNumber.png';
  }
}
