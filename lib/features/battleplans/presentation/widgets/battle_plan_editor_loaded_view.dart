import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_controller.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_playback_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_mobile_portrait_prompt.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_mobile_view.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_side_panel.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_workspace.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/editor_feedback_widgets.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanEditorLoadedView extends ConsumerStatefulWidget {
  const BattlePlanEditorLoadedView({
    required this.session,
    required this.controller,
    required this.onSelectMap,
    required this.onSelectStep,
    required this.onCreateStep,
    required this.onDuplicateStep,
    required this.onDeleteStep,
    required this.onRenameStep,
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
    required this.onBackPressed,
    required this.onOpenSecondaryMenu,
    super.key,
  });

  final BattlePlanEditorSession session;
  final BattlePlanEditorController controller;
  final ValueChanged<MapAsset> onSelectMap;
  final ValueChanged<BattlePlanStep> onSelectStep;
  final VoidCallback onCreateStep;
  final VoidCallback onDuplicateStep;
  final VoidCallback onDeleteStep;
  final VoidCallback onRenameStep;
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
  final VoidCallback onBackPressed;
  final VoidCallback onOpenSecondaryMenu;

  @override
  ConsumerState<BattlePlanEditorLoadedView> createState() =>
      _BattlePlanEditorLoadedViewState();
}

