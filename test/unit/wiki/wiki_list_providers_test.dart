import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/features/wiki/logic/wiki_list_providers.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

import '../../helpers/test_database.dart';

void main() {
  group('wiki_list_providers', () {
    test('filters weapons by query and category', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await database.batch((batch) {
        batch.insertAll(database.weapons, <WeaponsCompanion>[
          WeaponsCompanion.insert(
            name: 'Helios AR',
            category: 'Assault Rifle',
            imagePath: 'assets/images/weapons/missing.svg',
            damage: 32,
            fireRate: 8.6,
            ammo: 30,
            reloadTime: 2.1,
            range: 72,
            description: 'Polyvalent pour les duels moyens.',
          ),
          WeaponsCompanion.insert(
            name: 'Viper One',
            category: 'Sniper',
            imagePath: 'assets/images/weapons/missing.svg',
            damage: 140,
            fireRate: 0.7,
            ammo: 5,
            reloadTime: 2.9,
            range: 96,
            description: 'Precision longue portee.',
          ),
        ]);
      });

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWith((ref) => database)],
      );
      addTearDown(container.dispose);

      final weaponsSubscription = container.listen(
        wikiWeaponsProvider,
        (previous, next) {},
      );
      final categoriesSubscription = container.listen(
        wikiCategoriesProvider,
        (previous, next) {},
      );
      final filteredSubscription = container.listen(
        filteredWikiWeaponsProvider,
        (previous, next) {},
      );
      addTearDown(weaponsSubscription.close);
      addTearDown(categoriesSubscription.close);
      addTearDown(filteredSubscription.close);

      await container.read(wikiWeaponsProvider.future);

      expect(container.read(wikiCategoriesProvider).requireValue, <String>[
        'Assault Rifle',
        'Sniper',
      ]);

      container.read(wikiSearchQueryProvider.notifier).setQuery('precision');
      await Future<void>.delayed(Duration.zero);

      expect(
        container
            .read(filteredWikiWeaponsProvider)
            .requireValue
            .map((weapon) => weapon.name)
            .toList(),
        <String>['Viper One'],
      );

      container.read(wikiSearchQueryProvider.notifier).setQuery('');
      container
          .read(wikiSelectedCategoryProvider.notifier)
          .setCategory('Assault Rifle');
      await Future<void>.delayed(Duration.zero);

      expect(
        container
            .read(filteredWikiWeaponsProvider)
            .requireValue
            .map((weapon) => weapon.name)
            .toList(),
        <String>['Helios AR'],
      );
    });
  });
}
