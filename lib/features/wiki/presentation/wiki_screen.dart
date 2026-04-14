import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/core/constants/app_constants.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/logic/wiki_list_providers.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_card.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/wiki_category_filters.dart';

class WikiScreen extends StatelessWidget {
  const WikiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WikiListScreen();
  }
}

class WikiListScreen extends ConsumerStatefulWidget {
  const WikiListScreen({super.key});

  @override
  ConsumerState<WikiListScreen> createState() => _WikiListScreenState();
}

class _WikiListScreenState extends ConsumerState<WikiListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<String>> categories = ref.watch(
      wikiCategoriesProvider,
    );
    final AsyncValue<List<Weapon>> weapons = ref.watch(
      filteredWikiWeaponsProvider,
    );
    final String query = ref.watch(wikiSearchQueryProvider);
    final String? selectedCategory = ref.watch(wikiSelectedCategoryProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (_searchController.text != query) {
      _searchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return AppPageBackground(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppFadeSlideIn(
                    child: AppPageHeader(
                      title: AppConstants.wikiLabel,
                      subtitle:
                          'Catalogue local des armes avec recherche et filtres '
                          'rapides, entierement hors ligne.',
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 70),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (String value) {
                        ref
                            .read(wikiSearchQueryProvider.notifier)
                            .setQuery(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(wikiSearchQueryProvider.notifier)
                                      .setQuery('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                        hintText: 'Rechercher une arme, categorie, description',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  categories.when(
                    data: (List<String> items) {
                      return AppFadeSlideIn(
                        delay: const Duration(milliseconds: 120),
                        child: WikiCategoryFilters(
                          categories: items,
                          selectedCategory: selectedCategory,
                          onCategorySelected: (String? value) {
                            ref
                                .read(wikiSelectedCategoryProvider.notifier)
                                .setCategory(value);
                          },
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 44,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (Object error, StackTrace stackTrace) {
                      return Text(
                        error.toString(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: weapons.when(
                data: (List<Weapon> items) {
                  if (items.isEmpty) {
                    return _WikiEmptyState(
                      hasActiveFilter:
                          query.trim().isNotEmpty || selectedCategory != null,
                    );
                  }

                  return AnimatedSwitcher(
                    duration: UiTokens.medium,
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: ListView.separated(
                      key: ValueKey<String>(
                        'wiki-${selectedCategory ?? 'all'}-$query-${items.length}',
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                      itemCount: items.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 14);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return AppFadeSlideIn(
                          delay: Duration(
                            milliseconds: 40 * (index.clamp(0, 4)),
                          ),
                          child: WeaponCard(weapon: items[index]),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WikiEmptyState extends StatelessWidget {
  const _WikiEmptyState({required this.hasActiveFilter});

  final bool hasActiveFilter;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              hasActiveFilter
                  ? Icons.search_off_rounded
                  : Icons.auto_stories_outlined,
              size: 44,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 14),
            Text(
              hasActiveFilter
                  ? 'Aucune arme ne correspond aux filtres.'
                  : 'Aucune arme disponible dans la base locale.',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
