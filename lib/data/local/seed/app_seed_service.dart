import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:mgw_eva/core/assets/map_asset_path_resolver.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/default_map_assets.dart';
import 'package:mgw_eva/data/local/seed/default_weapons.dart';
import 'package:mgw_eva/data/local/seed/seed_models.dart';

class AppSeedService {
  const AppSeedService(this._database);

  final AppDatabase _database;
  static const Map<String, String> _legacyWeaponRenames = <String, String>{
    'ak-47': 'AK77',
  };

  Future<void> seedIfNeeded() async {
    await _database.transaction(() async {
      await _syncMapAssets();
      await _seedWeaponsIfNeeded();
    });
  }

  Future<void> _syncMapAssets() async {
    final List<MapAssetSeed> defaultMapAssets = await _loadDefaultMapAssets();
    final List<MapAsset> existingMapAssets = await _database
        .select(_database.mapAssets)
        .get();
    final Map<String, MapAsset> existingByImagePath = <String, MapAsset>{
      for (final MapAsset mapAsset in existingMapAssets)
        if (MapAssetPathResolver.tryResolveCanonicalPath(mapAsset.imagePath)
            case final String canonicalPath)
          canonicalPath: mapAsset,
    };
    final Map<String, MapAsset> existingByLogicalFloor = <String, MapAsset>{
      for (final MapAsset mapAsset in existingMapAssets)
        _mapFloorKey(
          logicalMapName: mapAsset.logicalMapName.trim().isEmpty
              ? mapAsset.name
              : mapAsset.logicalMapName,
          floorNumber: mapAsset.floorNumber,
        ): mapAsset,
    };

    for (final mapAssetSeed in defaultMapAssets) {
      final MapAsset? existingMapAsset =
          existingByLogicalFloor[_mapFloorKey(
            logicalMapName: mapAssetSeed.logicalMapName,
            floorNumber: mapAssetSeed.floorNumber,
          )] ??
          existingByImagePath[mapAssetSeed.imagePath];
      if (existingMapAsset != null) {
        await (_database.update(
          _database.mapAssets,
        )..where((table) => table.id.equals(existingMapAsset.id))).write(
          MapAssetsCompanion(
            name: Value<String>(mapAssetSeed.name),
            logicalMapName: Value<String>(mapAssetSeed.logicalMapName),
            floorNumber: Value<int>(mapAssetSeed.floorNumber),
            imagePath: Value<String>(mapAssetSeed.imagePath),
            width: Value<int>(mapAssetSeed.width),
            height: Value<int>(mapAssetSeed.height),
          ),
        );
        continue;
      }

      await _database
          .into(_database.mapAssets)
          .insert(
            MapAssetsCompanion.insert(
              name: mapAssetSeed.name,
              logicalMapName: Value<String>(mapAssetSeed.logicalMapName),
              floorNumber: Value<int>(mapAssetSeed.floorNumber),
              imagePath: mapAssetSeed.imagePath,
              width: mapAssetSeed.width,
              height: mapAssetSeed.height,
            ),
          );
    }

    await _removeObsoleteSeedMapAssets(defaultMapAssets);
  }

