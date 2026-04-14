class MapAssetSeed {
  const MapAssetSeed({
    required this.name,
    required this.logicalMapName,
    required this.floorNumber,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  final String name;
  final String logicalMapName;
  final int floorNumber;
  final String imagePath;
  final int width;
  final int height;
}

class WeaponSeed {
  const WeaponSeed({
    required this.name,
    required this.category,
    required this.imagePath,
    required this.damage,
    required this.fireRate,
    required this.ammo,
    required this.reloadTime,
    required this.range,
    required this.description,
    this.headDamage,
    this.bodyDamage,
    this.limbDamage,
    this.averageDamage,
    this.bulletSpreadDegrees,
    this.bulletVelocity,
    this.equipTime,
    this.rangeMinLabel,
    this.rangeMaxLabel,
    this.accuracy,
    this.mobility,
    this.tags = const <String>[],
    this.distanceProfiles = const <WeaponDistanceProfileSeed>[],
  });

  final String name;
  final String category;
  final String imagePath;
  final int damage;
  final double fireRate;
  final int ammo;
  final double reloadTime;
  final double range;
  final String description;
  final double? headDamage;
  final double? bodyDamage;
  final double? limbDamage;
  final double? averageDamage;
  final double? bulletSpreadDegrees;
  final double? bulletVelocity;
  final double? equipTime;
  final String? rangeMinLabel;
  final String? rangeMaxLabel;
  final double? accuracy;
  final double? mobility;
  final List<String> tags;
  final List<WeaponDistanceProfileSeed> distanceProfiles;
}

class WeaponDistanceProfileSeed {
  const WeaponDistanceProfileSeed({
    required this.distanceLabel,
    required this.damageMultiplier,
  });

  final String distanceLabel;
  final double damageMultiplier;
}
