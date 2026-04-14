import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_steps_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';

final battlePlanPlaybackControllerProvider = NotifierProvider.autoDispose
    .family<BattlePlanPlaybackController, BattlePlanPlaybackState, int>(
      BattlePlanPlaybackController.new,
    );

final battlePlanTimelineElementsProvider = Provider.autoDispose
    .family<AsyncValue<Map<int, List<PlanElement>>>, int>((
      Ref ref,
      int battlePlanId,
    ) {
      final AsyncValue<List<BattlePlanStep>> stepsAsync = ref.watch(
        battlePlanStepsProvider(battlePlanId),
      );

      return stepsAsync.when(
        data: (List<BattlePlanStep> steps) {
          final Map<int, List<PlanElement>> timeline =
              <int, List<PlanElement>>{};

          for (final BattlePlanStep step in steps) {
            final AsyncValue<List<PlanElement>> elementsAsync = ref.watch(
              battlePlanStepElementsProvider(step.id),
            );

            switch (elementsAsync) {
              case AsyncData<List<PlanElement>>(:final value):
                timeline[step.id] = value;
              case AsyncError<List<PlanElement>>(
                :final error,
                :final stackTrace,
              ):
                return AsyncValue<Map<int, List<PlanElement>>>.error(
                  error,
                  stackTrace,
                );
              case AsyncLoading<List<PlanElement>>():
                return const AsyncValue<Map<int, List<PlanElement>>>.loading();
            }
          }

          return AsyncValue<Map<int, List<PlanElement>>>.data(timeline);
        },
        loading: () => const AsyncValue<Map<int, List<PlanElement>>>.loading(),
        error: (Object error, StackTrace stackTrace) =>
            AsyncValue<Map<int, List<PlanElement>>>.error(error, stackTrace),
      );
    });

final battlePlanPlaybackRenderElementsProvider = Provider.autoDispose
    .family<AsyncValue<List<BattlePlanRenderElement>>, int>((
      Ref ref,
      int battlePlanId,
    ) {
      final AsyncValue<Map<int, List<PlanElement>>> timelineAsync = ref.watch(
        battlePlanTimelineElementsProvider(battlePlanId),
      );
      final BattlePlanPlaybackState playbackState = ref.watch(
        battlePlanPlaybackControllerProvider(battlePlanId),
      );
      final BattlePlanStep? currentStep = ref.watch(
        currentBattlePlanStepProvider(battlePlanId),
      );

      return timelineAsync.when(
        data: (Map<int, List<PlanElement>> timeline) {
          if (!playbackState.isAnimating) {
            final List<PlanElement> elements = currentStep == null
                ? const <PlanElement>[]
                : (timeline[currentStep.id] ?? const <PlanElement>[]);

            return AsyncValue<List<BattlePlanRenderElement>>.data(
              elements
                  .map(
                    (PlanElement element) =>
                        BattlePlanRenderElement(element: element),
                  )
                  .toList(growable: false),
            );
          }

          final List<PlanElement> fromElements =
              timeline[playbackState.fromStepId] ?? const <PlanElement>[];
          final List<PlanElement> toElements =
              timeline[playbackState.toStepId] ?? const <PlanElement>[];

          return AsyncValue<List<BattlePlanRenderElement>>.data(
            _interpolateRenderElements(
              fromElements: fromElements,
              toElements: toElements,
              progress: playbackState.progress,
            ),
          );
        },
        loading: () =>
            const AsyncValue<List<BattlePlanRenderElement>>.loading(),
        error: (Object error, StackTrace stackTrace) =>
            AsyncValue<List<BattlePlanRenderElement>>.error(error, stackTrace),
      );
    });

class BattlePlanPlaybackController extends Notifier<BattlePlanPlaybackState> {
  BattlePlanPlaybackController(this._battlePlanId);

  final int _battlePlanId;
  Timer? _timer;
  DateTime? _startedAt;
  double _startProgress = 0;

