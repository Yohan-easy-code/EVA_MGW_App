import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plan_step_element_states_table.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plan_steps_table.dart';
import 'package:mgw_eva/data/local/db/tables/battle_plans_table.dart';
import 'package:mgw_eva/data/local/db/tables/map_assets_table.dart';
import 'package:mgw_eva/data/local/db/tables/plan_elements_table.dart';
import 'package:mgw_eva/data/local/db/tables/weapon_advanced_stats_table.dart';
import 'package:mgw_eva/data/local/db/tables/weapon_distance_profiles_table.dart';
import 'package:mgw_eva/data/local/db/tables/weapons_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: <Type>[
    BattlePlans,
    BattlePlanSteps,
    BattlePlanStepElementStates,
    MapAssets,
    PlanElements,
    Weapons,
    WeaponAdvancedStats,
    WeaponDistanceProfiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await _createIndexes();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 1) {
        await migrator.createAll();
      }
      if (from < 2) {
        await migrator.createTable(weaponAdvancedStats);
        await migrator.createTable(weaponDistanceProfiles);
      }
      if (from < 3) {
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.rangeMinLabel,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.rangeMaxLabel,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.accuracy,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.mobility,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.tagsJson,
        );
      }
      if (from < 4) {
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.preciseHeadDamage,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.preciseBodyDamage,
        );
        await migrator.addColumn(
          weaponAdvancedStats,
          weaponAdvancedStats.preciseLimbDamage,
        );
      }
      if (from < 5) {
        await migrator.createTable(battlePlanSteps);
        await migrator.createTable(battlePlanStepElementStates);
      }
      if (from < 6) {
        await migrator.addColumn(
          mapAssets,
          mapAssets.logicalMapName as GeneratedColumn<Object>,
        );
        await migrator.addColumn(
          mapAssets,
          mapAssets.floorNumber as GeneratedColumn<Object>,
        );

        await customStatement(
          "UPDATE map_assets "
          "SET logical_map_name = name, floor_number = 1 "
          "WHERE logical_map_name IS NULL OR logical_map_name = '';",
        );
      }

      await _createIndexes();
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_battle_plans_map_id '
      'ON battle_plans (map_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_battle_plans_updated_at '
      'ON battle_plans (updated_at DESC);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_elements_battle_plan_id '
      'ON plan_elements (battle_plan_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_battle_plan_steps_battle_plan_id '
      'ON battle_plan_steps (battle_plan_id, order_index);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_step_element_states_step_id '
      'ON battle_plan_step_element_states (step_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_step_element_states_plan_element_id '
      'ON battle_plan_step_element_states (plan_element_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weapons_category '
      'ON weapons (category);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weapons_name '
      'ON weapons (name);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weapon_distance_profiles_weapon_id '
      'ON weapon_distance_profiles (weapon_id);',
    );
  }

  static Future<File> resolveDatabaseFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, 'mgw_eva.sqlite'));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final File file = await AppDatabase.resolveDatabaseFile();

    if (kDebugMode) {
      return NativeDatabase.createInBackground(file, logStatements: false);
    }

    return NativeDatabase.createInBackground(file);
  });
}
