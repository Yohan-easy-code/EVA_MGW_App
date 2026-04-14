import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';

abstract interface class WeaponRepository {
  Stream<List<Weapon>> watchWeapons();

  Future<List<Weapon>> getWeapons();

  Future<Weapon?> getWeaponById(int id);

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
  });

  Future<bool> updateWeapon(Weapon weapon);

  Future<bool> deleteWeapon(int id);
}
