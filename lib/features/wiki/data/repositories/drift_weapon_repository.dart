import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/wiki/data/mappers/weapon_mapper.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/domain/repositories/weapon_repository.dart';

class DriftWeaponRepository implements WeaponRepository {
  DriftWeaponRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Weapon>> watchWeapons() {
    final query = _database.select(_database.weapons)
      ..orderBy(<OrderClauseGenerator<db.$WeaponsTable>>[
        (db.$WeaponsTable table) =>
            OrderingTerm(expression: table.category, mode: OrderingMode.asc),
        (db.$WeaponsTable table) =>
            OrderingTerm(expression: table.name, mode: OrderingMode.asc),
      ]);

    return query.watch().map(
      (List<db.Weapon> rows) =>
          rows.map((db.Weapon row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<List<Weapon>> getWeapons() {
    final query = _database.select(_database.weapons)
      ..orderBy(<OrderClauseGenerator<db.$WeaponsTable>>[
        (db.$WeaponsTable table) =>
            OrderingTerm(expression: table.category, mode: OrderingMode.asc),
        (db.$WeaponsTable table) =>
            OrderingTerm(expression: table.name, mode: OrderingMode.asc),
      ]);

    return query.get().then(
      (List<db.Weapon> rows) =>
          rows.map((db.Weapon row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Weapon?> getWeaponById(int id) {
    return (_database.select(_database.weapons)
          ..where((db.$WeaponsTable table) => table.id.equals(id)))
        .getSingleOrNull()
        .then((db.Weapon? row) async {
          if (row == null) {
            return null;
          }

          final db.WeaponAdvancedStat? advancedStats =
              await (_database.select(_database.weaponAdvancedStats)..where(
                    (db.$WeaponAdvancedStatsTable table) =>
                        table.weaponId.equals(row.id),
                  ))
                  .getSingleOrNull();

          final List<db.WeaponDistanceProfile> distanceProfiles =
              await (_database.select(_database.weaponDistanceProfiles)
                    ..where(
                      (db.$WeaponDistanceProfilesTable table) =>
                          table.weaponId.equals(row.id),
                    )
                    ..orderBy(
                      <OrderClauseGenerator<db.$WeaponDistanceProfilesTable>>[
                        (db.$WeaponDistanceProfilesTable table) => OrderingTerm(
                          expression: table.id,
                          mode: OrderingMode.asc,
                        ),
                      ],
                    ))
                  .get();

          return row.toDomain().copyWith(
            headDamage:
                advancedStats?.preciseHeadDamage ??
                advancedStats?.headDamage.toDouble(),
            bodyDamage:
                advancedStats?.preciseBodyDamage ??
                advancedStats?.bodyDamage.toDouble(),
            limbDamage:
                advancedStats?.preciseLimbDamage ??
                advancedStats?.limbDamage.toDouble(),
            averageDamage: advancedStats?.averageDamage,
            bulletSpreadDegrees: advancedStats?.bulletSpreadDegrees,
            bulletVelocity: advancedStats?.bulletVelocity,
            equipTime: advancedStats?.equipTime,
            rangeMinLabel: advancedStats?.rangeMinLabel,
            rangeMaxLabel: advancedStats?.rangeMaxLabel,
            accuracy: advancedStats?.accuracy,
            mobility: advancedStats?.mobility,
            tags: _decodeTags(advancedStats?.tagsJson),
            distanceProfiles: distanceProfiles
                .map((db.WeaponDistanceProfile profile) => profile.toDomain())
                .toList(growable: false),
          );
        });
  }

  @override
  Future<int> createWeapon({
    required String name,
    required String category,
    required String imagePath,
    required int damage,
    required double fireRate,
    required int ammo,
    required double reloadTime,
    required double range,
    required String description,
  }) {
    return _database
        .into(_database.weapons)
        .insert(
          db.WeaponsCompanion.insert(
            name: name.trim(),
            category: category.trim(),
            imagePath: imagePath.trim(),
            damage: damage,
            fireRate: fireRate,
            ammo: ammo,
            reloadTime: reloadTime,
            range: range,
            description: description.trim(),
          ),
        );
  }

  @override
  Future<bool> updateWeapon(Weapon weapon) {
    return (_database.update(_database.weapons)
          ..where((db.$WeaponsTable table) => table.id.equals(weapon.id)))
        .write(
          db.WeaponsCompanion(
            name: Value<String>(weapon.name.trim()),
            category: Value<String>(weapon.category.trim()),
            imagePath: Value<String>(weapon.imagePath.trim()),
            damage: Value<int>(weapon.damage),
            fireRate: Value<double>(weapon.fireRate),
            ammo: Value<int>(weapon.ammo),
            reloadTime: Value<double>(weapon.reloadTime),
            range: Value<double>(weapon.range),
            description: Value<String>(weapon.description.trim()),
          ),
        )
        .then((int rows) => rows > 0);
  }

  @override
  Future<bool> deleteWeapon(int id) {
    return (_database.delete(_database.weapons)
          ..where((db.$WeaponsTable table) => table.id.equals(id)))
        .go()
        .then((int rows) => rows > 0);
  }

  List<String> _decodeTags(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return const <String>[];
    }

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List<Object?>) {
      return const <String>[];
    }

    return decoded.whereType<String>().toList(growable: false);
  }
}