  @override
  BattlePlanPlaybackState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const BattlePlanPlaybackState.stopped();
  }

  void play() {
    final List<BattlePlanStep> steps = _steps;
    if (steps.length < 2) {
      return;
    }

    if (state.isPaused && state.isAnimating) {
      _resumeTransition();
      return;
    }

    if (state.isPlaying || state.isAnimating) {
      return;
    }

    final BattlePlanStep? currentStep = ref.read(
      currentBattlePlanStepProvider(_battlePlanId),
    );
    if (currentStep == null) {
      return;
    }

    final int currentIndex = _indexOfStep(steps, currentStep.id);
    if (currentIndex < 0 || currentIndex >= steps.length - 1) {
      return;
    }

    _startTransition(
      fromStep: steps[currentIndex],
      toStep: steps[currentIndex + 1],
      mode: BattlePlanPlaybackMode.playing,
      autoAdvance: true,
      startProgress: 0,
    );
  }

  void pause() {
    if (!state.isPlaying || !state.isAnimating) {
      return;
    }

    _timer?.cancel();
    _timer = null;
    state = state.copyWith(mode: BattlePlanPlaybackMode.paused);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;

    final int? stepId = _resolveStopStepId();
    if (stepId != null) {
      ref
          .read(battlePlanTimelineControllerProvider(_battlePlanId).notifier)
          .selectStep(stepId);
    }

    state = BattlePlanPlaybackState(
      mode: BattlePlanPlaybackMode.stopped,
      transitionDuration: state.transitionDuration,
    );
  }

  void nextStep() {
    _animateAdjacentStep(direction: 1);
  }

  void previousStep() {
    _animateAdjacentStep(direction: -1);
  }

  void setTransitionDuration(Duration duration) {
    final Duration safeDuration = duration < const Duration(milliseconds: 150)
        ? const Duration(milliseconds: 150)
        : duration;
    state = state.copyWith(transitionDuration: safeDuration);
  }

  void _animateAdjacentStep({required int direction}) {
    if (state.isAnimating) {
      return;
    }

    final List<BattlePlanStep> steps = _steps;
    if (steps.isEmpty) {
      return;
    }

    final BattlePlanStep? currentStep = ref.read(
      currentBattlePlanStepProvider(_battlePlanId),
    );
    if (currentStep == null) {
      return;
    }

    final int currentIndex = _indexOfStep(steps, currentStep.id);
    final int targetIndex = currentIndex + direction;
    if (currentIndex < 0 || targetIndex < 0 || targetIndex >= steps.length) {
      return;
    }

    _startTransition(
      fromStep: steps[currentIndex],
      toStep: steps[targetIndex],
      mode: BattlePlanPlaybackMode.stopped,
      autoAdvance: false,
      startProgress: 0,
    );
  }

  void _resumeTransition() {
    final List<BattlePlanStep> steps = _steps;
    final BattlePlanStep? fromStep = _findStep(steps, state.fromStepId);
    final BattlePlanStep? toStep = _findStep(steps, state.toStepId);
    if (fromStep == null || toStep == null) {
      stop();
      return;
    }

    _startTransition(
      fromStep: fromStep,
      toStep: toStep,
      mode: BattlePlanPlaybackMode.playing,
      autoAdvance: state.autoAdvance,
      startProgress: state.progress,
    );
  }

  void _startTransition({
    required BattlePlanStep fromStep,
    required BattlePlanStep toStep,
    required BattlePlanPlaybackMode mode,
    required bool autoAdvance,
    required double startProgress,
  }) {
    _timer?.cancel();
    _startProgress = startProgress.clamp(0, 1);
    _startedAt = DateTime.now();
    state = BattlePlanPlaybackState(
      mode: mode,
      fromStepId: fromStep.id,
      toStepId: toStep.id,
      progress: _startProgress,
      autoAdvance: autoAdvance,
      transitionDuration: state.transitionDuration,
    );

    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _tick();
    });
  }

  void _tick() {
    final DateTime? startedAt = _startedAt;
    if (startedAt == null || !state.isAnimating) {
      _timer?.cancel();
      return;
    }

    final int elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
    final int durationMs = state.transitionDuration.inMilliseconds;
    final double advancedProgress = durationMs <= 0
        ? 1
        : elapsedMs / durationMs.toDouble();
    final double nextProgress =
        (_startProgress + (1 - _startProgress) * advancedProgress).clamp(0, 1);

    if (nextProgress >= 1) {
      _completeTransition();
      return;
    }

    state = state.copyWith(progress: nextProgress);
  }

  void _completeTransition() {
    _timer?.cancel();
    _timer = null;

    final int? targetStepId = state.toStepId;
    if (targetStepId != null) {
      ref
          .read(battlePlanTimelineControllerProvider(_battlePlanId).notifier)
          .selectStep(targetStepId);
    }

    if (!ref.mounted) {
      return;
    }

    if (state.mode == BattlePlanPlaybackMode.playing && state.autoAdvance) {
      final List<BattlePlanStep> steps = _steps;
      final int currentIndex = _indexOfStep(steps, targetStepId);
      if (currentIndex >= 0 && currentIndex < steps.length - 1) {
        _startTransition(
          fromStep: steps[currentIndex],
          toStep: steps[currentIndex + 1],
          mode: BattlePlanPlaybackMode.playing,
          autoAdvance: true,
          startProgress: 0,
        );
        return;
      }
    }

    state = BattlePlanPlaybackState(
      mode: BattlePlanPlaybackMode.stopped,
      transitionDuration: state.transitionDuration,
    );
  }

  int? _resolveStopStepId() {
    if (!state.isAnimating) {
      return ref.read(currentBattlePlanStepProvider(_battlePlanId))?.id;
    }

    if (state.progress >= 0.5) {
      return state.toStepId;
    }

    return state.fromStepId;
  }

  List<BattlePlanStep> get _steps =>
      ref
          .read(battlePlanStepsProvider(_battlePlanId))
          .whenOrNull(data: (List<BattlePlanStep> value) => value) ??
      const <BattlePlanStep>[];

  int _indexOfStep(List<BattlePlanStep> steps, int? stepId) {
    if (stepId == null) {
      return -1;
    }

    for (int index = 0; index < steps.length; index += 1) {
      if (steps[index].id == stepId) {
        return index;
      }
    }

    return -1;
  }

  BattlePlanStep? _findStep(List<BattlePlanStep> steps, int? stepId) {
    final int index = _indexOfStep(steps, stepId);
    if (index < 0) {
      return null;
    }

    return steps[index];
  }
}

