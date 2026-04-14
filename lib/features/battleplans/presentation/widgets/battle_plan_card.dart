import 'package:flutter/material.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

class BattlePlanCard extends StatelessWidget {
  const BattlePlanCard({
    required this.battlePlan,
    required this.mapAsset,
    required this.onDelete,
    this.onOpen,
    super.key,
  });

  final BattlePlan battlePlan;
  final MapAsset? mapAsset;
  final VoidCallback? onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String mapLabel = switch (mapAsset) {
      final MapAsset value => 'Carte: ${value.displayName}',
      null => 'Carte associee introuvable.',
    };

    return AppSectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  battlePlan.name,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Supprimer',
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mapLabel,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mis a jour: ${formatBattlePlanDateTime(battlePlan.updatedAt)}',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_full_rounded),
              label: const Text('Ouvrir l\'editeur'),
            ),
          ),
        ],
      ),
    );
  }
}

String formatBattlePlanDateTime(DateTime value) {
  final DateTime local = value.toLocal();
  final String day = local.day.toString().padLeft(2, '0');
  final String month = local.month.toString().padLeft(2, '0');
  final String hour = local.hour.toString().padLeft(2, '0');
  final String minute = local.minute.toString().padLeft(2, '0');

  return '$day/$month/${local.year} $hour:$minute';
}
