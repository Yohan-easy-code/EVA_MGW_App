import 'package:flutter/material.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';

class BattlePlansEmptyState extends StatelessWidget {
  const BattlePlansEmptyState({
    required this.hasMaps,
    required this.onCreatePressed,
    super.key,
  });

  final bool hasMaps;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppSectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(24),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Base locale prete',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Aucun battleplan pour le moment.',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hasMaps
                ? 'Cree un premier battleplan et choisis une carte locale pour ouvrir l\'editeur.'
                : 'Aucune carte locale disponible. Verifie le seed local.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCreatePressed,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Creer un battleplan'),
            ),
          ),
        ],
      ),
    );
  }
}
