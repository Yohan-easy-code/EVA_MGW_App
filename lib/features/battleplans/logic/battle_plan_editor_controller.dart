import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_service.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_view_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanEditorController extends ChangeNotifier {
  BattlePlanEditorController(this._editorService);

  static const Duration autoSaveDelay = Duration(milliseconds: 450);
  static const double minimumZoneCircleDiameter = 56;

  final BattlePlanEditorService _editorService;

  BattlePlanEditorViewState _viewState = const BattlePlanEditorViewState();
  final Map<int, Timer> _autoSaveTimers = <int, Timer>{};
  final Map<int, _PendingElementGeometrySave> _pendingGeometrySaves =
      <int, _PendingElementGeometrySave>{};

  bool _syncScheduled = false;
  List<PlanElement>? _queuedSyncElements;

  BattlePlanEditorViewState get viewState => _viewState;

  int? get selectedElementId => _viewState.selectedElementId;

  bool get isMutating => _viewState.isMutating;

  void setCurrentStep(int? stepId) {
    _replaceViewState(_viewState.setCurrentStep(stepId));
  }

  Future<void> createElement({
    required int battlePlanId,
    required int stepId,
    required PlanElementType type,
    required double mapWidth,
    required double mapHeight,
  }) {
    return _editorService.createElement(
      battlePlanId: battlePlanId,
      stepId: stepId,
      type: type,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );
  }

  void syncWithElements(List<PlanElement> items) {
    _queuedSyncElements = items;
    if (_syncScheduled) {
      return;
    }

    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      final List<PlanElement>? queuedItems = _queuedSyncElements;
      _queuedSyncElements = null;
      if (queuedItems == null) {
        return;
      }

      final BattlePlanEditorViewState nextState = _buildSyncedState(
        queuedItems,
      );
      _replaceViewState(nextState);
    });
  }

  void selectElement(int id) {
    _replaceViewState(_viewState.select(id));
  }

  void clearSelection() {
    _replaceViewState(_viewState.clearSelection());
  }

  void startDragging(int elementId) {
    _replaceViewState(_viewState.startDragging(elementId));
  }

  void updateDragging({
    required PlanElement element,
    required Offset delta,
    required double mapWidth,
    required double mapHeight,
  }) {
    final Offset nextPosition = _clampPosition(
      position: _viewState.positionFor(element) + delta,
      element: element,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );

    _replaceViewState(_viewState.updateDraftPosition(element.id, nextPosition));
    _scheduleGeometryAutoSave(
      element: element,
      position: nextPosition,
      size: _viewState.sizeFor(element),
      rotation: _viewState.rotationFor(element),
    );
  }

  void startResizing(int elementId) {
    _replaceViewState(_viewState.startResizing(elementId));
  }

  void startRotating(int elementId) {
    _replaceViewState(_viewState.startRotating(elementId));
  }

  void updateResizing({
    required PlanElement element,
    required Offset delta,
    required double mapWidth,
    required double mapHeight,
  }) {
    final Offset currentPosition = _viewState.positionFor(element);
    final Size currentSize = _viewState.sizeFor(element);
    final Offset center = Offset(
      currentPosition.dx + currentSize.width / 2,
      currentPosition.dy + currentSize.height / 2,
    );

    final double nextRadius = math.max(
      minimumZoneCircleDiameter / 2,
      math.max(
        currentSize.width / 2 + delta.dx,
        currentSize.height / 2 + delta.dy,
      ),
    );
    final double nextDiameter = nextRadius * 2;
    final Size nextSize = Size(nextDiameter, nextDiameter);
    final Offset nextPosition = _clampPosition(
      position: Offset(center.dx - nextRadius, center.dy - nextRadius),
      element: element.copyWith(width: nextDiameter, height: nextDiameter),
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );

    _replaceViewState(
      _viewState
          .updateDraftPosition(element.id, nextPosition)
          .updateDraftSize(element.id, nextSize),
    );
    _scheduleGeometryAutoSave(
      element: element,
      position: nextPosition,
      size: nextSize,
      rotation: _viewState.rotationFor(element),
    );
  }

  void updateRotating({
    required PlanElement element,
    required Offset aimPoint,
  }) {
    final Offset currentPosition = _viewState.positionFor(element);
    final Size currentSize = _viewState.sizeFor(element);
    final Offset center = Offset(
      currentPosition.dx + currentSize.width / 2,
      currentPosition.dy + currentSize.height / 2,
    );
    final Offset aimVector = aimPoint - center;
    if (aimVector.distanceSquared < 0.0001) {
      return;
    }

    final double nextRotation = math.atan2(aimVector.dy, aimVector.dx);
    _replaceViewState(_viewState.updateDraftRotation(element.id, nextRotation));
    _scheduleGeometryAutoSave(
      element: element,
      position: _viewState.positionFor(element),
      size: _viewState.sizeFor(element),
      rotation: nextRotation,
    );
  }

  Future<void> commitDragging(PlanElement element) async {
    final Offset? draftPosition = _viewState.draftPositions[element.id];
    _replaceViewState(_viewState.stopDragging());

    if (draftPosition == null) {
      return;
    }

    if (_positionsAreEqual(draftPosition, Offset(element.x, element.y))) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(
        _viewState.removeDraftPosition(element.id).removeDraftSize(element.id),
      );
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: draftPosition,
      size: _viewState.sizeFor(element),
      rotation: _viewState.rotationFor(element),
      delay: const Duration(milliseconds: 150),
    );
  }

  Future<void> commitResizing(PlanElement element) async {
    final Offset draftPosition = _viewState.positionFor(element);
    final Size draftSize = _viewState.sizeFor(element);
    _replaceViewState(_viewState.stopDragging());

    if (_positionsAreEqual(draftPosition, Offset(element.x, element.y)) &&
        _sizesAreEqual(draftSize, Size(element.width, element.height))) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(
        _viewState.removeDraftPosition(element.id).removeDraftSize(element.id),
      );
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: draftPosition,
      size: draftSize,
      rotation: _viewState.rotationFor(element),
      delay: const Duration(milliseconds: 120),
    );
  }

  void cancelDragging(PlanElement element) {
    final Offset? draftPosition = _viewState.draftPositions[element.id];
    _replaceViewState(_viewState.stopDragging());

    if (draftPosition == null) {
      return;
    }

    if (_positionsAreEqual(draftPosition, Offset(element.x, element.y))) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(
        _viewState.removeDraftPosition(element.id).removeDraftSize(element.id),
      );
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: draftPosition,
      size: _viewState.sizeFor(element),
      rotation: _viewState.rotationFor(element),
      delay: const Duration(milliseconds: 150),
    );
  }

  void cancelResizing(PlanElement element) {
    final Offset draftPosition = _viewState.positionFor(element);
    final Size draftSize = _viewState.sizeFor(element);
    _replaceViewState(_viewState.stopDragging());

    if (_positionsAreEqual(draftPosition, Offset(element.x, element.y)) &&
        _sizesAreEqual(draftSize, Size(element.width, element.height))) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(
        _viewState.removeDraftPosition(element.id).removeDraftSize(element.id),
      );
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: draftPosition,
      size: draftSize,
      rotation: _viewState.rotationFor(element),
      delay: const Duration(milliseconds: 120),
    );
  }

  Future<void> commitRotating(PlanElement element) async {
    final double draftRotation = _viewState.rotationFor(element);
    _replaceViewState(_viewState.stopDragging());

    if ((draftRotation - element.rotation).abs() < 0.01) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(_viewState.removeDraftRotation(element.id));
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: _viewState.positionFor(element),
      size: _viewState.sizeFor(element),
      rotation: draftRotation,
      delay: const Duration(milliseconds: 120),
    );
  }

  void cancelRotating(PlanElement element) {
    final double draftRotation = _viewState.rotationFor(element);
    _replaceViewState(_viewState.stopDragging());

    if ((draftRotation - element.rotation).abs() < 0.01) {
      _discardPendingGeometrySave(element.id);
      _replaceViewState(_viewState.removeDraftRotation(element.id));
      return;
    }

    _scheduleGeometryAutoSave(
      element: element,
      position: _viewState.positionFor(element),
      size: _viewState.sizeFor(element),
      rotation: draftRotation,
      delay: const Duration(milliseconds: 120),
    );
  }

  PlanElement? selectedElementFrom(List<PlanElement> elements) {
    final int? selectedId = selectedElementId;
    if (selectedId == null) {
      return null;
    }

    for (final PlanElement element in elements) {
      if (element.id == selectedId) {
        return element;
      }
    }

    return null;
  }

  Future<void> deleteSelected() async {
    final int? selectedId = selectedElementId;
    if (selectedId == null) {
      return;
    }

    _discardPendingGeometrySave(selectedId);
    _replaceViewState(_viewState.setMutating(true));
    try {
      await _editorService.deleteElement(selectedId);
    } finally {
      _replaceViewState(
        _viewState
            .setMutating(false)
            .clearSelection()
            .removeDraftPosition(selectedId),
      );
    }
  }

  Future<void> duplicateElement({
    required int stepId,
    required PlanElement source,
    required double mapWidth,
    required double mapHeight,
  }) async {
    final Offset duplicatedPosition = _clampPosition(
      position: Offset(source.x + 24, source.y + 24),
      element: source,
      mapWidth: mapWidth,
      mapHeight: mapHeight,
    );

    _replaceViewState(_viewState.setMutating(true));
    try {
      await _editorService.duplicateElement(
        stepId: stepId,
        source: source,
        duplicatedPosition: duplicatedPosition,
      );
    } finally {
      _replaceViewState(_viewState.setMutating(false));
    }
  }

  Future<void> updateAppearance({
    required int stepId,
    required PlanElement element,
    required int color,
    required String? label,
  }) async {
    _replaceViewState(_viewState.setMutating(true));
    try {
      await _editorService.updateAppearance(
        stepId: stepId,
        element: element,
        color: color,
        label: label,
      );
    } finally {
      _replaceViewState(_viewState.setMutating(false));
    }
  }

  Future<void> flushPendingPositionSaves() async {
    final List<int> pendingIds = _pendingGeometrySaves.keys.toList();
    for (final int elementId in pendingIds) {
      await _flushPendingGeometrySave(elementId);
    }
  }

  @override
  void dispose() {
    for (final Timer timer in _autoSaveTimers.values) {
      timer.cancel();
    }
    _autoSaveTimers.clear();
    super.dispose();
  }

  BattlePlanEditorViewState _buildSyncedState(List<PlanElement> items) {
    final Set<int> existingIds = items
        .map((PlanElement item) => item.id)
        .toSet();

    _pendingGeometrySaves.removeWhere(
      (int key, _PendingElementGeometrySave _) => !existingIds.contains(key),
    );
    _autoSaveTimers.removeWhere((int key, Timer timer) {
      if (existingIds.contains(key)) {
        return false;
      }

      timer.cancel();
      return true;
    });

    BattlePlanEditorViewState nextState = _viewState.pruneMissingIds(
      existingIds,
    );

    for (final PlanElement item in items) {
      final Offset? draftPosition = nextState.draftPositions[item.id];
      final Size? draftSize = nextState.draftSizes[item.id];
      final double? draftRotation = nextState.draftRotations[item.id];
      if (draftPosition == null && draftSize == null && draftRotation == null) {
        continue;
      }

      final bool hasPendingSave = _pendingGeometrySaves.containsKey(item.id);
      final bool isDragging = nextState.draggingElementId == item.id;
      final bool isResizing = nextState.resizingElementId == item.id;
      final bool isRotating = nextState.rotatingElementId == item.id;
      final bool positionSynced =
          draftPosition == null ||
          _positionsAreEqual(draftPosition, Offset(item.x, item.y));
      final bool sizeSynced =
          draftSize == null ||
          _sizesAreEqual(draftSize, Size(item.width, item.height));
      final bool rotationSynced =
          draftRotation == null || (draftRotation - item.rotation).abs() < 0.01;
      if (!hasPendingSave &&
          !isDragging &&
          !isResizing &&
          !isRotating &&
          positionSynced &&
          sizeSynced &&
          rotationSynced) {
        nextState = nextState
            .removeDraftPosition(item.id)
            .removeDraftSize(item.id)
            .removeDraftRotation(item.id);
      }
    }

    return nextState;
  }

  void _replaceViewState(BattlePlanEditorViewState nextState) {
    if (_viewStatesEqual(_viewState, nextState)) {
      return;
    }

    _viewState = nextState;
    notifyListeners();
  }

  bool _viewStatesEqual(
    BattlePlanEditorViewState a,
    BattlePlanEditorViewState b,
  ) {
    return a.selectedElementId == b.selectedElementId &&
        a.currentStepId == b.currentStepId &&
        a.draggingElementId == b.draggingElementId &&
        a.rotatingElementId == b.rotatingElementId &&
        a.resizingElementId == b.resizingElementId &&
        a.isMutating == b.isMutating &&
        mapEquals<int, Offset>(a.draftPositions, b.draftPositions) &&
        mapEquals<int, Size>(a.draftSizes, b.draftSizes) &&
        mapEquals<int, double>(a.draftRotations, b.draftRotations);
  }

  Offset _clampPosition({
    required Offset position,
    required PlanElement element,
    required double mapWidth,
    required double mapHeight,
  }) {
    final double maxX = math.max(0, mapWidth - element.width);
    final double maxY = math.max(0, mapHeight - element.height);

    return Offset(position.dx.clamp(0, maxX), position.dy.clamp(0, maxY));
  }

  bool _positionsAreEqual(Offset a, Offset b) {
    return (a.dx - b.dx).abs() < 0.5 && (a.dy - b.dy).abs() < 0.5;
  }

  bool _sizesAreEqual(Size a, Size b) {
    return (a.width - b.width).abs() < 0.5 && (a.height - b.height).abs() < 0.5;
  }

  void _scheduleGeometryAutoSave({
    required PlanElement element,
    required Offset position,
    required Size size,
    required double rotation,
    Duration delay = autoSaveDelay,
  }) {
    final int? currentStepId = _viewState.currentStepId;
    if (currentStepId == null) {
      return;
    }

    _pendingGeometrySaves[element.id] = _PendingElementGeometrySave(
      element: element,
      position: position,
      size: size,
      rotation: rotation,
      stepId: currentStepId,
    );

    _autoSaveTimers[element.id]?.cancel();
    _autoSaveTimers[element.id] = Timer(delay, () {
      unawaited(_flushPendingGeometrySave(element.id));
    });
  }

  void _discardPendingGeometrySave(int elementId) {
    _pendingGeometrySaves.remove(elementId);
    final Timer? timer = _autoSaveTimers.remove(elementId);
    timer?.cancel();
  }

  Future<void> _flushPendingGeometrySave(int elementId) async {
    final _PendingElementGeometrySave? pendingSave = _pendingGeometrySaves
        .remove(elementId);
    final Timer? timer = _autoSaveTimers.remove(elementId);
    timer?.cancel();

    if (pendingSave == null) {
      return;
    }

    await _editorService.updateGeometry(
      stepId: pendingSave.stepId,
      element: pendingSave.element,
      position: pendingSave.position,
      size: pendingSave.size,
      rotation: pendingSave.rotation,
    );
  }
}

class _PendingElementGeometrySave {
  const _PendingElementGeometrySave({
    required this.element,
    required this.position,
    required this.size,
    required this.rotation,
    required this.stepId,
  });

  final PlanElement element;
  final Offset position;
  final Size size;
  final double rotation;
  final int stepId;
}