List<BattlePlanRenderElement> _interpolateRenderElements({
  required List<PlanElement> fromElements,
  required List<PlanElement> toElements,
  required double progress,
}) {
  final Map<int, PlanElement> fromById = <int, PlanElement>{
    for (final PlanElement element in fromElements) element.id: element,
  };
  final Map<int, PlanElement> toById = <int, PlanElement>{
    for (final PlanElement element in toElements) element.id: element,
  };
  final Set<int> ids = <int>{...fromById.keys, ...toById.keys};

  final List<BattlePlanRenderElement> rendered = <BattlePlanRenderElement>[];
  for (final int id in ids) {
    final PlanElement? from = fromById[id];
    final PlanElement? to = toById[id];
    if (from == null && to == null) {
      continue;
    }

    if (from != null && to != null) {
      rendered.add(
        BattlePlanRenderElement(
          element: PlanElement(
            id: to.id,
            battlePlanId: to.battlePlanId,
            type: progress < 0.5 ? from.type : to.type,
            x: _lerpDouble(from.x, to.x, progress),
            y: _lerpDouble(from.y, to.y, progress),
            width: _lerpDouble(from.width, to.width, progress),
            height: _lerpDouble(from.height, to.height, progress),
            rotation: _lerpDouble(from.rotation, to.rotation, progress),
            color:
                Color.lerp(
                  Color(from.color),
                  Color(to.color),
                  progress,
                )?.toARGB32() ??
                to.color,
            label: progress < 0.5 ? from.label : to.label,
            extraJson: progress < 0.5 ? from.extraJson : to.extraJson,
          ),
        ),
      );
      continue;
    }

    if (from != null) {
      rendered.add(
        BattlePlanRenderElement(
          element: from,
          opacity: (1 - progress).clamp(0, 1),
        ),
      );
      continue;
    }

    rendered.add(
      BattlePlanRenderElement(element: to!, opacity: progress.clamp(0, 1)),
    );
  }

  rendered.sort(
    (BattlePlanRenderElement left, BattlePlanRenderElement right) =>
        left.element.id.compareTo(right.element.id),
  );
  return rendered;
}

double _lerpDouble(double a, double b, double t) {
  return lerpDouble(a, b, t) ?? b;
}
