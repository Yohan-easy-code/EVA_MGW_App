import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

class WikiSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value;
  }
}

class WikiSelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCategory(String? value) {
    state = value;
  }
}

final wikiSearchQueryProvider =
    NotifierProvider<WikiSearchQueryNotifier, String>(
      WikiSearchQueryNotifier.new,
    );

final wikiSelectedCategoryProvider =
    NotifierProvider<WikiSelectedCategoryNotifier, String?>(
      WikiSelectedCategoryNotifier.new,
    );

final wikiWeaponsProvider = StreamProvider.autoDispose<List<Weapon>>((Ref ref) {
  return ref.watch(weaponRepositoryProvider).watchWeapons();
});

final wikiCategoriesProvider = Provider.autoDispose<AsyncValue<List<String>>>((
  Ref ref,
) {
  final AsyncValue<List<Weapon>> weapons = ref.watch(wikiWeaponsProvider);

  return weapons.whenData((List<Weapon> items) {
    final Set<String> categories = items
        .map((Weapon weapon) => weapon.category.trim())
        .where((String category) => category.isNotEmpty)
        .toSet();
    final List<String> sortedCategories = categories.toList()..sort();

    return sortedCategories;
  });
});

final filteredWikiWeaponsProvider =
    Provider.autoDispose<AsyncValue<List<Weapon>>>((Ref ref) {
      final AsyncValue<List<Weapon>> weapons = ref.watch(wikiWeaponsProvider);
      final String query = ref
          .watch(wikiSearchQueryProvider)
          .trim()
          .toLowerCase();
      final String? selectedCategory = ref.watch(wikiSelectedCategoryProvider);

      return weapons.whenData((List<Weapon> items) {
        return items.where((Weapon weapon) {
          final bool matchesCategory = selectedCategory == null
              ? true
              : weapon.category == selectedCategory;
          final bool matchesQuery = query.isEmpty
              ? true
              : weapon.name.toLowerCase().contains(query) ||
                    weapon.category.toLowerCase().contains(query) ||
                    weapon.description.toLowerCase().contains(query);

          return matchesCategory && matchesQuery;
        }).toList();
      });
    });
