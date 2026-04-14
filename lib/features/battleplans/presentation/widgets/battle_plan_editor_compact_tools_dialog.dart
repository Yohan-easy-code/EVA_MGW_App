import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/core/assets/map_floor_asset_catalog.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_controller.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_playback_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_playback_controls.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_palette.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

typedef StepAsyncAction = Future<void> Function(BattlePlanStep step);

class BattlePlanEditorCompactToolsDialog extends ConsumerWidget {
  const BattlePlanEditorCompactToolsDialog({
    required this.session,
    required this.controller,
    required this.onSelectMap,
    required this.onSelectStep,
    required this.onCreateStep,
    required this.onDuplicateSpecificStep,
    required this.onDeleteSpecificStep,
    required this.onRenameSpecificStep,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
    required this.onAddElement,
    required this.onSelectColor,
    required this.onEditSelected,
    required this.onDuplicateSelected,
    required this.onDeleteSelected,
    super.key,
  });

  final BattlePlanEditorSession session;
  final BattlePlanEditorController controller;
  final ValueChanged<MapAsset> onSelectMap;
  final ValueChanged<BattlePlanStep> onSelectStep;
  final VoidCallback onCreateStep;
  final StepAsyncAction onDuplicateSpecificStep;
  final StepAsyncAction onDeleteSpecificStep;
  final StepAsyncAction onRenameSpecificStep;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;
  final ValueChanged<PlanElementType> onAddElement;
  final ValueChanged<int> onSelectColor;
  final VoidCallback onEditSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<MapAsset>> mapAssets = ref.watch(
      battlePlanEditorMapAssetsProvider,
    );
    final AsyncValue<Set<String>> mapAssetPaths = ref.watch(
      battlePlanMapAssetPathsProvider,
    );
    final AsyncValue<List<BattlePlanStep>> steps = ref.watch(
      battlePlanStepsProvider(session.battlePlan.id),
    );
    final BattlePlanTimelineViewState timelineState = ref.watch(
      battlePlanTimelineStateProvider(session.battlePlan.id),
    );
    final BattlePlanStep? currentStep = ref.watch(
      currentBattlePlanStepProvider(session.battlePlan.id),
    );
    final BattlePlanPlaybackState playbackState = ref.watch(
      battlePlanPlaybackControllerProvider(session.battlePlan.id),
    );

