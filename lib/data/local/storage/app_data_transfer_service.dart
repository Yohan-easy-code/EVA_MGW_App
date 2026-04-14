import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/data/local/storage/json_transfer_models.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppDataTransferService {
  const AppDataTransferService(this._database, this._seedService);

  final AppDatabase _database;
  final AppSeedService _seedService;

  Future<File> exportToJsonFile() async {
    final Map<String, Object?> payload = await exportToJsonMap();
    final Directory baseDirectory = await getApplicationDocumentsDirectory();
    final Directory exportDirectory = Directory(
      p.join(baseDirectory.path, 'exports'),
    );
    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }

    final String timestamp = DateTime.now()
        .toUtc()
        .toIso8601String()
        .replaceAll(':', '-');
    final File file = File(
      p.join(exportDirectory.path, 'mgw_eva_export_$timestamp.json'),
    );

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
      flush: true,
    );

    return file;
  }

  Future<Map<String, Object?>> exportToJsonMap() async {
    return <String, Object?>{
      'app_id': JsonTransferFormat.appId,
      'schema_version': JsonTransferFormat.version,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'battle_plans': await _exportBattlePlans(),
      'map_assets': await _exportMapAssets(),
      'plan_elements': await _exportPlanElements(),
      'weapons': await _exportWeapons(),
      'weapon_advanced_stats': await _exportWeaponAdvancedStats(),
      'weapon_distance_profiles': await _exportWeaponDistanceProfiles(),
    };
  }

  Future<String?> getSuggestedImportPath() async {
    final Directory baseDirectory = await getApplicationDocumentsDirectory();
    final Directory exportDirectory = Directory(
      p.join(baseDirectory.path, 'exports'),
    );
    if (!await exportDirectory.exists()) {
      return null;
    }

    final List<FileSystemEntity> entities = exportDirectory.listSync()
      ..sort((FileSystemEntity a, FileSystemEntity b) {
        return b.path.compareTo(a.path);
      });

    for (final FileSystemEntity entity in entities) {
      if (entity is File && entity.path.toLowerCase().endsWith('.json')) {
        return entity.path;
      }
    }

    return exportDirectory.path;
  }

  Future<JsonImportConflictSummary> inspectImportConflictsFromJsonPath(
    String path,
  ) async {
    final _DecodedImportPayload payload = await _decodeImportPayload(path);
    return _buildConflictSummary(payload);
  }

  Future<JsonImportResult> importFromJsonPath(
    String path, {
    JsonImportConflictStrategy strategy =
        JsonImportConflictStrategy.replaceExisting,
  }) async {
    final _DecodedImportPayload payload = await _decodeImportPayload(path);
    final JsonImportConflictSummary conflicts = await _buildConflictSummary(
      payload,
    );

    if (strategy == JsonImportConflictStrategy.abortOnConflict &&
        conflicts.hasConflicts) {
      throw JsonImportConflictException(conflicts);
    }

    final _PreparedImportPayload preparedPayload = await _preparePayload(
      payload,
      strategy: strategy,
    );

    await _database.transaction(() async {
      if (strategy == JsonImportConflictStrategy.replaceExisting) {
        await _clearAllTables();
      }

      await _importMapAssets(preparedPayload.mapAssets, strategy: strategy);
      await _importWeapons(preparedPayload.weapons, strategy: strategy);
      await _importWeaponAdvancedStats(
        preparedPayload.weaponAdvancedStats,
        strategy: strategy,
      );
      await _importWeaponDistanceProfiles(
        preparedPayload.weaponDistanceProfiles,
        strategy: strategy,
      );
      await _importBattlePlans(preparedPayload.battlePlans, strategy: strategy);
      await _importPlanElements(
        preparedPayload.planElements,
        strategy: strategy,
      );
    });

    return JsonImportResult(
      strategy: strategy,
      conflicts: conflicts,
      importedMapAssets: preparedPayload.mapAssets.length,
      importedWeapons: preparedPayload.weapons.length,
      importedWeaponAdvancedStats: preparedPayload.weaponAdvancedStats.length,
      importedWeaponDistanceProfiles:
          preparedPayload.weaponDistanceProfiles.length,
      importedBattlePlans: preparedPayload.battlePlans.length,
      importedPlanElements: preparedPayload.planElements.length,
    );
  }

  Future<void> resetDatabase() async {
    await _database.transaction(() async {
      await _clearAllTables();
    });
    await _seedService.seedIfNeeded();
  }

  Future<void> purgeBattlePlans() async {
    await _database.transaction(() async {
      await _clearBattlePlanTables();
    });
  }

  Future<_DecodedImportPayload> _decodeImportPayload(String path) async {
    final String normalizedPath = path.trim();
    if (normalizedPath.isEmpty) {
      throw const FormatException('Le chemin du fichier JSON est vide.');
    }

    final File file = File(normalizedPath);
    if (!await file.exists()) {
      throw FormatException('Fichier introuvable: $normalizedPath');
    }

    final String content = await file.readAsString();
    final Object? decoded = jsonDecode(content);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Le fichier JSON est invalide.');
    }

    final String appId = decoded['app_id'] as String? ?? '';
    if (appId != JsonTransferFormat.appId) {
      throw FormatException('Fichier JSON non supporte: app_id=$appId.');
    }

    final int schemaVersion = decoded['schema_version'] as int? ?? 0;
    if (schemaVersion != JsonTransferFormat.version) {
      throw FormatException('Version de schema non supportee: $schemaVersion.');
    }

    final List<Map<String, Object?>> mapAssets = _readObjectList(
      decoded['map_assets'],
      key: 'map_assets',
    );
    final List<Map<String, Object?>> weapons = _readObjectList(
      decoded['weapons'],
      key: 'weapons',
    );
    final List<Map<String, Object?>> weaponAdvancedStats = _readObjectList(
      decoded['weapon_advanced_stats'] ?? const <Object?>[],
      key: 'weapon_advanced_stats',
    );
    final List<Map<String, Object?>> weaponDistanceProfiles = _readObjectList(
      decoded['weapon_distance_profiles'] ?? const <Object?>[],
      key: 'weapon_distance_profiles',
    );
    final List<Map<String, Object?>> battlePlans = _readObjectList(
      decoded['battle_plans'],
      key: 'battle_plans',
    );
    final List<Map<String, Object?>> planElements = _readObjectList(
      decoded['plan_elements'],
      key: 'plan_elements',
    );

    _validateNoDuplicateIds(mapAssets, key: 'map_assets');
    _validateNoDuplicateIds(weapons, key: 'weapons');
    _validateNoDuplicateIds(
      weaponAdvancedStats,
      key: 'weapon_advanced_stats',
      idKey: 'weapon_id',
    );
    _validateNoDuplicateIds(
      weaponDistanceProfiles,
      key: 'weapon_distance_profiles',
    );
    _validateNoDuplicateIds(battlePlans, key: 'battle_plans');
    _validateNoDuplicateIds(planElements, key: 'plan_elements');
    _validatePayloadReferences(
      mapAssets: mapAssets,
      weapons: weapons,
      weaponAdvancedStats: weaponAdvancedStats,
      weaponDistanceProfiles: weaponDistanceProfiles,
      battlePlans: battlePlans,
      planElements: planElements,
    );

    return _DecodedImportPayload(
      mapAssets: mapAssets,
      weapons: weapons,
      weaponAdvancedStats: weaponAdvancedStats,
      weaponDistanceProfiles: weaponDistanceProfiles,
      battlePlans: battlePlans,
      planElements: planElements,
    );
  }

  Future<_PreparedImportPayload> _preparePayload(
    _DecodedImportPayload payload, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (strategy == JsonImportConflictStrategy.replaceExisting) {
      return _PreparedImportPayload(
        mapAssets: payload.mapAssets,
        weapons: payload.weapons,
        weaponAdvancedStats: payload.weaponAdvancedStats,
        weaponDistanceProfiles: payload.weaponDistanceProfiles,
        battlePlans: payload.battlePlans,
        planElements: payload.planElements,
      );
    }

    if (strategy == JsonImportConflictStrategy.abortOnConflict) {
      return _PreparedImportPayload(
        mapAssets: payload.mapAssets,
        weapons: payload.weapons,
        weaponAdvancedStats: payload.weaponAdvancedStats,
        weaponDistanceProfiles: payload.weaponDistanceProfiles,
        battlePlans: payload.battlePlans,
        planElements: payload.planElements,
      );
    }

    final Set<int> existingMapAssetIds = await _existingIds(
      _database.mapAssets.id,
      _database.mapAssets,
    );
    final Set<int> existingWeaponIds = await _existingIds(
      _database.weapons.id,
      _database.weapons,
    );
    final Set<int> existingWeaponAdvancedStatIds = await _existingIds(
      _database.weaponAdvancedStats.weaponId,
      _database.weaponAdvancedStats,
    );
    final Set<int> existingWeaponDistanceProfileIds = await _existingIds(
      _database.weaponDistanceProfiles.id,
      _database.weaponDistanceProfiles,
    );
    final Set<int> existingBattlePlanIds = await _existingIds(
      _database.battlePlans.id,
      _database.battlePlans,
    );
    final Set<int> existingPlanElementIds = await _existingIds(
      _database.planElements.id,
      _database.planElements,
    );

    final List<Map<String, Object?>> mapAssets = payload.mapAssets.where((
      Map<String, Object?> item,
    ) {
      return !existingMapAssetIds.contains(_readInt(item, key: 'id'));
    }).toList();
    final List<Map<String, Object?>> weapons = payload.weapons.where((
      Map<String, Object?> item,
    ) {
      return !existingWeaponIds.contains(_readInt(item, key: 'id'));
    }).toList();
    final List<Map<String, Object?>> weaponAdvancedStats = payload
        .weaponAdvancedStats
        .where((Map<String, Object?> item) {
          final int weaponId = _readInt(item, key: 'weapon_id');
          final bool weaponAvailable =
              existingWeaponIds.contains(weaponId) ||
              weapons.any(
                (Map<String, Object?> row) =>
                    _readInt(row, key: 'id') == weaponId,
              );
          return !existingWeaponAdvancedStatIds.contains(weaponId) &&
              weaponAvailable;
        })
        .toList();
    final List<Map<String, Object?>> weaponDistanceProfiles = payload
        .weaponDistanceProfiles
        .where((Map<String, Object?> item) {
          final int id = _readInt(item, key: 'id');
          final int weaponId = _readInt(item, key: 'weapon_id');
          final bool weaponAvailable =
              existingWeaponIds.contains(weaponId) ||
              weapons.any(
                (Map<String, Object?> row) =>
                    _readInt(row, key: 'id') == weaponId,
              );
          return !existingWeaponDistanceProfileIds.contains(id) &&
              weaponAvailable;
        })
        .toList();

    final Set<int> availableMapAssetIds = <int>{
      ...existingMapAssetIds,
      ...mapAssets.map(
        (Map<String, Object?> item) => _readInt(item, key: 'id'),
      ),
    };

    final List<Map<String, Object?>> battlePlans = payload.battlePlans.where((
      Map<String, Object?> item,
    ) {
      final int id = _readInt(item, key: 'id');
      final int mapId = _readInt(item, key: 'map_id');
      return !existingBattlePlanIds.contains(id) &&
          availableMapAssetIds.contains(mapId);
    }).toList();

    final Set<int> availableBattlePlanIds = <int>{
      ...existingBattlePlanIds,
      ...battlePlans.map(
        (Map<String, Object?> item) => _readInt(item, key: 'id'),
      ),
    };

    final List<Map<String, Object?>> planElements = payload.planElements.where((
      Map<String, Object?> item,
    ) {
      final int id = _readInt(item, key: 'id');
      final int battlePlanId = _readInt(item, key: 'battle_plan_id');
      return !existingPlanElementIds.contains(id) &&
          availableBattlePlanIds.contains(battlePlanId);
    }).toList();

    return _PreparedImportPayload(
      mapAssets: mapAssets,
      weapons: weapons,
      weaponAdvancedStats: weaponAdvancedStats,
      weaponDistanceProfiles: weaponDistanceProfiles,
      battlePlans: battlePlans,
      planElements: planElements,
    );
  }

  Future<JsonImportConflictSummary> _buildConflictSummary(
    _DecodedImportPayload payload,
  ) async {
    final Set<int> existingMapAssetIds = await _existingIds(
      _database.mapAssets.id,
      _database.mapAssets,
    );
    final Set<int> existingWeaponIds = await _existingIds(
      _database.weapons.id,
      _database.weapons,
    );
    final Set<int> existingWeaponAdvancedStatIds = await _existingIds(
      _database.weaponAdvancedStats.weaponId,
      _database.weaponAdvancedStats,
    );
    final Set<int> existingWeaponDistanceProfileIds = await _existingIds(
      _database.weaponDistanceProfiles.id,
      _database.weaponDistanceProfiles,
    );
    final Set<int> existingBattlePlanIds = await _existingIds(
      _database.battlePlans.id,
      _database.battlePlans,
    );
    final Set<int> existingPlanElementIds = await _existingIds(
      _database.planElements.id,
      _database.planElements,
    );

    return JsonImportConflictSummary(
      mapAssets: _countConflicts(payload.mapAssets, existingMapAssetIds),
      weapons: _countConflicts(payload.weapons, existingWeaponIds),
      weaponAdvancedStats: _countConflicts(
        payload.weaponAdvancedStats,
        existingWeaponAdvancedStatIds,
        idKey: 'weapon_id',
      ),
      weaponDistanceProfiles: _countConflicts(
        payload.weaponDistanceProfiles,
        existingWeaponDistanceProfileIds,
      ),
      battlePlans: _countConflicts(payload.battlePlans, existingBattlePlanIds),
      planElements: _countConflicts(
        payload.planElements,
        existingPlanElementIds,
      ),
    );
  }

  Future<Set<int>> _existingIds<T extends Table, D>(
    GeneratedColumn<int> column,
    TableInfo<T, D> table,
  ) async {
    final List<TypedResult> rows = await (_database.selectOnly(
      table,
    )..addColumns(<Expression<Object>>[column])).get();

    return rows
        .map((TypedResult row) => row.read(column))
        .whereType<int>()
        .toSet();
  }

  int _countConflicts(
    List<Map<String, Object?>> items,
    Set<int> existingIds, {
    String idKey = 'id',
  }) {
    return items.where((Map<String, Object?> item) {
      return existingIds.contains(_readInt(item, key: idKey));
    }).length;
  }

  Future<List<Map<String, Object?>>> _exportBattlePlans() async {
    final List<BattlePlan> items = await _database
        .select(_database.battlePlans)
        .get();

    return items
        .map(
          (BattlePlan item) => <String, Object?>{
            'id': item.id,
            'name': item.name,
            'map_id': item.mapId,
            'created_at': item.createdAt.toUtc().toIso8601String(),
            'updated_at': item.updatedAt.toUtc().toIso8601String(),
          },
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> _exportMapAssets() async {
    final List<MapAsset> items = await _database
        .select(_database.mapAssets)
        .get();

    return items
        .map(
          (MapAsset item) => <String, Object?>{
            'id': item.id,
            'name': item.name,
            'image_path': item.imagePath,
            'width': item.width,
            'height': item.height,
          },
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> _exportPlanElements() async {
    final List<PlanElement> items = await _database
        .select(_database.planElements)
        .get();

    return items
        .map(
          (PlanElement item) => <String, Object?>{
            'id': item.id,
            'battle_plan_id': item.battlePlanId,
            'type': item.type,
            'x': item.x,
            'y': item.y,
            'width': item.width,
            'height': item.height,
            'rotation': item.rotation,
            'color': item.color,
            'label': item.label,
            'extra_json': item.extraJson,
          },
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> _exportWeapons() async {
    final List<Weapon> items = await _database.select(_database.weapons).get();

    return items
        .map(
          (Weapon item) => <String, Object?>{
            'id': item.id,
            'name': item.name,
            'category': item.category,
            'image_path': item.imagePath,
            'damage': item.damage,
            'fire_rate': item.fireRate,
            'ammo': item.ammo,
            'reload_time': item.reloadTime,
            'range': item.range,
            'description': item.description,
          },
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> _exportWeaponAdvancedStats() async {
    final List<WeaponAdvancedStat> items = await _database
        .select(_database.weaponAdvancedStats)
        .get();

    return items
        .map(
          (WeaponAdvancedStat item) => <String, Object?>{
            'weapon_id': item.weaponId,
            'head_damage': item.headDamage,
            'body_damage': item.bodyDamage,
            'limb_damage': item.limbDamage,
            'precise_head_damage': item.preciseHeadDamage,
            'precise_body_damage': item.preciseBodyDamage,
            'precise_limb_damage': item.preciseLimbDamage,
            'average_damage': item.averageDamage,
            'bullet_spread_degrees': item.bulletSpreadDegrees,
            'bullet_velocity': item.bulletVelocity,
            'equip_time': item.equipTime,
            'range_min_label': item.rangeMinLabel,
            'range_max_label': item.rangeMaxLabel,
            'accuracy': item.accuracy,
            'mobility': item.mobility,
            'tags_json': item.tagsJson,
          },
        )
        .toList();
  }

  Future<List<Map<String, Object?>>> _exportWeaponDistanceProfiles() async {
    final List<WeaponDistanceProfile> items = await _database
        .select(_database.weaponDistanceProfiles)
        .get();

    return items
        .map(
          (WeaponDistanceProfile item) => <String, Object?>{
            'id': item.id,
            'weapon_id': item.weaponId,
            'distance_label': item.distanceLabel,
            'damage_multiplier': item.damageMultiplier,
          },
        )
        .toList();
  }

  Future<void> _clearAllTables() async {
    await _clearBattlePlanTables();
    await _database.delete(_database.weaponDistanceProfiles).go();
    await _database.delete(_database.weaponAdvancedStats).go();
    await _database.delete(_database.weapons).go();
    await _database.delete(_database.mapAssets).go();
  }

  Future<void> _clearBattlePlanTables() async {
    await _database.delete(_database.battlePlanStepElementStates).go();
    await _database.delete(_database.battlePlanSteps).go();
    await _database.delete(_database.planElements).go();
    await _database.delete(_database.battlePlans).go();
  }

  Future<void> _importMapAssets(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<MapAssetsCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return MapAssetsCompanion(
          id: Value<int>(_readInt(item, key: 'id')),
          name: Value<String>(_readString(item, key: 'name')),
          imagePath: Value<String>(_readString(item, key: 'image_path')),
          width: Value<int>(_readInt(item, key: 'width')),
          height: Value<int>(_readInt(item, key: 'height')),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.mapAssets, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.mapAssets, rows);
      }
    });
  }

  Future<void> _importWeapons(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<WeaponsCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return WeaponsCompanion(
          id: Value<int>(_readInt(item, key: 'id')),
          name: Value<String>(_readString(item, key: 'name')),
          category: Value<String>(_readString(item, key: 'category')),
          imagePath: Value<String>(_readString(item, key: 'image_path')),
          damage: Value<int>(_readInt(item, key: 'damage')),
          fireRate: Value<double>(_readDouble(item, key: 'fire_rate')),
          ammo: Value<int>(_readInt(item, key: 'ammo')),
          reloadTime: Value<double>(_readDouble(item, key: 'reload_time')),
          range: Value<double>(_readDouble(item, key: 'range')),
          description: Value<String>(_readString(item, key: 'description')),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.weapons, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.weapons, rows);
      }
    });
  }

  Future<void> _importBattlePlans(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<BattlePlansCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return BattlePlansCompanion(
          id: Value<int>(_readInt(item, key: 'id')),
          name: Value<String>(_readString(item, key: 'name')),
          mapId: Value<int>(_readInt(item, key: 'map_id')),
          createdAt: Value<DateTime>(_readDateTime(item, key: 'created_at')),
          updatedAt: Value<DateTime>(_readDateTime(item, key: 'updated_at')),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.battlePlans, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.battlePlans, rows);
      }
    });
  }

  Future<void> _importWeaponAdvancedStats(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<WeaponAdvancedStatsCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return WeaponAdvancedStatsCompanion(
          weaponId: Value<int>(_readInt(item, key: 'weapon_id')),
          headDamage: Value<int>(_readInt(item, key: 'head_damage')),
          bodyDamage: Value<int>(_readInt(item, key: 'body_damage')),
          limbDamage: Value<int>(_readInt(item, key: 'limb_damage')),
          preciseHeadDamage: Value<double?>(
            _readNullableDouble(item, key: 'precise_head_damage'),
          ),
          preciseBodyDamage: Value<double?>(
            _readNullableDouble(item, key: 'precise_body_damage'),
          ),
          preciseLimbDamage: Value<double?>(
            _readNullableDouble(item, key: 'precise_limb_damage'),
          ),
          averageDamage: Value<double>(
            _readDouble(item, key: 'average_damage'),
          ),
          bulletSpreadDegrees: Value<double>(
            _readDouble(item, key: 'bullet_spread_degrees'),
          ),
          bulletVelocity: Value<double>(
            _readDouble(item, key: 'bullet_velocity'),
          ),
          equipTime: Value<double>(_readDouble(item, key: 'equip_time')),
          rangeMinLabel: Value<String?>(
            _readNullableString(item, key: 'range_min_label'),
          ),
          rangeMaxLabel: Value<String?>(
            _readNullableString(item, key: 'range_max_label'),
          ),
          accuracy: Value<double?>(_readNullableDouble(item, key: 'accuracy')),
          mobility: Value<double?>(_readNullableDouble(item, key: 'mobility')),
          tagsJson: Value<String?>(_readNullableString(item, key: 'tags_json')),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.weaponAdvancedStats, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.weaponAdvancedStats, rows);
      }
    });
  }

  Future<void> _importWeaponDistanceProfiles(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<WeaponDistanceProfilesCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return WeaponDistanceProfilesCompanion(
          id: Value<int>(_readInt(item, key: 'id')),
          weaponId: Value<int>(_readInt(item, key: 'weapon_id')),
          distanceLabel: Value<String>(
            _readString(item, key: 'distance_label'),
          ),
          damageMultiplier: Value<double>(
            _readDouble(item, key: 'damage_multiplier'),
          ),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.weaponDistanceProfiles, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.weaponDistanceProfiles, rows);
      }
    });
  }

  Future<void> _importPlanElements(
    List<Map<String, Object?>> items, {
    required JsonImportConflictStrategy strategy,
  }) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      final List<PlanElementsCompanion> rows = items.map((
        Map<String, Object?> item,
      ) {
        return PlanElementsCompanion(
          id: Value<int>(_readInt(item, key: 'id')),
          battlePlanId: Value<int>(_readInt(item, key: 'battle_plan_id')),
          type: Value<String>(_readString(item, key: 'type')),
          x: Value<double>(_readDouble(item, key: 'x')),
          y: Value<double>(_readDouble(item, key: 'y')),
          width: Value<double>(_readDouble(item, key: 'width')),
          height: Value<double>(_readDouble(item, key: 'height')),
          rotation: Value<double>(_readDouble(item, key: 'rotation')),
          color: Value<int>(_readInt(item, key: 'color')),
          label: Value<String?>(_readNullableString(item, key: 'label')),
          extraJson: Value<String?>(
            _readNullableString(item, key: 'extra_json'),
          ),
        );
      }).toList();

      if (strategy == JsonImportConflictStrategy.keepExisting) {
        batch.insertAll(_database.planElements, rows);
      } else {
        batch.insertAllOnConflictUpdate(_database.planElements, rows);
      }
    });
  }

  void _validateNoDuplicateIds(
    List<Map<String, Object?>> items, {
    required String key,
    String idKey = 'id',
  }) {
    final Set<int> ids = <int>{};
    for (final Map<String, Object?> item in items) {
      final int id = _readInt(item, key: idKey);
      if (!ids.add(id)) {
        throw FormatException('Duplicat detecte dans $key pour id=$id.');
      }
    }
  }

  void _validatePayloadReferences({
    required List<Map<String, Object?>> mapAssets,
    required List<Map<String, Object?>> weapons,
    required List<Map<String, Object?>> weaponAdvancedStats,
    required List<Map<String, Object?>> weaponDistanceProfiles,
    required List<Map<String, Object?>> battlePlans,
    required List<Map<String, Object?>> planElements,
  }) {
    final Set<int> mapAssetIds = mapAssets
        .map((Map<String, Object?> item) => _readInt(item, key: 'id'))
        .toSet();
    final Set<int> weaponIds = weapons
        .map((Map<String, Object?> item) => _readInt(item, key: 'id'))
        .toSet();
    final Set<int> battlePlanIds = battlePlans
        .map((Map<String, Object?> item) => _readInt(item, key: 'id'))
        .toSet();

    for (final Map<String, Object?> battlePlan in battlePlans) {
      final int mapId = _readInt(battlePlan, key: 'map_id');
      if (!mapAssetIds.contains(mapId)) {
        throw FormatException(
          'Battle plan reference une carte absente: map_id=$mapId.',
        );
      }
    }

    for (final Map<String, Object?> element in planElements) {
      final int battlePlanId = _readInt(element, key: 'battle_plan_id');
      if (!battlePlanIds.contains(battlePlanId)) {
        throw FormatException(
          'Plan element reference un battle plan absent: battle_plan_id=$battlePlanId.',
        );
      }
    }

    for (final Map<String, Object?> item in weaponAdvancedStats) {
      final int weaponId = _readInt(item, key: 'weapon_id');
      if (!weaponIds.contains(weaponId)) {
        throw FormatException(
          'Weapon advanced stats reference une arme absente: weapon_id=$weaponId.',
        );
      }
    }

    for (final Map<String, Object?> item in weaponDistanceProfiles) {
      final int weaponId = _readInt(item, key: 'weapon_id');
      if (!weaponIds.contains(weaponId)) {
        throw FormatException(
          'Weapon distance profile reference une arme absente: weapon_id=$weaponId.',
        );
      }
    }
  }

  List<Map<String, Object?>> _readObjectList(
    Object? value, {
    required String key,
  }) {
    if (value is! List<Object?>) {
      throw FormatException('La cle $key est invalide.');
    }

    return value.map((Object? item) {
      if (item is! Map<String, Object?>) {
        throw FormatException('Un element de $key est invalide.');
      }

      return item;
    }).toList();
  }

  int _readInt(Map<String, Object?> item, {required String key}) {
    final Object? value = item[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }

    throw FormatException('Le champ $key est invalide.');
  }

  double _readDouble(Map<String, Object?> item, {required String key}) {
    final Object? value = item[key];
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }

    throw FormatException('Le champ $key est invalide.');
  }

  double? _readNullableDouble(
    Map<String, Object?> item, {
    required String key,
  }) {
    final Object? value = item[key];
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }

    throw FormatException('Le champ $key est invalide.');
  }

  String _readString(Map<String, Object?> item, {required String key}) {
    final Object? value = item[key];
    if (value is String) {
      return value;
    }

    throw FormatException('Le champ $key est invalide.');
  }

  String? _readNullableString(
    Map<String, Object?> item, {
    required String key,
  }) {
    final Object? value = item[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }

    throw FormatException('Le champ $key est invalide.');
  }

  DateTime _readDateTime(Map<String, Object?> item, {required String key}) {
    final String value = _readString(item, key: key);
    return DateTime.parse(value).toUtc();
  }
}

class _DecodedImportPayload {
  const _DecodedImportPayload({
    required this.mapAssets,
    required this.weapons,
    required this.weaponAdvancedStats,
    required this.weaponDistanceProfiles,
    required this.battlePlans,
    required this.planElements,
  });

  final List<Map<String, Object?>> mapAssets;
  final List<Map<String, Object?>> weapons;
  final List<Map<String, Object?>> weaponAdvancedStats;
  final List<Map<String, Object?>> weaponDistanceProfiles;
  final List<Map<String, Object?>> battlePlans;
  final List<Map<String, Object?>> planElements;
}

class _PreparedImportPayload {
  const _PreparedImportPayload({
    required this.mapAssets,
    required this.weapons,
    required this.weaponAdvancedStats,
    required this.weaponDistanceProfiles,
    required this.battlePlans,
    required this.planElements,
  });

  final List<Map<String, Object?>> mapAssets;
  final List<Map<String, Object?>> weapons;
  final List<Map<String, Object?>> weaponAdvancedStats;
  final List<Map<String, Object?>> weaponDistanceProfiles;
  final List<Map<String, Object?>> battlePlans;
  final List<Map<String, Object?>> planElements;
}