  Future<void> _seedWeaponsIfNeeded() async {
    await _renameLegacyWeapons();

    final List<Weapon> existingWeapons = await _database
        .select(_database.weapons)
        .get();
    await _removeObsoleteSeedWeapons(existingWeapons);

    final List<Weapon> refreshedWeapons = await _database
        .select(_database.weapons)
        .get();

    final Map<String, Weapon> existingByName = <String, Weapon>{
      for (final Weapon weapon in refreshedWeapons)
        _normalizeName(weapon.name): weapon,
    };
    final Map<String, int> syncedWeaponIds = <String, int>{};

    for (final weaponSeed in defaultWeapons) {
      final String normalizedName = _normalizeName(weaponSeed.name);
      final Weapon? existingWeapon = existingByName[normalizedName];

      if (existingWeapon != null) {
        await (_database.update(
          _database.weapons,
        )..where((table) => table.id.equals(existingWeapon.id))).write(
          WeaponsCompanion(
            name: Value<String>(weaponSeed.name),
            category: Value<String>(weaponSeed.category),
            imagePath: Value<String>(weaponSeed.imagePath),
            damage: Value<int>(weaponSeed.damage),
            fireRate: Value<double>(weaponSeed.fireRate),
            ammo: Value<int>(weaponSeed.ammo),
            reloadTime: Value<double>(weaponSeed.reloadTime),
            range: Value<double>(weaponSeed.range),
            description: Value<String>(weaponSeed.description),
          ),
        );
        syncedWeaponIds[normalizedName] = existingWeapon.id;
        continue;
      }

      final int weaponId = await _database
          .into(_database.weapons)
          .insert(
            WeaponsCompanion.insert(
              name: weaponSeed.name,
              category: weaponSeed.category,
              imagePath: weaponSeed.imagePath,
              damage: weaponSeed.damage,
              fireRate: weaponSeed.fireRate,
              ammo: weaponSeed.ammo,
              reloadTime: weaponSeed.reloadTime,
              range: weaponSeed.range,
              description: weaponSeed.description,
            ),
          );
      syncedWeaponIds[normalizedName] = weaponId;
    }

    await _syncWeaponAdvancedStats(syncedWeaponIds);
    await _syncWeaponDistanceProfiles(syncedWeaponIds);
  }

  Future<void> _syncWeaponAdvancedStats(
    Map<String, int> syncedWeaponIds,
  ) async {
    if (syncedWeaponIds.isEmpty) {
      return;
    }

    for (final weapon in defaultWeapons) {
      final int? weaponId = syncedWeaponIds[_normalizeName(weapon.name)];
      if (weaponId == null) {
        continue;
      }

      if (weapon.headDamage == null ||
          weapon.bodyDamage == null ||
          weapon.limbDamage == null ||
          weapon.averageDamage == null ||
          weapon.bulletSpreadDegrees == null ||
          weapon.bulletVelocity == null ||
          weapon.equipTime == null) {
        await (_database.delete(
          _database.weaponAdvancedStats,
        )..where((table) => table.weaponId.equals(weaponId))).go();
        continue;
      }

      await _database
          .into(_database.weaponAdvancedStats)
          .insertOnConflictUpdate(
            WeaponAdvancedStatsCompanion(
              weaponId: Value<int>(weaponId),
              headDamage: Value<int>(weapon.headDamage!.round()),
              bodyDamage: Value<int>(weapon.bodyDamage!.round()),
              limbDamage: Value<int>(weapon.limbDamage!.round()),
              preciseHeadDamage: Value<double?>(weapon.headDamage),
              preciseBodyDamage: Value<double?>(weapon.bodyDamage),
              preciseLimbDamage: Value<double?>(weapon.limbDamage),
              averageDamage: Value<double>(weapon.averageDamage!),
              bulletSpreadDegrees: Value<double>(weapon.bulletSpreadDegrees!),
              bulletVelocity: Value<double>(weapon.bulletVelocity!),
              equipTime: Value<double>(weapon.equipTime!),
              rangeMinLabel: Value<String?>(weapon.rangeMinLabel),
              rangeMaxLabel: Value<String?>(weapon.rangeMaxLabel),
              accuracy: Value<double?>(weapon.accuracy),
              mobility: Value<double?>(weapon.mobility),
              tagsJson: Value<String?>(
                weapon.tags.isEmpty ? null : jsonEncode(weapon.tags),
              ),
            ),
          );
    }
  }

  Future<void> _syncWeaponDistanceProfiles(
    Map<String, int> syncedWeaponIds,
  ) async {
    if (syncedWeaponIds.isEmpty) {
      return;
    }

    for (final weapon in defaultWeapons) {
      final int? weaponId = syncedWeaponIds[_normalizeName(weapon.name)];
      if (weaponId == null) {
        continue;
      }

      await (_database.delete(
        _database.weaponDistanceProfiles,
      )..where((table) => table.weaponId.equals(weaponId))).go();

      if (weapon.distanceProfiles.isEmpty) {
        continue;
      }

      await _database.batch((Batch batch) {
        batch.insertAll(
          _database.weaponDistanceProfiles,
          weapon.distanceProfiles
              .map((distanceProfile) {
                return WeaponDistanceProfilesCompanion.insert(
                  weaponId: weaponId,
                  distanceLabel: distanceProfile.distanceLabel,
                  damageMultiplier: distanceProfile.damageMultiplier,
                );
              })
              .toList(growable: false),
        );
      });
    }
  }

