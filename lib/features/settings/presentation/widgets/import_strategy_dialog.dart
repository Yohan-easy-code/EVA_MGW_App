import 'package:flutter/material.dart';
import 'package:mgw_eva/data/local/storage/json_transfer_models.dart';

class ImportStrategyDialog extends StatelessWidget {
  const ImportStrategyDialog({required this.conflicts, super.key});

  final JsonImportConflictSummary conflicts;

  @override
  Widget build(BuildContext context) {
    final String summary = conflicts.hasConflicts
        ? 'Conflits detectes: ${conflicts.mapAssets} cartes, ${conflicts.weapons} armes, ${conflicts.battlePlans} battleplans, ${conflicts.planElements} elements.'
        : 'Aucun conflit detecte. Tu peux importer sans remplacement des donnees deja presentes.';

    return AlertDialog(
      title: const Text('Strategie d\'import JSON'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(summary),
          const SizedBox(height: 16),
          const Text(
            'Choisis explicitement la strategie pour eviter un remplacement silencieux des donnees locales.',
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(JsonImportConflictStrategy.abortOnConflict),
          child: const Text('Bloquer si conflit'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.of(
            context,
          ).pop(JsonImportConflictStrategy.keepExisting),
          child: const Text('Conserver l\'existant'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(JsonImportConflictStrategy.replaceExisting),
          child: const Text('Remplacer local'),
        ),
      ],
    );
  }
}
