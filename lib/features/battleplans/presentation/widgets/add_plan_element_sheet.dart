import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

Future<PlanElementType?> showAddPlanElementSheet(BuildContext context) {
  return showModalBottomSheet<PlanElementType>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    builder: (BuildContext context) {
      return SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: PlanElementType.values.length,
            itemBuilder: (BuildContext context, int index) {
              final PlanElementType type = PlanElementType.values[index];

              return ListTile(
                leading: Icon(
                  type.icon,
                  size: BattlePlanEditorIcons.panelIconSize,
                ),
                title: Text(type.label),
                subtitle: Text(type.subtitle),
                onTap: () => Navigator.of(context).pop(type),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1),
          ),
        ),
      );
    },
  );
}
