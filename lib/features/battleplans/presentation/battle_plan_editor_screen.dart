import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_controller.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_service.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_playback_providers.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/add_plan_element_sheet.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_action_bar.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_compact_tools_dialog.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_loaded_view.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/edit_plan_element_sheet.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/editor_feedback_widgets.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanEditorScreen extends ConsumerStatefulWidget {
  const BattlePlanEditorScreen({
    required this.battlePlanId,
    required this.battlePlanName,
    required this.mapAssetPath,
    super.key,
  });

  final int? battlePlanId;
  final String battlePlanName;
  final String mapAssetPath;

  @override
  ConsumerState<BattlePlanEditorScreen> createState() =>
      _BattlePlanEditorScreenState();
}

class _BattlePlanEditorScreenState extends ConsumerState<BattlePlanEditorScreen>
    with WidgetsBindingObserver {
  static const List<DeviceOrientation> _defaultOrientations =
      DeviceOrientation.values;
  static const List<DeviceOrientation> _mobileLandscapeOrientations =
      <DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];

  late final BattlePlanEditorController _controller;
  bool _allowPop = false;
  bool _isFlushingBeforePop = false;
  bool _orientationConfigured = false;

  BattlePlanEditorArgs get _args {
    return BattlePlanEditorArgs(
      battlePlanId: widget.battlePlanId,
      battlePlanName: widget.battlePlanName,
      mapAssetPath: widget.mapAssetPath,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = BattlePlanEditorController(
      ref.read(battlePlanEditorServiceProvider),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_orientationConfigured) {
      return;
    }

    _orientationConfigured = true;
    unawaited(_configureEditorOrientation());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(SystemChrome.setPreferredOrientations(_defaultOrientations));
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_controller.flushPendingPositionSaves());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mapAssetPath.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              debugPrint('[Navigation] back from invalid battlePlanEditor');
              if (context.canPop()) {
                context.pop();
                return;
              }

              context.goNamed(RouteNames.battleplans);
            },
            icon: const Icon(BattlePlanEditorIcons.back),
            tooltip: 'Retour',
          ),
          title: Text(widget.battlePlanName),
        ),
        body: const EditorError(
          title: 'Route invalide',
          message: 'Aucun chemin de carte n\'a ete fourni pour cet editeur.',
        ),
      );
    }

    final AsyncValue<BattlePlanEditorSession> session = ref.watch(
      battlePlanEditorSessionProvider(_args),
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double width = mediaQuery.size.width;
    final bool isCompactLayout = width < 1100;
    final bool isPhone = _isPhoneLayout(mediaQuery);
    final bool isMobileLandscape =
        isPhone && mediaQuery.orientation == Orientation.landscape;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope<Object?>(
      canPop: _allowPop,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        appBar: isMobileLandscape
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: _handleBackPressed,
                  icon: const Icon(BattlePlanEditorIcons.back),
                  tooltip: 'Retour',
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.battlePlanName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'BattlePlan Editor v1',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  if (isCompactLayout)
                    session.when(
                      data: (BattlePlanEditorSession value) {
                        return IconButton(
                          onPressed: () => _openCompactTools(value),
                          icon: const Icon(BattlePlanEditorIcons.more),
                          tooltip: 'Outils',
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (Object error, StackTrace stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                ],
              ),
        floatingActionButton: isMobileLandscape
            ? null
            : session.when(
                data: (BattlePlanEditorSession value) => isCompactLayout
                    ? ListenableBuilder(
                        listenable: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return FloatingActionButton.extended(
                            onPressed: _controller.isMutating
                                ? null
                                : () => _addElement(value),
                            icon: const Icon(BattlePlanEditorIcons.add),
                            label: const Text('Ajouter'),
                          );
                        },
                      )
                    : null,
                loading: () => null,
                error: (Object error, StackTrace stackTrace) => null,
              ),
        bottomNavigationBar: isMobileLandscape
            ? null
            : isCompactLayout
            ? ListenableBuilder(
                listenable: _controller,
                builder: (BuildContext context, Widget? child) {
                  if (_controller.selectedElementId == null) {
                    return const SizedBox.shrink();
                  }

                  return BattlePlanEditorActionBar(
                    isMutating: _controller.isMutating,
                    onEdit: _editSelected,
                    onDuplicate: _duplicateSelected,
                    onDelete: _deleteSelected,
                  );
                },
              )
            : null,
        body: Padding(
          padding: isMobileLandscape
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: session.when(
            data: _buildLoadedState,
            loading: () => const EditorLoading(
              message: 'Chargement de la session battleplan...',
            ),
            error: (Object error, StackTrace stackTrace) => EditorError(
              title: 'Session battleplan indisponible',
              message: error.toString(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BattlePlanEditorSession session) {
    return BattlePlanEditorLoadedView(
      session: session,
      controller: _controller,
      onSelectMap: _selectMap,
      onSelectStep: _selectStep,
      onCreateStep: () => _createStep(session.battlePlan.id),
      onDuplicateStep: () => _duplicateCurrentStep(session.battlePlan.id),
      onDeleteStep: () => _deleteCurrentStep(session.battlePlan.id),
      onRenameStep: () => _renameCurrentStep(session.battlePlan.id),
      onDuplicateSpecificStep: _duplicateStep,
      onDeleteSpecificStep: _deleteStep,
      onRenameSpecificStep: _renameStep,
      onPlay: () => _playTimeline(session.battlePlan.id),
      onPause: () => _pauseTimeline(session.battlePlan.id),
      onStop: () => _stopTimeline(session.battlePlan.id),
      onPreviousStep: () => _previousPlaybackStep(session.battlePlan.id),
      onNextStep: () => _nextPlaybackStep(session.battlePlan.id),
      onAddElement: (PlanElementType type) =>
          _addElementFromType(session, type),
      onSelectColor: _applyColorToSelected,
      onEditSelected: _editSelected,
      onDuplicateSelected: _duplicateSelected,
      onDeleteSelected: _deleteSelected,
      onBackPressed: _handleBackPressed,
      onOpenSecondaryMenu: () => _openCompactTools(session),
    );
  }

  bool _isPhoneLayout(MediaQueryData mediaQuery) {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) &&
        mediaQuery.size.shortestSide < 700;
  }

  Future<void> _configureEditorOrientation() async {
    if (!mounted) {
      return;
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    if (_isPhoneLayout(mediaQuery)) {
      await SystemChrome.setPreferredOrientations(_mobileLandscapeOrientations);
      return;
    }

    await SystemChrome.setPreferredOrientations(_defaultOrientations);
  }

  Future<void> _addElement(BattlePlanEditorSession session) async {
    final PlanElementType? selectedType = await showAddPlanElementSheet(
      context,
    );
    if (selectedType == null) {
      return;
    }

    await _addElementFromType(session, selectedType);
  }

  Future<void> _addElementFromType(
    BattlePlanEditorSession session,
    PlanElementType selectedType,
  ) async {
    final BattlePlanStep? currentStep = ref.read(
      currentBattlePlanStepProvider(session.battlePlan.id),
    );
    if (currentStep == null) {
      return;
    }

    await _controller.createElement(
      battlePlanId: session.battlePlan.id,
      stepId: currentStep.id,
      type: selectedType,
      mapWidth: session.mapAsset.width.toDouble(),
      mapHeight: session.mapAsset.height.toDouble(),
    );
  }

  Future<void> _applyColorToSelected(int color) async {
    final BattlePlanEditorSession? session = ref
        .read(battlePlanEditorSessionProvider(_args))
        .whenOrNull(data: (BattlePlanEditorSession value) => value);
    final PlanElement? selectedElement = _selectedElement(session);
    final BattlePlanStep? currentStep = session == null
        ? null
        : ref.read(currentBattlePlanStepProvider(session.battlePlan.id));
    if (selectedElement == null) {
      return;
    }
    if (currentStep == null) {
      return;
    }

    await _controller.updateAppearance(
      stepId: currentStep.id,
      element: selectedElement,
      color: color,
      label: selectedElement.label,
    );
  }

  Future<void> _deleteSelected() async {
    await _controller.deleteSelected();
  }

  Future<void> _duplicateSelected() async {
    final BattlePlanEditorSession? session = ref
        .read(battlePlanEditorSessionProvider(_args))
        .whenOrNull(data: (BattlePlanEditorSession value) => value);
    final PlanElement? source = _selectedElement(session);
    final BattlePlanStep? currentStep = session == null
        ? null
        : ref.read(currentBattlePlanStepProvider(session.battlePlan.id));
    if (session == null || source == null || currentStep == null) {
      return;
    }

    await _controller.duplicateElement(
      stepId: currentStep.id,
      source: source,
      mapWidth: session.mapAsset.width.toDouble(),
      mapHeight: session.mapAsset.height.toDouble(),
    );
  }

  Future<void> _editSelected() async {
    final BattlePlanEditorSession? session = ref
        .read(battlePlanEditorSessionProvider(_args))
        .whenOrNull(data: (BattlePlanEditorSession value) => value);
    final PlanElement? selectedElement = _selectedElement(session);
    final BattlePlanStep? currentStep = session == null
        ? null
        : ref.read(currentBattlePlanStepProvider(session.battlePlan.id));
    if (selectedElement == null) {
      return;
    }
    if (currentStep == null) {
      return;
    }

    final PlanElementType? type = PlanElementType.fromStorageKey(
      selectedElement.type,
    );
    if (type == null) {
      return;
    }

    final ElementEditResult? result =
        await showModalBottomSheet<ElementEditResult>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          builder: (BuildContext context) {
            return ElementEditSheet(element: selectedElement, type: type);
          },
        );
    if (result == null) {
      return;
    }

    await _controller.updateAppearance(
      stepId: currentStep.id,
      element: selectedElement,
      color: result.color,
      label: result.label,
    );
  }

  PlanElement? _selectedElement(BattlePlanEditorSession? session) {
    if (session == null) {
      return null;
    }

    final BattlePlanStep? currentStep = ref.read(
      currentBattlePlanStepProvider(session.battlePlan.id),
    );
    if (currentStep == null) {
      return null;
    }

    final List<PlanElement> elements =
        ref
            .read(battlePlanStepElementsProvider(currentStep.id))
            .whenOrNull(data: (List<PlanElement> value) => value) ??
        <PlanElement>[];

    return _controller.selectedElementFrom(elements);
  }

  Future<void> _handleBackPressed() async {
    debugPrint('[Navigation] back pressed in battlePlanEditor');
    await _flushAndPopIfNeeded();
  }

  Future<void> _selectMap(MapAsset mapAsset) async {
    if (mapAsset.imagePath == widget.mapAssetPath) {
      return;
    }

    final BattlePlanEditorSession? session = ref
        .read(battlePlanEditorSessionProvider(_args))
        .whenOrNull(data: (BattlePlanEditorSession value) => value);

    _stopTimelineIfNeeded();
    await _controller.flushPendingPositionSaves();
    if (!mounted) {
      return;
    }

    debugPrint(
      '[Navigation] switch battlePlanEditor id=${session?.battlePlan.id ?? widget.battlePlanId} '
      'oldMap="${widget.mapAssetPath}" newMap="${mapAsset.imagePath}" '
      'name="${widget.battlePlanName}"',
    );
    final String? battlePlanId = session != null
        ? session.battlePlan.id.toString()
        : widget.battlePlanId?.toString();
    context.goNamed(
      RouteNames.battlePlanEditor,
      queryParameters: <String, String>{
        ...?battlePlanId == null ? null : <String, String>{'id': battlePlanId},
        'name': widget.battlePlanName,
        'map': mapAsset.imagePath,
      },
    );
  }

  Future<void> _openCompactTools(BattlePlanEditorSession session) async {
    debugPrint(
      '[BattlePlanEditor] openCompactTools battlePlanId=${session.battlePlan.id}',
    );
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.94;

        return SizedBox(
          height: maxHeight,
          child: BattlePlanEditorCompactToolsDialog(
            session: session,
            controller: _controller,
            onSelectMap: (MapAsset mapAsset) async {
              Navigator.of(context).pop();
              await _selectMap(mapAsset);
            },
            onSelectStep: (BattlePlanStep step) {
              _selectStep(step);
              Navigator.of(context).pop();
            },
            onCreateStep: () async {
              Navigator.of(context).pop();
              await _createStep(session.battlePlan.id);
            },
            onDuplicateSpecificStep: (BattlePlanStep step) async {
              await _duplicateStep(step);
            },
            onDeleteSpecificStep: (BattlePlanStep step) async {
              await _deleteStep(step);
            },
            onRenameSpecificStep: (BattlePlanStep step) async {
              await _renameStep(step);
            },
            onPlay: () {
              _playTimeline(session.battlePlan.id);
            },
            onPause: () {
              _pauseTimeline(session.battlePlan.id);
            },
            onStop: () {
              _stopTimeline(session.battlePlan.id);
            },
            onPreviousStep: () {
              _previousPlaybackStep(session.battlePlan.id);
            },
            onNextStep: () {
              _nextPlaybackStep(session.battlePlan.id);
            },
            onAddElement: (PlanElementType type) async {
              Navigator.of(context).pop();
              await _addElementFromType(session, type);
            },
            onSelectColor: (int color) async {
              await _applyColorToSelected(color);
            },
            onEditSelected: _editSelected,
            onDuplicateSelected: _duplicateSelected,
            onDeleteSelected: _deleteSelected,
          ),
        );
      },
    );
  }

  void _selectStep(BattlePlanStep step) {
    _stopTimelineIfNeeded(step.battlePlanId);
    ref
        .read(battlePlanTimelineControllerProvider(step.battlePlanId).notifier)
        .selectStep(step.id);
  }

  Future<void> _createStep(int battlePlanId) async {
    try {
      await ref
          .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
          .createStep(battlePlanId);
    } catch (error, stackTrace) {
      debugPrint(
        '[BattlePlanEditor] createStep failed battlePlanId=$battlePlanId '
        'error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible de creer une nouvelle etape pour ce battle plan.',
          ),
        ),
      );
    }
  }

  Future<void> _duplicateCurrentStep(int battlePlanId) async {
    await ref
        .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
        .duplicateCurrentStep(battlePlanId);
  }

  Future<void> _duplicateStep(BattlePlanStep step) async {
    await ref
        .read(battlePlanTimelineControllerProvider(step.battlePlanId).notifier)
        .duplicateStep(step);
  }

  Future<void> _deleteCurrentStep(int battlePlanId) async {
    await ref
        .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
        .deleteCurrentStep(battlePlanId);
  }

  Future<void> _deleteStep(BattlePlanStep step) async {
    await ref
        .read(battlePlanTimelineControllerProvider(step.battlePlanId).notifier)
        .deleteStep(battlePlanId: step.battlePlanId, step: step);
  }

  Future<void> _renameCurrentStep(int battlePlanId) async {
    final BattlePlanStep? currentStep = ref.read(
      currentBattlePlanStepProvider(battlePlanId),
    );
    if (currentStep == null) {
      return;
    }

    await _renameStep(currentStep);
  }

  Future<void> _renameStep(BattlePlanStep step) async {
    final int battlePlanId = step.battlePlanId;

    final TextEditingController textController = TextEditingController(
      text: step.title,
    );
    final String? newTitle = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Renommer l\'etape'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Etape tactique',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(textController.text.trim()),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
    textController.dispose();

    if (newTitle == null || newTitle.trim().isEmpty) {
      return;
    }

    await ref
        .read(battlePlanTimelineControllerProvider(battlePlanId).notifier)
        .renameStep(step: step, title: newTitle);
  }

  Future<void> _flushAndPopIfNeeded() async {
    if (_isFlushingBeforePop) {
      return;
    }

    _isFlushingBeforePop = true;

    _stopTimelineIfNeeded();
    await _controller.flushPendingPositionSaves();
    if (!mounted) {
      _isFlushingBeforePop = false;
      return;
    }

    setState(() {
      _allowPop = true;
    });

    debugPrint('[Navigation] pop battlePlanEditor with GoRouter');
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.battleplans);
    }

    if (mounted) {
      setState(() {
        _allowPop = false;
      });
    }

    _isFlushingBeforePop = false;
  }

  void _handlePopInvoked(bool didPop, Object? result) {
    if (didPop || _allowPop || _isFlushingBeforePop) {
      return;
    }

    unawaited(_flushAndPopIfNeeded());
  }

  void _playTimeline(int battlePlanId) {
    ref
        .read(battlePlanPlaybackControllerProvider(battlePlanId).notifier)
        .play();
  }

  void _pauseTimeline(int battlePlanId) {
    ref
        .read(battlePlanPlaybackControllerProvider(battlePlanId).notifier)
        .pause();
  }

  void _stopTimeline(int battlePlanId) {
    ref
        .read(battlePlanPlaybackControllerProvider(battlePlanId).notifier)
        .stop();
  }

  void _previousPlaybackStep(int battlePlanId) {
    ref
        .read(battlePlanPlaybackControllerProvider(battlePlanId).notifier)
        .previousStep();
  }

  void _nextPlaybackStep(int battlePlanId) {
    ref
        .read(battlePlanPlaybackControllerProvider(battlePlanId).notifier)
        .nextStep();
  }

  void _stopTimelineIfNeeded([int? battlePlanId]) {
    final int? effectiveBattlePlanId =
        battlePlanId ??
        ref
            .read(battlePlanEditorSessionProvider(_args))
            .whenOrNull(
              data: (BattlePlanEditorSession value) => value.battlePlan.id,
            );
    if (effectiveBattlePlanId == null) {
      return;
    }

    ref
        .read(
          battlePlanPlaybackControllerProvider(effectiveBattlePlanId).notifier,
        )
        .stop();
  }
}