class _BattlePlanEditorLoadedViewState
    extends ConsumerState<BattlePlanEditorLoadedView> {
  ProviderSubscription<BattlePlanStep?>? _currentStepSubscription;
  ProviderSubscription<AsyncValue<List<PlanElement>>>?
  _stepElementsSubscription;

  @override
  void initState() {
    super.initState();
    _bindControllerSync();
  }

  @override
  void didUpdateWidget(covariant BattlePlanEditorLoadedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.mapAsset.id != widget.session.mapAsset.id) {
      debugPrint(
        '[BattlePlanEditorLoadedView] session map changed '
        'battlePlanId=${widget.session.battlePlan.id} '
        'oldMap="${oldWidget.session.mapAsset.imagePath}" '
        'newMap="${widget.session.mapAsset.imagePath}"',
      );
      _bindControllerSync();
    }
    if (oldWidget.session.battlePlan.id != widget.session.battlePlan.id) {
      _bindControllerSync();
    }
  }

  @override
  void dispose() {
    _currentStepSubscription?.close();
    _stepElementsSubscription?.close();
    super.dispose();
  }

  void _bindControllerSync() {
    _currentStepSubscription?.close();
    _stepElementsSubscription?.close();

    _currentStepSubscription = ref.listenManual<BattlePlanStep?>(
      currentBattlePlanStepProvider(widget.session.battlePlan.id),
      (BattlePlanStep? _, BattlePlanStep? nextStep) {
        widget.controller.setCurrentStep(nextStep?.id);
        _bindStepElementsSync(nextStep?.id);
      },
      fireImmediately: true,
    );
  }

  void _bindStepElementsSync(int? stepId) {
    _stepElementsSubscription?.close();
    if (stepId == null) {
      return;
    }

    _stepElementsSubscription = ref.listenManual<AsyncValue<List<PlanElement>>>(
      battlePlanStepElementsProvider(stepId),
      (
        AsyncValue<List<PlanElement>>? _,
        AsyncValue<List<PlanElement>> nextElements,
      ) {
        nextElements.whenData(widget.controller.syncWithElements);
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final BattlePlanStep? currentStep = ref.watch(
      currentBattlePlanStepProvider(widget.session.battlePlan.id),
    );
    if (currentStep == null) {
      return const EditorLoading(message: 'Chargement de la timeline...');
    }

    final AsyncValue<List<PlanElement>> elements = ref.watch(
      battlePlanStepElementsProvider(currentStep.id),
    );
    final BattlePlanPlaybackState playbackState = ref.watch(
      battlePlanPlaybackControllerProvider(widget.session.battlePlan.id),
    );
    final AsyncValue<List<BattlePlanRenderElement>> renderElements = ref.watch(
      battlePlanPlaybackRenderElementsProvider(widget.session.battlePlan.id),
    );

    return elements.when(
      data: (List<PlanElement> items) {
        final List<BattlePlanRenderElement> displayedElements =
            renderElements.whenOrNull(
              data: (List<BattlePlanRenderElement> value) => value,
            ) ??
            items
                .map(
                  (PlanElement element) =>
                      BattlePlanRenderElement(element: element),
                )
                .toList(growable: false);

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            final bool isMobilePlatform =
                !kIsWeb &&
                (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS);
            final bool isPhone =
                isMobilePlatform && mediaQuery.size.shortestSide < 700;
            final bool isLandscape =
                mediaQuery.orientation == Orientation.landscape;
            final bool isCompact = constraints.maxWidth < 1100;

            if (isPhone && !isLandscape) {
              return const BattlePlanEditorMobilePortraitPrompt();
            }

            if (isPhone && isLandscape) {
              return ListenableBuilder(
                listenable: widget.controller,
                builder: (BuildContext context, Widget? child) {
                  return BattlePlanEditorMobileView(
                    mapAsset: widget.session.mapAsset,
                    currentStep: currentStep,
                    renderElements: displayedElements,
                    controller: widget.controller,
                    playbackState: playbackState,
                    onBackPressed: widget.onBackPressed,
                    onOpenSecondaryMenu: widget.onOpenSecondaryMenu,
                    onAddElement: widget.onAddElement,
                    onEditSelected: widget.onEditSelected,
                    onDuplicateSelected: widget.onDuplicateSelected,
                    onDeleteSelected: widget.onDeleteSelected,
                    onPlay: widget.onPlay,
                    onPause: widget.onPause,
                    onStop: widget.onStop,
                    onPreviousStep: widget.onPreviousStep,
                    onNextStep: widget.onNextStep,
                  );
                },
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (!isCompact)
                  SizedBox(
                    width: 280,
                    child: ListenableBuilder(
                      listenable: widget.controller,
                      builder: (BuildContext context, Widget? child) {
                        return BattlePlanEditorSidePanel(
                          battlePlanId: widget.session.battlePlan.id,
                          currentMapAsset: widget.session.mapAsset,
                          elements: items,
                          selectedElement: widget.controller
                              .selectedElementFrom(items),
                          isMutating: widget.controller.isMutating,
                          isCompact: false,
                          onSelectMap: widget.onSelectMap,
                          onSelectStep: widget.onSelectStep,
                          onCreateStep: widget.onCreateStep,
                          onDuplicateStep: widget.onDuplicateStep,
                          onDeleteStep: widget.onDeleteStep,
                          onRenameStep: widget.onRenameStep,
                          onDuplicateSpecificStep:
                              widget.onDuplicateSpecificStep,
                          onDeleteSpecificStep: widget.onDeleteSpecificStep,
                          onRenameSpecificStep: widget.onRenameSpecificStep,
                          playbackState: playbackState,
                          onPlay: widget.onPlay,
                          onPause: widget.onPause,
                          onStop: widget.onStop,
                          onPreviousStep: widget.onPreviousStep,
                          onNextStep: widget.onNextStep,
                          onAddElement: widget.onAddElement,
                          onSelectColor: widget.onSelectColor,
                          onEditSelected: widget.onEditSelected,
                          onDuplicateSelected: widget.onDuplicateSelected,
                          onDeleteSelected: widget.onDeleteSelected,
                        );
                      },
                    ),
                  ),
                if (!isCompact) const SizedBox(width: 12),
                Expanded(
                  child: ListenableBuilder(
                    listenable: widget.controller,
                    builder: (BuildContext context, Widget? child) {
                      return BattlePlanEditorWorkspace(
                        mapAsset: widget.session.mapAsset,
                        renderElements: displayedElements,
                        controller: widget.controller,
                        isCompact: isCompact,
                        playbackState: playbackState,
                        onPlay: widget.onPlay,
                        onPause: widget.onPause,
                        onStop: widget.onStop,
                        onPreviousStep: widget.onPreviousStep,
                        onNextStep: widget.onNextStep,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const EditorLoading(
        message: 'Chargement des elements du battleplan...',
      ),
      error: (Object error, StackTrace stackTrace) => EditorError(
        title: 'Elements indisponibles',
        message: error.toString(),
      ),
    );
  }
}
