import 'dart:ui';

import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';

class BattlePlanEditorViewState {
  const BattlePlanEditorViewState({
    this.currentStepId,
    this.selectedElementId,
    this.draggingElementId,
    this.rotatingElementId,
    this.resizingElementId,
    this.draftPositions = const <int, Offset>{},
    this.draftSizes = const <int, Size>{},
    this.draftRotations = const <int, double>{},
    this.isMutating = false,
  });

  final int? currentStepId;
  final int? selectedElementId;
  final int? draggingElementId;
  final int? rotatingElementId;
  final int? resizingElementId;
  final Map<int, Offset> draftPositions;
  final Map<int, Size> draftSizes;
  final Map<int, double> draftRotations;
  final bool isMutating;

  Offset positionFor(PlanElement element) {
    return draftPositions[element.id] ?? Offset(element.x, element.y);
  }

  Size sizeFor(PlanElement element) {
    return draftSizes[element.id] ?? Size(element.width, element.height);
  }

  double rotationFor(PlanElement element) {
    return draftRotations[element.id] ?? element.rotation;
  }

  bool isSelected(PlanElement element) {
    return selectedElementId == element.id;
  }

  bool isDragging(PlanElement element) {
    return draggingElementId == element.id;
  }

  bool isResizing(PlanElement element) {
    return resizingElementId == element.id;
  }

  bool isRotating(PlanElement element) {
    return rotatingElementId == element.id;
  }

  BattlePlanEditorViewState select(int id) {
    if (selectedElementId == id) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: id,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState clearSelection() {
    if (selectedElementId == null) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: null,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState startDragging(int id) {
    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: id,
      draggingElementId: id,
      rotatingElementId: null,
      resizingElementId: null,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState startResizing(int id) {
    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: id,
      draggingElementId: null,
      rotatingElementId: null,
      resizingElementId: id,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState startRotating(int id) {
    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: id,
      draggingElementId: null,
      rotatingElementId: id,
      resizingElementId: null,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState stopDragging() {
    if (draggingElementId == null &&
        rotatingElementId == null &&
        resizingElementId == null) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: null,
      rotatingElementId: null,
      resizingElementId: null,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState updateDraftPosition(
    int elementId,
    Offset position,
  ) {
    final Map<int, Offset> nextDrafts = <int, Offset>{
      ...draftPositions,
      elementId: position,
    };

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: nextDrafts,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState updateDraftSize(int elementId, Size size) {
    final Map<int, Size> nextDrafts = <int, Size>{
      ...draftSizes,
      elementId: size,
    };

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: nextDrafts,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState updateDraftRotation(
    int elementId,
    double rotation,
  ) {
    final Map<int, double> nextDrafts = <int, double>{
      ...draftRotations,
      elementId: rotation,
    };

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: nextDrafts,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState removeDraftPosition(int elementId) {
    if (!draftPositions.containsKey(elementId)) {
      return this;
    }

    final Map<int, Offset> nextDrafts = <int, Offset>{...draftPositions}
      ..remove(elementId);

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: nextDrafts,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState removeDraftSize(int elementId) {
    if (!draftSizes.containsKey(elementId)) {
      return this;
    }

    final Map<int, Size> nextDrafts = <int, Size>{...draftSizes}
      ..remove(elementId);

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: nextDrafts,
      draftRotations: draftRotations,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState removeDraftRotation(int elementId) {
    if (!draftRotations.containsKey(elementId)) {
      return this;
    }

    final Map<int, double> nextDrafts = <int, double>{...draftRotations}
      ..remove(elementId);

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: nextDrafts,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState pruneMissingIds(Set<int> existingIds) {
    final Map<int, Offset> nextDrafts = <int, Offset>{...draftPositions}
      ..removeWhere((int key, Offset _) => !existingIds.contains(key));
    final Map<int, Size> nextSizeDrafts = <int, Size>{...draftSizes}
      ..removeWhere((int key, Size _) => !existingIds.contains(key));
    final Map<int, double> nextRotationDrafts = <int, double>{...draftRotations}
      ..removeWhere((int key, double _) => !existingIds.contains(key));

    final int? nextSelected = existingIds.contains(selectedElementId)
        ? selectedElementId
        : null;
    final int? nextDragging = existingIds.contains(draggingElementId)
        ? draggingElementId
        : null;
    final int? nextRotating = existingIds.contains(rotatingElementId)
        ? rotatingElementId
        : null;
    final int? nextResizing = existingIds.contains(resizingElementId)
        ? resizingElementId
        : null;

    final bool draftUnchanged = nextDrafts.length == draftPositions.length;
    final bool sizeDraftUnchanged = nextSizeDrafts.length == draftSizes.length;
    final bool rotationDraftUnchanged =
        nextRotationDrafts.length == draftRotations.length;
    final bool selectionUnchanged = nextSelected == selectedElementId;
    final bool draggingUnchanged = nextDragging == draggingElementId;
    final bool rotatingUnchanged = nextRotating == rotatingElementId;
    final bool resizingUnchanged = nextResizing == resizingElementId;
    if (draftUnchanged &&
        sizeDraftUnchanged &&
        rotationDraftUnchanged &&
        selectionUnchanged &&
        draggingUnchanged &&
        rotatingUnchanged &&
        resizingUnchanged) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: nextSelected,
      draftPositions: nextDrafts,
      draftSizes: nextSizeDrafts,
      draggingElementId: nextDragging,
      rotatingElementId: nextRotating,
      resizingElementId: nextResizing,
      draftRotations: nextRotationDrafts,
      isMutating: isMutating,
    );
  }

  BattlePlanEditorViewState setMutating(bool value) {
    if (isMutating == value) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: currentStepId,
      selectedElementId: selectedElementId,
      draggingElementId: draggingElementId,
      rotatingElementId: rotatingElementId,
      resizingElementId: resizingElementId,
      draftPositions: draftPositions,
      draftSizes: draftSizes,
      draftRotations: draftRotations,
      isMutating: value,
    );
  }

  BattlePlanEditorViewState setCurrentStep(int? stepId) {
    if (currentStepId == stepId) {
      return this;
    }

    return BattlePlanEditorViewState(
      currentStepId: stepId,
      selectedElementId: null,
      draggingElementId: null,
      rotatingElementId: null,
      resizingElementId: null,
      draftPositions: const <int, Offset>{},
      draftSizes: const <int, Size>{},
      draftRotations: const <int, double>{},
      isMutating: isMutating,
    );
  }
}
