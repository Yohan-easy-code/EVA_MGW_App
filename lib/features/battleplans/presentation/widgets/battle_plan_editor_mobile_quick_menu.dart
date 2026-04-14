import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanEditorMobileQuickMenu extends StatelessWidget {
  const BattlePlanEditorMobileQuickMenu({
    required this.isMutating,
    required this.onAddElement,
    super.key,
  });

  final bool isMutating;
  final ValueChanged<PlanElementType> onAddElement;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'battleplan-mobile-quick-menu',
      onPressed: isMutating ? null : () => _openActionsSheet(context),
      icon: const Icon(BattlePlanEditorIcons.add),
      label: const Text('Ajouter'),
    );
  }

  Future<void> _openActionsSheet(BuildContext context) async {
    final List<_QuickAction> actions = PlanElementType.values
        .map(
          (PlanElementType type) => _QuickAction(
            icon: type.icon,
            label: type.label,
            subtitle: type.subtitle,
            onTap: () => onAddElement(type),
          ),
        )
        .toList(growable: false);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.58,
            minChildSize: 0.4,
            maxChildSize: 0.88,
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 12, 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Ajouter un element',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(BattlePlanEditorIcons.close),
                          tooltip: 'Fermer',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemBuilder: (BuildContext context, int index) {
                        final _QuickAction action = actions[index];
                        return _QuickActionTile(
                          action: action,
                          onTap: () {
                            Navigator.of(context).pop();
                            action.onTap();
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                      itemCount: actions.length,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action, required this.onTap});

  final _QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color accentColor = colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface.withAlpha(242),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withAlpha(120)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withAlpha(45),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  action.icon,
                  size: BattlePlanEditorIcons.mapGlyphSize,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      action.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                BattlePlanEditorIcons.forward,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
