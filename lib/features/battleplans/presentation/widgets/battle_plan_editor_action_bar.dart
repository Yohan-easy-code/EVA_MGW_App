import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';

class BattlePlanEditorActionBar extends StatelessWidget {
  const BattlePlanEditorActionBar({
    required this.isMutating,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    super.key,
  });

  final bool isMutating;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF131C25).withAlpha(235),
                border: Border.all(
                  color: colorScheme.outlineVariant.withAlpha(120),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: isMutating ? null : onEdit,
                        icon: const Icon(BattlePlanEditorIcons.edit),
                        label: const Text('Editer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: isMutating ? null : onDuplicate,
                        icon: const Icon(BattlePlanEditorIcons.duplicate),
                        label: const Text('Dupliquer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: isMutating ? null : onDelete,
                        style: FilledButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                        icon: const Icon(BattlePlanEditorIcons.delete),
                        label: const Text('Supprimer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
