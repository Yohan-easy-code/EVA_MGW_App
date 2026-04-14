import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/app/app.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/map_asset_repository.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/domain/repositories/weapon_repository.dart';
import 'package:mgw_eva/shared/providers/app_startup_provider.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

class _FakeBattlePlanRepository implements BattlePlanRepository {
  const _FakeBattlePlanRepository();

  @override
  Stream<List<BattlePlan>> watchBattlePlans() {
    return Stream<List<BattlePlan>>.value(const <BattlePlan>[]);
  }

  @override
  Future<List<BattlePlan>> getBattlePlans() async => const <BattlePlan>[];

  @override
  Future<BattlePlan?> getBattlePlanById(int id) async => null;

  @override
  Future<BattlePlan?> getBattlePlanByNameAndMapId({
    required String name,
    required int mapId,
  }) async {
    return null;
  }

  @override
  Future<int> createBattlePlan({required String name, required int mapId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBattlePlan(BattlePlan battlePlan) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteBattlePlan(int id) {
    throw UnimplementedError();
  }
}

class _FakeMapAssetRepository implements MapAssetRepository {
  const _FakeMapAssetRepository();

  @override
  Stream<List<MapAsset>> watchMapAssets() {
    return Stream<List<MapAsset>>.value(const <MapAsset>[]);
  }

  @override
  Future<List<MapAsset>> getMapAssets() async => const <MapAsset>[];

  @override
  Future<MapAsset?> getMapAssetById(int id) async => null;

  @override
  Future<MapAsset?> getMapAssetByImagePath(String imagePath) async => null;

  @override
  Future<int> createMapAsset({
    required String name,
    required String logicalMapName,
    required int floorNumber,
    required String imagePath,
    required int width,
    required int height,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateMapAsset(MapAsset mapAsset) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteMapAsset(int id) {
    throw UnimplementedError();
  }
}

class _FakeWeaponRepository implements WeaponRepository {
  const _FakeWeaponRepository(this._weapons);

  final List<Weapon> _weapons;

  @override
  Stream<List<Weapon>> watchWeapons() => Stream<List<Weapon>>.value(_weapons);

  @override
  Future<List<Weapon>> getWeapons() async => _weapons;

  @override
  Future<Weapon?> getWeaponById(int id) async {
    for (final Weapon weapon in _weapons) {
      if (weapon.id == id) {
        return weapon;
      }
    }

    return null;
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
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWeapon(Weapon weapon) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWeapon(int id) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('opens weapon detail without runtime exception', (
    WidgetTester tester,
  ) async {
    const Weapon weapon = Weapon(
      id: 42,
      name: 'Helios AR',
      category: 'Assault Rifle',
      imagePath: 'assets/images/weapons/missing.svg',
      damage: 32,
      fireRate: 8.6,
      ammo: 30,
      reloadTime: 2.1,
      range: 72,
      description: 'Fusil d\'assaut stable pour les duels moyens.',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((Ref ref) async {}),
          battlePlanRepositoryProvider.overrideWith(
            (Ref ref) => const _FakeBattlePlanRepository(),
          ),
          mapAssetRepositoryProvider.overrideWith(
            (Ref ref) => const _FakeMapAssetRepository(),
          ),
          weaponRepositoryProvider.overrideWith(
            (Ref ref) => const _FakeWeaponRepository(<Weapon>[weapon]),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Wiki').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Helios AR'), findsOneWidget);

    await tester.tap(
      find.ancestor(of: find.text('Helios AR'), matching: find.byType(InkWell)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Weapon Detail'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lecture tactique'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Lecture tactique'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Armes associees'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Armes associees'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 300));
  });
}
