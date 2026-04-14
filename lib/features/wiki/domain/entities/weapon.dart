class Weapon {
  const Weapon({
    required this.id,
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
    this.distanceProfiles = const <WeaponDistanceProfile>[],
  });

  final int id;
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
  final List<WeaponDistanceProfile> distanceProfiles;

  Weapon copyWith({
    int? id,
    String? name,
    String? category,
    String? imagePath,
    int? damage,
    double? fireRate,
    int? ammo,
    double? reloadTime,
    double? range,
    String? description,
    double? headDamage,
    double? bodyDamage,
    double? limbDamage,
    double? averageDamage,
    double? bulletSpreadDegrees,
    double? bulletVelocity,
    double? equipTime,
    String? rangeMinLabel,
    String? rangeMaxLabel,
    double? accuracy,
    double? mobility,
    List<String>? tags,
    List<WeaponDistanceProfile>? distanceProfiles,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      damage: damage ?? this.damage,
      fireRate: fireRate ?? this.fireRate,
      ammo: ammo ?? this.ammo,
      reloadTime: reloadTime ?? this.reloadTime,
      range: range ?? this.range,
      description: description ?? this.description,
      headDamage: headDamage ?? this.headDamage,
      bodyDamage: bodyDamage ?? this.bodyDamage,
      limbDamage: limbDamage ?? this.limbDamage,
      averageDamage: averageDamage ?? this.averageDamage,
      bulletSpreadDegrees: bulletSpreadDegrees ?? this.bulletSpreadDegrees,
      bulletVelocity: bulletVelocity ?? this.bulletVelocity,
      equipTime: equipTime ?? this.equipTime,
      rangeMinLabel: rangeMinLabel ?? this.rangeMinLabel,
      rangeMaxLabel: rangeMaxLabel ?? this.rangeMaxLabel,
      accuracy: accuracy ?? this.accuracy,
      mobility: mobility ?? this.mobility,
      tags: tags ?? this.tags,
      distanceProfiles: distanceProfiles ?? this.distanceProfiles,
    );
  }
}

class WeaponDistanceProfile {
  const WeaponDistanceProfile({
    required this.distanceLabel,
    required this.damageMultiplier,
  });

  final String distanceLabel;
  final double damageMultiplier;
}
