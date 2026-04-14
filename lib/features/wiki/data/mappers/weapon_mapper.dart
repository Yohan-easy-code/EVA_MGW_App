import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';

extension WeaponDataMapper on db.Weapon {
  Weapon toDomain() {
    return Weapon(
      id: id,
      name: name,
      category: category,
      imagePath: imagePath,
      damage: damage,
      fireRate: fireRate,
      ammo: ammo,
      reloadTime: reloadTime,
      range: range,
      description: description,
    );
  }
}

extension WeaponDistanceProfileDataMapper on db.WeaponDistanceProfile {
  WeaponDistanceProfile toDomain() {
    return WeaponDistanceProfile(
      distanceLabel: distanceLabel,
      damageMultiplier: damageMultiplier,
    );
  }
}
