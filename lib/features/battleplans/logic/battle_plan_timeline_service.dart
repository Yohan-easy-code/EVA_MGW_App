import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/plan_element_repository.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

class BattlePlanTimelineService {
  const BattlePlanTimelineService(
    this._stepRepository,
    this._stepElementStateRepository,
    this._planElementRepository,
  );

  final BattlePlanStepRepository _stepRepository;
  final BattlePlanStepElementStateRepository _stepElementStateRepository;
  final PlanElementRepository _planElementRepository;

  Future<List<BattlePlanStep>> ensureInitialTimeline(int battlePlanId) async {
    final List<BattlePlanStep> existingSteps = await _stepRepository.getSteps(
      battlePlanId,
    );
    if (existingSteps.isNotEmpty) {
      debugPrint(
        '[BattlePlanTimelineService] ensureInitialTimeline existing '
        'battlePlanId=$battlePlanId count=${existingSteps.length}',
      );
      return existingSteps;
    }

    final int initialStepId = await _stepRepository.createStep(
      battlePlanId: battlePlanId,
      title: 'Etape 1',
      orderIndex: 0,
    );
    final List<PlanElement> elements = await _planElementRepository
        .getPlanElements(battlePlanId);
    await _stepElementStateRepository.seedStepFromPlanElements(
      stepId: initialStepId,
      elements: elements,
    );
    debugPrint(
      '[BattlePlanTimelineService] ensureInitialTimeline created '
      'battlePlanId=$battlePlanId stepId=$initialStepId '
      'seededElements=${elements.length}',
    );

    return _stepRepository.getSteps(battlePlanId);
  }

  Future<BattlePlanStep> createStepFromPrevious({
    required int battlePlanId,
    required int? sourceStepId,
  }) async {
    final List<BattlePlanStep> steps = await ensureInitialTimeline(
      battlePlanId,
    );
    debugPrint(
      '[BattlePlanTimelineService] createStepFromPrevious '
      'battlePlanId=$battlePlanId stepsBefore=${steps.length} '
      'sourceStepId=$sourceStepId',
    );
    final int createdStepId = await _stepRepository.createStep(
      battlePlanId: battlePlanId,
      title: 'Etape ${steps.length + 1}',
      orderIndex: steps.length,
    );
    if (sourceStepId != null) {
      await _stepElementStateRepository.duplicateStates(
        fromStepId: sourceStepId,
        toStepId: createdStepId,
      );
    }
    debugPrint(
      '[BattlePlanTimelineService] createStepFromPrevious inserted '
      'battlePlanId=$battlePlanId createdStepId=$createdStepId',
    );

    final BattlePlanStep? createdStep = await _stepRepository.getStepById(
      createdStepId,
    );
    if (createdStep == null) {
      throw StateError('Unable to load created step $createdStepId');
    }

    return createdStep;
  }

  Future<BattlePlanStep> duplicateStep(BattlePlanStep sourceStep) {
    return createStepFromPrevious(
      battlePlanId: sourceStep.battlePlanId,
      sourceStepId: sourceStep.id,
    );
  }

  Future<List<BattlePlanStep>> deleteStep({
    required int battlePlanId,
    required int stepId,
  }) async {
    await _stepRepository.deleteStep(stepId);

    List<BattlePlanStep> remainingSteps = await _stepRepository.getSteps(
      battlePlanId,
    );
    if (remainingSteps.isEmpty) {
      final int recreatedStepId = await _stepRepository.createStep(
        battlePlanId: battlePlanId,
        title: 'Etape 1',
        orderIndex: 0,
      );
      final BattlePlanStep? recreatedStep = await _stepRepository.getStepById(
        recreatedStepId,
      );
      if (recreatedStep != null) {
        remainingSteps = <BattlePlanStep>[recreatedStep];
      }
    }

    await _renumberSteps(remainingSteps);
    return _stepRepository.getSteps(battlePlanId);
  }

  Future<BattlePlanStep?> renameStep({
    required BattlePlanStep step,
    required String title,
  }) async {
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return step;
    }

    await _stepRepository.updateStep(step.copyWith(title: normalizedTitle));
    return _stepRepository.getStepById(step.id);
  }

  Future<void> _renumberSteps(List<BattlePlanStep> steps) async {
    for (int index = 0; index < steps.length; index += 1) {
      final BattlePlanStep step = steps[index];
      if (step.orderIndex == index) {
        continue;
      }
      await _stepRepository.updateStep(step.copyWith(orderIndex: index));
    }
  }
}

final battlePlanTimelineServiceProvider = Provider<BattlePlanTimelineService>((
  Ref ref,
) {
  return BattlePlanTimelineService(
    ref.watch(battlePlanStepRepositoryProvider),
    ref.watch(battlePlanStepElementStateRepositoryProvider),
    ref.watch(planElementRepositoryProvider),
  );
});
