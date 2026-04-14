import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/domain/repositories/weapon_repository.dart';
import 'package:mgw_eva/features/wiki/presentation/wiki_screen.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

import '../../helpers/test_app.dart';

class _FakeWeaponRepository implements WeaponRepository {
  const _FakeWeaponRepository(this._weapons);

  final List<Weapon> _weapons;

  @override
  Stream<List<Weapon>> watchWeapons() => Stream<List<Weapon>>.value(_weapons);

  @override
  Future<List<Weapon>> getWeapons() async => _weapons;

  @override
  Future<Weapon?> getWeaponById(int id) async {
    for (final weapon in _weapons) {
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
  group('WikiListScreen', () {
    testWidgets('filters weapons by search query and category', (
      WidgetTester tester,
    ) async {
      const weapons = <Weapon>[
        Weapon(
          id: 1,
          name: 'Helios AR',
          category: 'Assault Rifle',
          imagePath: 'assets/images/weapons/missing.svg',
          damage: 32,
          fireRate: 8.6,
          ammo: 30,
          reloadTime: 2.1,
          range: 72,
          description: 'Fusil d\'assaut stable pour les duels moyens.',
        ),
        Weapon(
          id: 2,
          name: 'Mauler SX',
          category: 'Shotgun',
          imagePath: 'assets/images/weapons/missing.svg',
          damage: 92,
          fireRate: 1.2,
          ammo: 8,
          reloadTime: 2.8,
          range: 18,
          description: 'Shotgun de breche pour les pushs rapproches.',
        ),
      ];

      await tester.pumpWidget(
        buildTestApp(
          const WikiListScreen(),
          overrides: [
            weaponRepositoryProvider.overrideWith(
              (ref) => const _FakeWeaponRepository(weapons),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Helios AR'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, 'Shotgun'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'breche');
      await tester.pumpAndSettle();

      expect(find.text('Helios AR'), findsNothing);
      expect(find.text('Mauler SX'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Shotgun'));
      await tester.pumpAndSettle();

      expect(find.text('Helios AR'), findsNothing);
      expect(find.text('Mauler SX'), findsOneWidget);
    });
  });
}
