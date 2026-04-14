import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_timeline_service.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

class BattlePlanTimelineViewState {
  const BattlePlanTimelineViewState({
    this.currentStepId,
    this.isMutating = false,
    this.errorMessage,
  });

  final int? currentStepId;
  final bool isMutating;
  final String? errorMessage;
}

final battlePlanStepsProvider = StreamProvider.autoDispose
    .family<List<BattlePlanStep>, int>((Ref ref, int battlePlanId) {
      return ref
          .watch(battlePlanStepRepositoryProvider)
          .watchSteps(battlePlanId);
    });

final battlePlanStepElementsProvider = StreamProvider.autoDispose
    .family<List<PlanElement>, int>((Ref ref, int stepId) {
      return ref
          .watch(battlePlanStepElementStateRepositoryProvider)
          .watchStepPlanElements(stepId);
    });

final battlePlanTimelineControllerProvider = NotifierProvider.autoDispose
    .family<BattlePlanTimelineController, BattlePlanTimelineViewState, int>(
      BattlePlanTimelineController.new,
    );

final battlePlanTimelineStateProvider = Provider.autoDispose
    .family<BattlePlanTimelineViewState, int>((Ref ref, int battlePlanId) {
      return ref.watch(battlePlanTimelineControllerProvider(battlePlanId));
    });

final currentBattlePlanStepProvider = Provider.autoDispose
    .family<BattlePlanStep?, int>((Ref ref, int battlePlanId) {
      final BattlePlanTimelineViewState viewState = ref.watch(
        battlePlanTimelineStateProvider(battlePlanId),
      );
      final AsyncValue<List<BattlePlanStep>> steps = ref.watch(
        battlePlanStepsProvider(battlePlanId),
      );

      return steps.whenOrNull(
        data: (List<BattlePlanStep> value) {
          if (value.isEmpty) {
            return null;
          }

          final int? currentStepId = viewState.currentStepId;
          if (currentStepId == null) {
            return value.first;
          }

          for (final BattlePlanStep step in value) {
            if (step.id == currentStepId) {
              return step;
            }
          }

          return value.first;
        },
      );
    });

