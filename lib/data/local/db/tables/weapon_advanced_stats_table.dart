import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/weapons_table.dart';

class WeaponAdvancedStats extends Table {
  IntColumn get weaponId => integer()
      .named('weapon_id')
      .references(Weapons, #id, onDelete: KeyAction.cascade)();

  IntColumn get headDamage => integer()
      .named('head_damage')
      .customConstraint('NOT NULL CHECK ("head_damage" >= 0)')();

  IntColumn get bodyDamage => integer()
      .named('body_damage')
      .customConstraint('NOT NULL CHECK ("body_damage" >= 0)')();

  IntColumn get limbDamage => integer()
      .named('limb_damage')
      .customConstraint('NOT NULL CHECK ("limb_damage" >= 0)')();

  RealColumn get preciseHeadDamage =>
      real().named('precise_head_damage').nullable()();

  RealColumn get preciseBodyDamage =>
      real().named('precise_body_damage').nullable()();

  RealColumn get preciseLimbDamage =>
      real().named('precise_limb_damage').nullable()();

  RealColumn get averageDamage => real()
      .named('average_damage')
      .customConstraint('NOT NULL CHECK ("average_damage" >= 0)')();

  RealColumn get bulletSpreadDegrees => real()
      .named('bullet_spread_degrees')
      .customConstraint('NOT NULL CHECK ("bullet_spread_degrees" >= 0)')();

  RealColumn get bulletVelocity => real()
      .named('bullet_velocity')
      .customConstraint('NOT NULL CHECK ("bullet_velocity" >= 0)')();

  RealColumn get equipTime => real()
      .named('equip_time')
      .customConstraint('NOT NULL CHECK ("equip_time" >= 0)')();

  TextColumn get rangeMinLabel =>
      text().named('range_min_label').withLength(min: 0, max: 32).nullable()();

  TextColumn get rangeMaxLabel =>
      text().named('range_max_label').withLength(min: 0, max: 32).nullable()();

  RealColumn get accuracy => real().nullable()();

  RealColumn get mobility => real().nullable()();

  TextColumn get tagsJson => text().named('tags_json').nullable()();

  @override
  Set<Column<Object>>? get primaryKey => <Column<Object>>{weaponId};
}