    if (currentStep == null) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    final AsyncValue<List<PlanElement>> elements = ref.watch(
      battlePlanStepElementsProvider(currentStep.id),
    );

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Outils tactiques',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(BattlePlanEditorIcons.close),
                  tooltip: 'Fermer',
                ),
              ],
            ),
          ),
          Expanded(
            child: elements.when(
              data: (List<PlanElement> items) {
                final PlanElement? selectedElement = controller
                    .selectedElementFrom(items);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: <Widget>[
                    _CompactSection(
                      title: 'Lecture',
                      child: BattlePlanPlaybackControls(
                        state: playbackState,
                        compact: true,
                        onPlay: onPlay,
                        onPause: onPause,
                        onStop: onStop,
                        onPreviousStep: onPreviousStep,
                        onNextStep: onNextStep,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CompactSection(
                      title: 'Etapes',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: timelineState.isMutating
                                ? null
                                : onCreateStep,
                            icon: const Icon(BattlePlanEditorIcons.add),
                            label: const Text('Ajouter une etape'),
                          ),
                          const SizedBox(height: 12),
                          steps.when(
                            data: (List<BattlePlanStep> value) {
                              if (value.isEmpty) {
                                return const _InlineHint(
                                  label: 'Aucune etape disponible.',
                                );
                              }

                              return Column(
                                children: value
                                    .map(
                                      (BattlePlanStep step) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: _CompactStepTile(
                                          step: step,
                                          isCurrent: step.id == currentStep.id,
                                          isDisabled: timelineState.isMutating,
                                          onTap: () => onSelectStep(step),
                                          onRename: () async {
                                            await onRenameSpecificStep(step);
                                          },
                                          onDuplicate: () async {
                                            await onDuplicateSpecificStep(step);
                                          },
                                          onDelete: () async {
                                            await onDeleteSpecificStep(step);
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(growable: false),
                              );
                            },
                            loading: () => const _InlineHint(
                              label: 'Chargement des etapes...',
                            ),
                            error: (Object error, StackTrace stackTrace) {
                              return _InlineHint(label: error.toString());
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CompactSection(
                      title: 'Cartes',
                      child: mapAssets.when(
                        data: (List<MapAsset> value) {
                          final List<MapAsset> floorOptions =
                              value
                                  .where(
                                    (MapAsset mapAsset) =>
                                        mapAsset.logicalMapName ==
                                        session.mapAsset.logicalMapName,
                                  )
                                  .toList()
                                ..sort(
                                  (MapAsset a, MapAsset b) =>
                                      a.floorNumber.compareTo(b.floorNumber),
                                );
                          final Map<String, List<MapAsset>> mapsByLogicalName =
                              <String, List<MapAsset>>{};
                          for (final MapAsset mapAsset in value) {
                            mapsByLogicalName
                                .putIfAbsent(
                                  mapAsset.logicalMapName,
                                  () => <MapAsset>[],
                                )
                                .add(mapAsset);
                          }
                          for (final List<MapAsset> groupedMaps
                              in mapsByLogicalName.values) {
                            groupedMaps.sort(
                              (MapAsset a, MapAsset b) =>
                                  a.floorNumber.compareTo(b.floorNumber),
                            );
                          }

                          return Column(
                            children: <Widget>[
                              ...mapsByLogicalName.values.map((
                                List<MapAsset> groupedMaps,
                              ) {
                                final MapAsset mapAsset = groupedMaps
                                    .firstWhere(
                                      (MapAsset candidate) =>
                                          candidate.id == session.mapAsset.id,
                                      orElse: () => groupedMaps.first,
                                    );
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _CompactActionTile(
                                    title: mapAsset.logicalMapName,
                                    subtitle: groupedMaps.length > 1
                                        ? '${mapAsset.width} x ${mapAsset.height} • ${groupedMaps.length} etages'
                                        : '${mapAsset.width} x ${mapAsset.height}',
                                    leading: BattlePlanEditorIcons.map,
                                    isSelected:
                                        mapAsset.logicalMapName ==
                                        session.mapAsset.logicalMapName,
                                    onTap:
                                        mapAsset.logicalMapName ==
                                            session.mapAsset.logicalMapName
                                        ? null
                                        : () => onSelectMap(mapAsset),
                                  ),
                                );
                              }),
                              const SizedBox(height: 4),
                              _CompactFloorSection(
                                floors: floorOptions,
                                availableAssetPaths:
                                    mapAssetPaths.asData?.value ??
                                    const <String>{},
                                currentMapAsset: session.mapAsset,
                                onSelectFloor: onSelectMap,
                              ),
                            ],
                          );
                        },
                        loading: () => const _InlineHint(
                          label: 'Chargement des cartes...',
                        ),
                        error: (Object error, StackTrace stackTrace) {
                          return _InlineHint(label: error.toString());
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CompactSection(
                      title: 'Elements',
                      child: Column(
                        children: PlanElementType.values
                            .map(
                              (PlanElementType type) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _CompactActionTile(
                                  title: type.label,
                                  subtitle: type.subtitle,
                                  leading: type.icon,
                                  onTap: () => onAddElement(type),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CompactSection(
                      title: 'Couleurs',
                      child: selectedElement == null
                          ? const _InlineHint(
                              label:
                                  'Selectionne un element pour changer sa couleur.',
                            )
                          : Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: battlePlanEditorColors
                                  .map(
                                    (int colorValue) => _ColorOption(
                                      colorValue: colorValue,
                                      isSelected:
                                          selectedElement.color == colorValue,
                                      onTap: () => onSelectColor(colorValue),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                    ),
                    const SizedBox(height: 12),
                    _CompactSection(
                      title: 'Selection',
                      child: selectedElement == null
                          ? const _InlineHint(
                              label:
                                  'Aucun element selectionne pour le moment.',
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  selectedElement.label?.trim().isNotEmpty ==
                                          true
                                      ? selectedElement.label!
                                      : selectedElement.type,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: <Widget>[
                                    OutlinedButton.icon(
                                      onPressed: controller.isMutating
                                          ? null
                                          : onEditSelected,
                                      icon: const Icon(
                                        BattlePlanEditorIcons.edit,
                                      ),
                                      label: const Text('Editer'),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: controller.isMutating
                                          ? null
                                          : onDuplicateSelected,
                                      icon: const Icon(
                                        BattlePlanEditorIcons.duplicate,
                                      ),
                                      label: const Text('Dupliquer'),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: controller.isMutating
                                          ? null
                                          : onDeleteSelected,
                                      icon: const Icon(
                                        BattlePlanEditorIcons.delete,
                                      ),
                                      label: const Text('Supprimer'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) {
                return Center(child: Text(error.toString()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSection extends StatelessWidget {
  const _CompactSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(56),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(72)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CompactActionTile extends StatelessWidget {
  const _CompactActionTile({
    required this.title,
    required this.subtitle,
    required this.leading,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData leading;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(18)
                : colorScheme.surface.withAlpha(72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withAlpha(136)
                  : colorScheme.outlineVariant.withAlpha(72),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                Icon(
                  leading,
                  size: BattlePlanEditorIcons.panelIconSize,
                  color: isSelected ? colorScheme.primary : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    BattlePlanEditorIcons.active,
                    size: BattlePlanEditorIcons.panelIconSize,
                    color: colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactFloorSection extends StatelessWidget {
  const _CompactFloorSection({
    required this.floors,
    required this.availableAssetPaths,
    required this.currentMapAsset,
    required this.onSelectFloor,
  });

  final List<MapAsset> floors;
  final Set<String> availableAssetPaths;
  final MapAsset currentMapAsset;
  final ValueChanged<MapAsset> onSelectFloor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Map<int, MapAsset> floorsByNumber = <int, MapAsset>{
      for (final MapAsset floor in floors) floor.floorNumber: floor,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Etages',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const <int>[1, 2]
              .map((int floorNumber) {
                final MapAsset? floor = floorsByNumber[floorNumber];
                final bool isSelected =
                    floor?.id == currentMapAsset.id ||
                    currentMapAsset.floorNumber == floorNumber;
                final bool hasFloorAsset = MapFloorAssetCatalog.hasFloorAsset(
                  mapAsset: currentMapAsset,
                  floorNumber: floorNumber,
                  assetPaths: availableAssetPaths,
                );
                final bool isEnabled =
                    floor != null &&
                    (availableAssetPaths.isEmpty || hasFloorAsset);
                return ChoiceChip(
                  label: Text('Etage $floorNumber'),
                  selected: isSelected,
                  onSelected: !isEnabled || isSelected || floor == null
                      ? null
                      : (_) => onSelectFloor(floor),
                  avatar: Icon(
                    BattlePlanEditorIcons.layers,
                    size: BattlePlanEditorIcons.compactIconSize,
                    color: isEnabled
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurface.withAlpha(70),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _CompactStepTile extends StatelessWidget {
  const _CompactStepTile({
    required this.step,
    required this.isCurrent,
    required this.isDisabled,
    required this.onTap,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
  });

  final BattlePlanStep step;
  final bool isCurrent;
  final bool isDisabled;
  final VoidCallback onTap;
  final Future<void> Function() onRename;
  final Future<void> Function() onDuplicate;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isCurrent
                ? colorScheme.primary.withAlpha(18)
                : colorScheme.surface.withAlpha(72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent
                  ? colorScheme.primary.withAlpha(136)
                  : colorScheme.outlineVariant.withAlpha(72),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        step.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Etape ${step.orderIndex + 1}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_StepSheetMenuAction>(
                  enabled: !isDisabled,
                  icon: const Icon(BattlePlanEditorIcons.more),
                  tooltip: 'Actions',
                  onSelected: (_StepSheetMenuAction action) async {
                    switch (action) {
                      case _StepSheetMenuAction.rename:
                        await onRename();
                      case _StepSheetMenuAction.duplicate:
                        await onDuplicate();
                      case _StepSheetMenuAction.delete:
                        await onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      const <PopupMenuEntry<_StepSheetMenuAction>>[
                        PopupMenuItem<_StepSheetMenuAction>(
                          value: _StepSheetMenuAction.rename,
                          child: Text('Renommer'),
                        ),
                        PopupMenuItem<_StepSheetMenuAction>(
                          value: _StepSheetMenuAction.duplicate,
                          child: Text('Dupliquer'),
                        ),
                        PopupMenuItem<_StepSheetMenuAction>(
                          value: _StepSheetMenuAction.delete,
                          child: Text('Supprimer'),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _StepSheetMenuAction { rename, duplicate, delete }

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.colorValue,
    required this.isSelected,
    required this.onTap,
  });

  final int colorValue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(colorValue);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withAlpha(90),
              blurRadius: isSelected ? 14 : 8,
            ),
          ],
        ),
        child: SizedBox(
          width: 42,
          height: 42,
          child: isSelected
              ? Icon(
                  Icons.check_rounded,
                  color: color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

class _InlineHint extends StatelessWidget {
  const _InlineHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