class BattlePlanTimelineController
    extends Notifier<BattlePlanTimelineViewState> {
  BattlePlanTimelineController(this._battlePlanId);

  final int _battlePlanId;

  @override
  BattlePlanTimelineViewState build() {
    Future<void>.microtask(_bootstrapTimeline);
    return const BattlePlanTimelineViewState();
  }

  Future<void> _bootstrapTimeline() async {
    final List<BattlePlanStep> steps = await ref
        .read(battlePlanTimelineServiceProvider)
        .ensureInitialTimeline(_battlePlanId);
    if (!ref.mounted || steps.isEmpty) {
      return;
    }

    debugPrint(
      '[BattlePlanTimeline] bootstrap battlePlanId=$_battlePlanId '
      'steps=${steps.length} firstStepId=${steps.first.id}',
    );

    state = BattlePlanTimelineViewState(
      currentStepId: steps.first.id,
      isMutating: state.isMutating,
      errorMessage: null,
    );
  }

  void selectStep(int stepId) {
    state = BattlePlanTimelineViewState(
      currentStepId: stepId,
      isMutating: state.isMutating,
      errorMessage: null,
    );
  }

  Future<void> createStep(int battlePlanId) async {
    await _runMutating(() async {
      final List<BattlePlanStep> stepsBefore = await ref
          .read(battlePlanStepRepositoryProvider)
          .getSteps(battlePlanId);
      final BattlePlanStep? currentStep = _resolveCurrentStep(stepsBefore);
      final BattlePlanStep? sourceStep =
          currentStep ?? (stepsBefore.isEmpty ? null : stepsBefore.last);

      debugPrint(
        '[BattlePlanTimeline] createStep battlePlanId=$battlePlanId '
        'stepsBefore=${stepsBefore.length} '
        'sourceStepId=${sourceStep?.id}',
      );

      final BattlePlanStep createdStep = await ref
          .read(battlePlanTimelineServiceProvider)
          .createStepFromPrevious(
            battlePlanId: battlePlanId,
            sourceStepId: sourceStep?.id,
          );
      final List<BattlePlanStep> refreshedSteps = await ref
          .read(battlePlanStepRepositoryProvider)
          .getSteps(battlePlanId);
      int activeIndex = -1;
      for (int index = 0; index < refreshedSteps.length; index += 1) {
        if (refreshedSteps[index].id == createdStep.id) {
          activeIndex = index;
          break;
        }
      }

      debugPrint(
        '[BattlePlanTimeline] createStep createdStepId=${createdStep.id} '
        'stepsAfter=${refreshedSteps.length} activeIndex=$activeIndex',
      );

      ref.invalidate(battlePlanStepsProvider(battlePlanId));
      if (ref.mounted) {
        state = BattlePlanTimelineViewState(
          currentStepId: createdStep.id,
          isMutating: state.isMutating,
          errorMessage: null,
        );
      }
    });
  }

  Future<void> duplicateCurrentStep(int battlePlanId) async {
    final List<BattlePlanStep> steps = await ref
        .read(battlePlanStepRepositoryProvider)
        .getSteps(battlePlanId);
    final BattlePlanStep? currentStep = _resolveCurrentStep(steps);
    if (currentStep == null) {
      return;
    }

    await duplicateStep(currentStep);
  }

  Future<void> duplicateStep(BattlePlanStep step) async {
    await _runMutating(() async {
      final BattlePlanStep createdStep = await ref
          .read(battlePlanTimelineServiceProvider)
          .duplicateStep(step);
      ref.invalidate(battlePlanStepsProvider(step.battlePlanId));
      if (ref.mounted) {
        state = BattlePlanTimelineViewState(
          currentStepId: createdStep.id,
          isMutating: state.isMutating,
          errorMessage: null,
        );
      }
    });
  }

  Future<void> deleteCurrentStep(int battlePlanId) async {
    final List<BattlePlanStep> steps = await ref
        .read(battlePlanStepRepositoryProvider)
        .getSteps(battlePlanId);
    final BattlePlanStep? currentStep = _resolveCurrentStep(steps);
    if (currentStep == null) {
      return;
    }

    await deleteStep(battlePlanId: battlePlanId, step: currentStep);
  }

  Future<void> deleteStep({
    required int battlePlanId,
    required BattlePlanStep step,
  }) async {
    await _runMutating(() async {
      final int? previousCurrentStepId = state.currentStepId;
      final List<BattlePlanStep> remainingSteps = await ref
          .read(battlePlanTimelineServiceProvider)
          .deleteStep(battlePlanId: battlePlanId, stepId: step.id);
      ref.invalidate(battlePlanStepsProvider(battlePlanId));
      if (!ref.mounted || remainingSteps.isEmpty) {
        return;
      }

      int nextStepId = remainingSteps.first.id;
      if (previousCurrentStepId != null) {
        for (final BattlePlanStep remainingStep in remainingSteps) {
          if (remainingStep.id == previousCurrentStepId) {
            nextStepId = remainingStep.id;
            break;
          }
        }
      }
      if (previousCurrentStepId == step.id) {
        final int fallbackIndex = step.orderIndex.clamp(
          0,
          remainingSteps.length - 1,
        );
        nextStepId = remainingSteps[fallbackIndex].id;
      }

      state = BattlePlanTimelineViewState(
        currentStepId: nextStepId,
        isMutating: state.isMutating,
        errorMessage: null,
      );
    });
  }

  Future<void> renameCurrentStep({
    required int battlePlanId,
    required String title,
  }) async {
    final List<BattlePlanStep> steps = await ref
        .read(battlePlanStepRepositoryProvider)
        .getSteps(battlePlanId);
    final BattlePlanStep? currentStep = _resolveCurrentStep(steps);
    if (currentStep == null) {
      return;
    }

    await renameStep(step: currentStep, title: title);
  }

  Future<void> renameStep({
    required BattlePlanStep step,
    required String title,
  }) async {
    await _runMutating(() async {
      final BattlePlanStep? renamedStep = await ref
          .read(battlePlanTimelineServiceProvider)
          .renameStep(step: step, title: title);
      ref.invalidate(battlePlanStepsProvider(step.battlePlanId));
      if (!ref.mounted || renamedStep == null) {
        return;
      }

      state = BattlePlanTimelineViewState(
        currentStepId: renamedStep.id,
        isMutating: state.isMutating,
        errorMessage: null,
      );
    });
  }

  Future<void> _runMutating(Future<void> Function() operation) async {
    state = BattlePlanTimelineViewState(
      currentStepId: state.currentStepId,
      isMutating: true,
      errorMessage: null,
    );
    try {
      await operation();
    } catch (error, stackTrace) {
      debugPrint(
        '[BattlePlanTimeline] mutation error battlePlanId=$_battlePlanId '
        'error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
      if (ref.mounted) {
        state = BattlePlanTimelineViewState(
          currentStepId: state.currentStepId,
          isMutating: false,
          errorMessage: 'Impossible de modifier les etapes du battle plan.',
        );
      }
      rethrow;
    } finally {
      if (ref.mounted) {
        state = BattlePlanTimelineViewState(
          currentStepId: state.currentStepId,
          isMutating: false,
          errorMessage: state.errorMessage,
        );
      }
    }
  }

  BattlePlanStep? _resolveCurrentStep(List<BattlePlanStep> steps) {
    if (steps.isEmpty) {
      return null;
    }

    final int? currentStepId = state.currentStepId;
    if (currentStepId == null) {
      return steps.first;
    }

    for (final BattlePlanStep step in steps) {
      if (step.id == currentStepId) {
        return step;
      }
    }

    return steps.first;
  }
}
