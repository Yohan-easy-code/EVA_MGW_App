import 'package:mgw_eva/data/local/seed/seed_models.dart';
import 'package:mgw_eva/data/local/seed/weapon_seed_asset_paths.dart';

const List<WeaponSeed> defaultWeapons = <WeaponSeed>[
  WeaponSeed(
    name: 'ERG',
    category: 'Lasergun',
    imagePath: WeaponSeedAssetPaths.lasergun,
    damage: 1,
    fireRate: 6000,
    ammo: 400,
    reloadTime: 2,
    range: 0,
    description:
        'Arme a energie concue pour maintenir une tres forte cadence avec une '
        'bonne precision, efficace dans les combats mobiles a moyenne portee.',
    headDamage: 1.62,
    bodyDamage: 1.22,
    limbDamage: 1.1,
    averageDamage: 1.3,
    bulletSpreadDegrees: 0,
    bulletVelocity: 0,
    equipTime: 0,
    rangeMinLabel: '0m',
    rangeMaxLabel: '0m',
    accuracy: 5000,
    mobility: 0.6,
    tags: <String>['energy', 'medium_range', 'rapid_fire'],
  ),
  WeaponSeed(
    name: 'ATLAS',
    category: 'Sniper Rifle',
    imagePath: WeaponSeedAssetPaths.sniper,
    damage: 95,
    fireRate: 60,
    ammo: 5,
    reloadTime: 2.5,
    range: 0,
    description:
        'Fusil de precision longue portee pense pour infliger de lourds '
        'degats a distance tout en conservant une tres forte precision.',
    headDamage: 150,
    bodyDamage: 95,
    limbDamage: 95,
    averageDamage: 113.3,
    bulletSpreadDegrees: 0,
    bulletVelocity: 0,
    equipTime: 0,
    rangeMinLabel: '0m',
    rangeMaxLabel: '0m',
    accuracy: 3000,
    mobility: 0.9,
    tags: <String>['sniper', 'long_range', 'precision'],
  ),
  WeaponSeed(
    name: 'AK77',
    category: 'Assault Rifle',
    imagePath: WeaponSeedAssetPaths.assaultRifle,
    damage: 15,
    fireRate: 552,
    ammo: 35,
    reloadTime: 1.8,
    range: 35,
    description:
        'Fusil d\'assaut lourd oriente domination de lane, avec une cadence '
        'contenue mais un excellent rendement par salve sur les lignes '
        'de vue moyennes.',
    headDamage: 17,
    bodyDamage: 15,
    limbDamage: 14,
    averageDamage: 15.3,
    bulletSpreadDegrees: 0.3,
    bulletVelocity: 1000,
    equipTime: 0.6,
    distanceProfiles: <WeaponDistanceProfileSeed>[
      WeaponDistanceProfileSeed(distanceLabel: '0m - 25m', damageMultiplier: 1),
      WeaponDistanceProfileSeed(
        distanceLabel: '25m - 35m',
        damageMultiplier: 0.83,
      ),
      WeaponDistanceProfileSeed(distanceLabel: '> 35m', damageMultiplier: 0.75),
    ],
  ),
];