  Future<void> _renameLegacyWeapons() async {
    for (final MapEntry<String, String> entry in _legacyWeaponRenames.entries) {
      final String legacyName = entry.key;
      final String targetName = entry.value;

      final List<Weapon> matchingWeapons =
          await (_database.select(_database.weapons)..where(
                (table) =>
                    table.name.equals(targetName) |
                    table.name.equals(legacyName),
              ))
              .get();

      final bool hasTargetAlready = matchingWeapons.any(
        (Weapon weapon) =>
            _normalizeName(weapon.name) == _normalizeName(targetName),
      );
      Weapon? legacyWeapon;
      for (final Weapon weapon in matchingWeapons) {
        if (_normalizeName(weapon.name) == legacyName) {
          legacyWeapon = weapon;
          break;
        }
      }

      if (legacyWeapon == null || hasTargetAlready) {
        continue;
      }

      await (_database.update(_database.weapons)
            ..where((table) => table.id.equals(legacyWeapon!.id)))
          .write(WeaponsCompanion(name: Value<String>(targetName)));
    }
  }

  String _normalizeName(String value) {
    return value.trim().toLowerCase();
  }

  Future<void> _removeObsoleteSeedWeapons(List<Weapon> existingWeapons) async {
    final Set<String> seedNames = defaultWeapons
        .map((weapon) => _normalizeName(weapon.name))
        .toSet();

    final List<int> obsoleteWeaponIds = existingWeapons
        .where(
          (Weapon weapon) => !seedNames.contains(_normalizeName(weapon.name)),
        )
        .map((Weapon weapon) => weapon.id)
        .toList(growable: false);

    if (obsoleteWeaponIds.isEmpty) {
      return;
    }

    for (final int weaponId in obsoleteWeaponIds) {
      await (_database.delete(
        _database.weapons,
      )..where((table) => table.id.equals(weaponId))).go();
    }
  }

  Future<List<MapAssetSeed>> _loadDefaultMapAssets() async {
    try {
      final String assetManifest = await rootBundle.loadString(
        'AssetManifest.json',
      );
      final Map<String, dynamic> decodedManifest =
          jsonDecode(assetManifest) as Map<String, dynamic>;

      return buildDefaultMapAssets(decodedManifest.keys);
    } catch (_) {
      return buildDefaultMapAssets(fallbackMapAssetPaths);
    }
  }

  Future<void> _removeObsoleteSeedMapAssets(
    List<MapAssetSeed> defaultMapAssets,
  ) async {
    final Set<String> seedMapKeys = defaultMapAssets
        .map<String>(
          (MapAssetSeed mapAsset) => _mapFloorKey(
            logicalMapName: mapAsset.logicalMapName,
            floorNumber: mapAsset.floorNumber,
          ),
        )
        .toSet();

    final List<MapAsset> existingMapAssets = await _database
        .select(_database.mapAssets)
        .get();

    for (final MapAsset mapAsset in existingMapAssets) {
      final String mapKey = _mapFloorKey(
        logicalMapName: mapAsset.logicalMapName.trim().isEmpty
            ? mapAsset.name
            : mapAsset.logicalMapName,
        floorNumber: mapAsset.floorNumber,
      );

      if (seedMapKeys.contains(mapKey)) {
        continue;
      }

      final bool isReferenced =
          await (_database.select(_database.battlePlans)
                ..where((table) => table.mapId.equals(mapAsset.id)))
              .getSingleOrNull() !=
          null;
      if (isReferenced) {
        continue;
      }

      await (_database.delete(
        _database.mapAssets,
      )..where((table) => table.id.equals(mapAsset.id))).go();
    }
  }
}

String _mapFloorKey({
  required String logicalMapName,
  required int floorNumber,
}) {
  return '${logicalMapName.trim().toLowerCase()}#$floorNumber';
}
