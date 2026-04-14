import 'package:flutter/material.dart';

class WikiCategoryFilters extends StatelessWidget {
  const WikiCategoryFilters({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('Tous'),
              selected: selectedCategory == null,
              onSelected: (_) => onCategorySelected(null),
              avatar: selectedCategory == null
                  ? const Icon(Icons.done_rounded, size: 16)
                  : null,
            );
          }

          final String category = categories[index - 1];

          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (_) => onCategorySelected(category),
            avatar: selectedCategory == category
                ? const Icon(Icons.done_rounded, size: 16)
                : null,
          );
        },
      ),
    );
  }
}
