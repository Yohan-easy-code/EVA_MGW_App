import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/core/assets/map_floor_asset_catalog.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_section_card.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_playback_controls.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_palette.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

typedef StepAsyncAction = Future<void> Function(BattlePlanStep step);

class BattlePlanEditorSidePanel extends ConsumerStatefulWidget {
  const BattlePlanEditorSidePanel({
    required this.battlePlanId,
    required this.currentMapAsset,
    required this.elements,
    required this.selectedElement,
    required this.isMutating,
    required this.isCompact,
    required this.onSelectMap,
    required this.onSelectStep,
    required this.onCreateStep,
    required this.onDuplicateStep,
    required this.onDeleteStep,
    required this.onRenameStep,
    required this.onDuplicateSpecificStep,
    required this.onDeleteSpecificStep,
    required this.onRenameSpecificStep,
    required this.playbackState,
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

  final int battlePlanId;
  final MapAsset currentMapAsset;
  final List<PlanElement> elements;
  final PlanElement? selectedElement;
  final bool isMutating;
  final bool isCompact;
  final ValueChanged<MapAsset> onSelectMap;
  final ValueChanged<BattlePlanStep> onSelectStep;
  final VoidCallback onCreateStep;
  final VoidCallback onDuplicateStep;
  final VoidCallback onDeleteStep;
  final VoidCallback onRenameStep;
  final StepAsyncAction onDuplicateSpecificStep;
  final StepAsyncAction onDeleteSpecificStep;
  final StepAsyncAction onRenameSpecificStep;
  final BattlePlanPlaybackState playbackState;
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
  ConsumerState<BattlePlanEditorSidePanel> createState() =>
      _BattlePlanEditorSidePanelState();
}

class _BattlePlanEditorSidePanelState
    extends ConsumerState<BattlePlanEditorSidePanel> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<MapAsset>> mapAssets = ref.watch(
      battlePlanEditorMapAssetsProvider,
    );
    final AsyncValue<Set<String>> mapAssetPaths = ref.watch(
      battlePlanMapAssetPathsProvider,
    );
    final AsyncValue<List<BattlePlanStep>> steps = ref.watch(
      battlePlanStepsProvider(widget.battlePlanId),
    );
    final BattlePlanTimelineViewState timelineState = ref.watch(
      battlePlanTimelineStateProvider(widget.battlePlanId),
    );
    final BattlePlanStep? currentStep = ref.watch(
      currentBattlePlanStepProvider(widget.battlePlanId),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Theme.of(context).colorScheme.surface.withAlpha(130),
            Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(58),
          ],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: !widget.isCompact,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(widget.isCompact ? 16 : 14),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _PanelHeader(
                      selectedElement: widget.selectedElement,
                      elementsCount: widget.elements.length,
                      currentMapName: widget.currentMapAsset.displayName,
                    ),
                    const SizedBox(height: 14),
                    BattlePlanEditorSectionCard(
                      title: 'Cartes',
                      subtitle:
                          'Choisis la map active sans quitter l\'editeur.',
                      icon: BattlePlanEditorIcons.map,
                      child: mapAssets.when(
                        data: (List<MapAsset> maps) {
                          final List<MapAsset> floorOptions =
                              maps
                                  .where(
                                    (MapAsset mapAsset) =>
                                        mapAsset.logicalMapName ==
                                        widget.currentMapAsset.logicalMapName,
                                  )
                                  .toList()
                                ..sort(
                                  (MapAsset a, MapAsset b) =>
                                      a.floorNumber.compareTo(b.floorNumber),
                                );
                          final Map<String, List<MapAsset>> mapsByLogicalName =
                              <String, List<MapAsset>>{};
                          for (final MapAsset mapAsset in maps) {
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ...mapsByLogicalName.values.map((
                                List<MapAsset> groupedMaps,
                              ) {
                                final MapAsset mapAsset = groupedMaps
                                    .firstWhere(
                                      (MapAsset candidate) =>
                                          candidate.id ==
                                          widget.currentMapAsset.id,
                                      orElse: () => groupedMaps.first,
                                    );
                                final bool isCurrent =
                                    mapAsset.logicalMapName ==
                                    widget.currentMapAsset.logicalMapName;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _MapTile(
                                    mapAsset: mapAsset,
                                    floorCount: groupedMaps.length,
                                    isCurrent: isCurrent,
                                    onTap: isCurrent
                                        ? null
                                        : () => widget.onSelectMap(mapAsset),
                                  ),
                                );
                              }),
                              const SizedBox(height: 4),
                              _FloorSelector(
                                floors: floorOptions,
                                availableAssetPaths:
                                    mapAssetPaths.asData?.value ??
                                    const <String>{},
                                currentMapAsset: widget.currentMapAsset,
                                onSelectFloor: widget.onSelectMap,
                              ),
                            ],
                          );
                        },
                        loading: () => const _InlineStateLabel(
                          label: 'Chargement des cartes...',
                        ),
                        error: (Object error, StackTrace stackTrace) {
                          return _InlineStateLabel(label: error.toString());
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    BattlePlanEditorSectionCard(
                      title: 'Etapes',
                      subtitle:
                          'Construit une sequence tactique persistante, prete pour un '
                          'replay anime entre etapes.',
                      icon: BattlePlanEditorIcons.route,
                      child: steps.when(
                        data: (List<BattlePlanStep> value) => _StepsPanel(
                          steps: value,
                          currentStep: currentStep,
                          isMutating: timelineState.isMutating,
                          playbackState: widget.playbackState,
                          onSelectStep: widget.onSelectStep,
                          onCreateStep: widget.onCreateStep,
                          onDuplicateStep: widget.onDuplicateStep,
                          onDeleteStep: widget.onDeleteStep,
                          onRenameStep: widget.onRenameStep,
                          onDuplicateSpecificStep:
                              widget.onDuplicateSpecificStep,
                          onDeleteSpecificStep: widget.onDeleteSpecificStep,
                          onRenameSpecificStep: widget.onRenameSpecificStep,
                          isCompact: widget.isCompact,
                          onPlay: widget.onPlay,
                          onPause: widget.onPause,
                          onStop: widget.onStop,
                          onPreviousStep: widget.onPreviousStep,
                          onNextStep: widget.onNextStep,
                        ),
                        loading: () => const _InlineStateLabel(
                          label: 'Chargement des etapes...',
                        ),
                        error: (Object error, StackTrace stackTrace) {
                          return _InlineStateLabel(label: error.toString());
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    BattlePlanEditorSectionCard(
                      title: 'Couleurs',
                      subtitle:
                          'Applique une couleur a l\'element selectionne pour clarifier '
                          'les roles, intentions et timings.',
                      icon: BattlePlanEditorIcons.palette,
                      child: _ColorPalette(
                        selectedColor: widget.selectedElement?.color,
                        onSelectColor:
                            widget.selectedElement == null || widget.isMutating
                            ? null
                            : widget.onSelectColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BattlePlanEditorSectionCard(
                      title: 'Elements',
                      subtitle:
                          'Ajoute des joueurs, marqueurs, textes, fleches et zones '
                          'directement sur la map.',
                      icon: BattlePlanEditorIcons.elements,
                      child: _ResponsiveToolGrid(
                        children: PlanElementType.values
                            .map(
                              (PlanElementType type) => _SquareToolButton(
                                icon: type.icon,
                                label: type.label,
                                onTap: widget.isMutating
                                    ? null
                                    : () => widget.onAddElement(type),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BattlePlanEditorSectionCard(
                      title: 'Outils',
                      subtitle:
                          'Actions de selection et maintenance rapide sur l\'element actif.',
                      icon: BattlePlanEditorIcons.tools,
                      child: _ToolsSection(
                        selectedElement: widget.selectedElement,
                        isMutating: widget.isMutating,
                        onEditSelected: widget.onEditSelected,
                        onDuplicateSelected: widget.onDuplicateSelected,
                        onDeleteSelected: widget.onDeleteSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.selectedElement,
    required this.elementsCount,
    required this.currentMapName,
  });

  final PlanElement? selectedElement;
  final int elementsCount;
  final String currentMapName;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String selectedLabel =
        selectedElement?.label ??
        PlanElementType.fromStorageKey(selectedElement?.type ?? '')?.label ??
        'Aucune selection';

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.primary.withAlpha(22),
            colorScheme.surfaceContainerHighest.withAlpha(48),
          ],
        ),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Console tactique',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interface d\'edition concue pour poser un battle plan lisible '
              'sur desktop, tablette et mobile.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _MetricChip(
                  icon: BattlePlanEditorIcons.map,
                  label: currentMapName,
                ),
                _MetricChip(
                  icon: BattlePlanEditorIcons.layers,
                  label: '$elementsCount elements',
                ),
                _MetricChip(
                  icon: BattlePlanEditorIcons.selection,
                  label: selectedLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: BattlePlanEditorIcons.compactIconSize,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapTile extends StatelessWidget {
  const _MapTile({
    required this.mapAsset,
    required this.floorCount,
    required this.isCurrent,
    required this.onTap,
  });

  final MapAsset mapAsset;
  final int floorCount;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isCurrent
              ? colorScheme.primary.withAlpha(28)
              : colorScheme.surfaceContainerHighest.withAlpha(58),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withAlpha(160)
                : colorScheme.outlineVariant.withAlpha(80),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              Icon(
                isCurrent
                    ? BattlePlanEditorIcons.active
                    : BattlePlanEditorIcons.map,
                size: BattlePlanEditorIcons.panelIconSize,
                color: isCurrent
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mapAsset.logicalMapName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      floorCount > 1
                          ? '${mapAsset.width} x ${mapAsset.height} • $floorCount etages'
                          : '${mapAsset.width} x ${mapAsset.height}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primary.withAlpha(28)
                      : colorScheme.surface.withAlpha(80),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    isCurrent ? 'ACTIVE' : 'OPEN',
                    style: textTheme.labelSmall?.copyWith(
                      color: isCurrent
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloorSelector extends StatelessWidget {
  const _FloorSelector({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Etages',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
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
                    isSelected
                        ? BattlePlanEditorIcons.active
                        : BattlePlanEditorIcons.layers,
                    size: BattlePlanEditorIcons.compactIconSize,
                    color: !isEnabled
                        ? colorScheme.onSurface.withAlpha(70)
                        : isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _StepsPanel extends StatelessWidget {
  const _StepsPanel({
    required this.steps,
    required this.currentStep,
    required this.isMutating,
    required this.playbackState,
    required this.onSelectStep,
    required this.onCreateStep,
    required this.onDuplicateStep,
    required this.onDeleteStep,
    required this.onRenameStep,
    required this.onDuplicateSpecificStep,
    required this.onDeleteSpecificStep,
    required this.onRenameSpecificStep,
    required this.isCompact,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
  });

  final List<BattlePlanStep> steps;
  final BattlePlanStep? currentStep;
  final bool isMutating;
  final BattlePlanPlaybackState playbackState;
  final ValueChanged<BattlePlanStep> onSelectStep;
  final VoidCallback onCreateStep;
  final VoidCallback onDuplicateStep;
  final VoidCallback onDeleteStep;
  final VoidCallback onRenameStep;
  final StepAsyncAction onDuplicateSpecificStep;
  final StepAsyncAction onDeleteSpecificStep;
  final StepAsyncAction onRenameSpecificStep;
  final bool isCompact;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (isCompact) {
      return _CompactStepsPanel(
        steps: steps,
        currentStep: currentStep,
        isMutating: isMutating,
        playbackState: playbackState,
        onSelectStep: onSelectStep,
        onCreateStep: onCreateStep,
        onPlay: onPlay,
        onPause: onPause,
        onStop: onStop,
        onPreviousStep: onPreviousStep,
        onNextStep: onNextStep,
        onDuplicateStep: onDuplicateSpecificStep,
        onDeleteStep: onDeleteSpecificStep,
        onRenameStep: onRenameSpecificStep,
      );
    }
    final String currentStepLabel = currentStep == null
        ? 'Aucune etape'
        : 'Etape courante: ${currentStep?.title ?? ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(64),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              currentStepLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 10),
        BattlePlanPlaybackControls(
          state: playbackState,
          onPlay: onPlay,
          onPause: onPause,
          onStop: onStop,
          onPreviousStep: onPreviousStep,
          onNextStep: onNextStep,
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isTight = constraints.maxWidth < 300;
            final double minButtonWidth = isTight ? constraints.maxWidth : 136;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _StepActionButton(
                  minWidth: minButtonWidth,
                  icon: BattlePlanEditorIcons.add,
                  label: 'Ajouter',
                  onPressed: isMutating ? null : onCreateStep,
                ),
                _StepActionButton(
                  minWidth: minButtonWidth,
                  icon: BattlePlanEditorIcons.duplicate,
                  label: 'Dupliquer',
                  onPressed: currentStep == null || isMutating
                      ? null
                      : onDuplicateStep,
                ),
                _StepActionButton(
                  minWidth: minButtonWidth,
                  icon: BattlePlanEditorIcons.edit,
                  label: 'Renommer',
                  onPressed: currentStep == null || isMutating
                      ? null
                      : onRenameStep,
                ),
                _StepActionButton(
                  minWidth: minButtonWidth,
                  icon: BattlePlanEditorIcons.delete,
                  label: 'Supprimer',
                  foregroundColor: colorScheme.error,
                  onPressed: currentStep == null || isMutating
                      ? null
                      : onDeleteStep,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Column(
          children: steps
              .map((BattlePlanStep step) {
                final bool isActive = currentStep?.id == step.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _StepPreviewTile(
                    index: step.orderIndex + 1,
                    title: step.title,
                    subtitle: isActive ? 'Active' : 'Disponible',
                    isActive: isActive,
                    accentColor: isActive ? null : colorScheme.secondary,
                    onTap: () => onSelectStep(step),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _CompactStepsPanel extends StatelessWidget {
  const _CompactStepsPanel({
    required this.steps,
    required this.currentStep,
    required this.isMutating,
    required this.playbackState,
    required this.onSelectStep,
    required this.onCreateStep,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
    required this.onDuplicateStep,
    required this.onDeleteStep,
    required this.onRenameStep,
  });

  final List<BattlePlanStep> steps;
  final BattlePlanStep? currentStep;
  final bool isMutating;
  final BattlePlanPlaybackState playbackState;
  final ValueChanged<BattlePlanStep> onSelectStep;
  final VoidCallback onCreateStep;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;
  final StepAsyncAction onDuplicateStep;
  final StepAsyncAction onDeleteStep;
  final StepAsyncAction onRenameStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: BattlePlanPlaybackControls(
                state: playbackState,
                compact: true,
                showStatusLabel: false,
                onPlay: onPlay,
                onPause: onPause,
                onStop: onStop,
                onPreviousStep: onPreviousStep,
                onNextStep: onNextStep,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonalIcon(
              onPressed: isMutating ? null : onCreateStep,
              icon: const Icon(BattlePlanEditorIcons.add),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: steps
              .map(
                (BattlePlanStep step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _CompactStepTile(
                    step: step,
                    isActive: currentStep?.id == step.id,
                    isMutating: isMutating,
                    onTap: () => onSelectStep(step),
                    onRenameStep: () => onRenameStep(step),
                    onDuplicateStep: () => onDuplicateStep(step),
                    onDeleteStep: () => onDeleteStep(step),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _StepActionButton extends StatelessWidget {
  const _StepActionButton({
    required this.minWidth,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.foregroundColor,
  });

  final double minWidth;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        style: foregroundColor == null
            ? null
            : FilledButton.styleFrom(foregroundColor: foregroundColor),
        icon: Icon(icon),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}

class _StepPreviewTile extends StatelessWidget {
  const _StepPreviewTile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.isActive,
    this.accentColor,
    this.onTap,
  });

  final int index;
  final String title;
  final String subtitle;
  final bool isActive;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color effectiveColor = accentColor ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: effectiveColor.withAlpha(isActive ? 22 : 12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: effectiveColor.withAlpha(isActive ? 110 : 70),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor: effectiveColor.withAlpha(36),
                child: Text('$index'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive) const Icon(BattlePlanEditorIcons.play),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactStepTile extends StatelessWidget {
  const _CompactStepTile({
    required this.step,
    required this.isActive,
    required this.isMutating,
    required this.onTap,
    required this.onRenameStep,
    required this.onDuplicateStep,
    required this.onDeleteStep,
  });

  final BattlePlanStep step;
  final bool isActive;
  final bool isMutating;
  final VoidCallback onTap;
  final Future<void> Function() onRenameStep;
  final Future<void> Function() onDuplicateStep;
  final Future<void> Function() onDeleteStep;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color accentColor = isActive
        ? colorScheme.primary
        : colorScheme.secondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: accentColor.withAlpha(isActive ? 20 : 10),
          border: Border.all(color: accentColor.withAlpha(isActive ? 120 : 64)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 14,
                backgroundColor: accentColor.withAlpha(32),
                child: Text('${step.orderIndex + 1}'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      step.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    Text(
                      isActive ? 'Active' : 'Toucher pour activer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Icon(BattlePlanEditorIcons.play, size: 18, color: accentColor),
              PopupMenuButton<_StepMenuAction>(
                enabled: !isMutating,
                tooltip: 'Actions de l\'etape',
                icon: const Icon(BattlePlanEditorIcons.more),
                onSelected: (_StepMenuAction value) async {
                  switch (value) {
                    case _StepMenuAction.rename:
                      await onRenameStep();
                    case _StepMenuAction.duplicate:
                      await onDuplicateStep();
                    case _StepMenuAction.delete:
                      await onDeleteStep();
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<_StepMenuAction>>[
                      const PopupMenuItem<_StepMenuAction>(
                        value: _StepMenuAction.rename,
                        child: _StepMenuItemLabel(
                          icon: BattlePlanEditorIcons.edit,
                          label: 'Renommer',
                        ),
                      ),
                      const PopupMenuItem<_StepMenuAction>(
                        value: _StepMenuAction.duplicate,
                        child: _StepMenuItemLabel(
                          icon: BattlePlanEditorIcons.duplicate,
                          label: 'Dupliquer',
                        ),
                      ),
                      const PopupMenuItem<_StepMenuAction>(
                        value: _StepMenuAction.delete,
                        child: _StepMenuItemLabel(
                          icon: BattlePlanEditorIcons.delete,
                          label: 'Supprimer',
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _StepMenuAction { rename, duplicate, delete }

class _StepMenuItemLabel extends StatelessWidget {
  const _StepMenuItemLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: BattlePlanEditorIcons.compactIconSize),
        const SizedBox(width: 10),
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette({
    required this.selectedColor,
    required this.onSelectColor,
  });

  final int? selectedColor;
  final ValueChanged<int>? onSelectColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxExtent = constraints.maxWidth < 280 ? 72 : 82;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxExtent,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: battlePlanEditorColors.length,
          itemBuilder: (BuildContext context, int index) {
            final int colorValue = battlePlanEditorColors[index];
            final Color color = Color(colorValue);
            final bool isSelected = selectedColor == colorValue;

            return GestureDetector(
              onTap: onSelectColor == null
                  ? null
                  : () => onSelectColor!(colorValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: color,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withAlpha(110),
                    width: isSelected ? 3 : 1.5,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withAlpha(onSelectColor == null ? 25 : 80),
                      blurRadius: isSelected ? 16 : 10,
                    ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}

class _ResponsiveToolGrid extends StatelessWidget {
  const _ResponsiveToolGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxExtent = maxWidth < 280 ? 110 : 96;
        final double mainExtent = maxWidth < 280 ? 116 : 108;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxExtent,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: mainExtent,
          ),
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return children[index];
          },
        );
      },
    );
  }
}

class _SquareToolButton extends StatelessWidget {
  const _SquareToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color accentColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.surfaceContainerHighest.withAlpha(78),
          border: Border.all(
            color: onTap == null
                ? colorScheme.outlineVariant.withAlpha(40)
                : accentColor.withAlpha(80),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: BattlePlanEditorIcons.panelIconSize,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: onTap == null ? colorScheme.onSurfaceVariant : null,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolsSection extends StatelessWidget {
  const _ToolsSection({
    required this.selectedElement,
    required this.isMutating,
    required this.onEditSelected,
    required this.onDuplicateSelected,
    required this.onDeleteSelected,
  });

  final PlanElement? selectedElement;
  final bool isMutating;
  final VoidCallback onEditSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (selectedElement == null) {
      return const _InlineStateLabel(
        label: 'Selectionne un element sur la carte pour afficher les actions.',
      );
    }

    final PlanElementType? type = PlanElementType.fromStorageKey(
      selectedElement!.type,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(76),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    type?.icon ?? BattlePlanEditorIcons.selection,
                    size: BattlePlanEditorIcons.panelIconSize,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedElement!.label ?? type?.label ?? 'Element',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _ResponsiveToolGrid(
          children: <Widget>[
            _SquareToolButton(
              icon: BattlePlanEditorIcons.edit,
              label: 'Editer',
              onTap: isMutating ? null : onEditSelected,
            ),
            _SquareToolButton(
              icon: BattlePlanEditorIcons.duplicate,
              label: 'Dupliquer',
              onTap: isMutating ? null : onDuplicateSelected,
            ),
            _SquareToolButton(
              icon: BattlePlanEditorIcons.delete,
              label: 'Supprimer',
              onTap: isMutating ? null : onDeleteSelected,
              isDanger: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _InlineStateLabel extends StatelessWidget {
  const _InlineStateLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.45,
      ),
    );
  }
}
