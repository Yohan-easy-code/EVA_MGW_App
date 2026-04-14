import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/weapons_table.dart';

class WeaponDistanceProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get weaponId => integer()
      .named('weapon_id')
      .references(Weapons, #id, onDelete: KeyAction.cascade)();

  TextColumn get distanceLabel =>
      text().named('distance_label').withLength(min: 1, max: 60)();

  RealColumn get damageMultiplier => real()
      .named('damage_multiplier')
      .customConstraint('NOT NULL CHECK ("damage_multiplier" >= 0)')();
}
