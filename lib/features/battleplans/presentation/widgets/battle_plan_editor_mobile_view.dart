import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan_step.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_controller.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_render_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_canvas.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_editor_mobile_quick_menu.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_playback_controls.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class BattlePlanEditorMobileView extends StatefulWidget {
  const BattlePlanEditorMobileView({
    required this.mapAsset,
    required this.currentStep,
    required this.renderElements,
    required this.controller,
    required this.playbackState,
    required this.onBackPressed,
    required this.onOpenSecondaryMenu,
    required this.onAddElement,
    required this.onEditSelected,
    required this.onDuplicateSelected,
    required this.onDeleteSelected,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
    super.key,
  });

  final MapAsset mapAsset;
  final BattlePlanStep currentStep;
  final List<BattlePlanRenderElement> renderElements;
  final BattlePlanEditorController controller;
  final BattlePlanPlaybackState playbackState;
  final VoidCallback onBackPressed;
  final VoidCallback onOpenSecondaryMenu;
  final ValueChanged<PlanElementType> onAddElement;
  final VoidCallback onEditSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onDeleteSelected;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;

  @override
  State<BattlePlanEditorMobileView> createState() =>
      _BattlePlanEditorMobileViewState();
}

class _BattlePlanEditorMobileViewState
    extends State<BattlePlanEditorMobileView> {
  static const double _mobileHeaderCompactWidth = 296;
  static const double _mobileHeaderCompactHeight = 44;
  static const double _mobileHeaderExpandedHeight = 108;
  static const double _mobileHeaderScreenInset = 6;

  int _headerCollapseToken = 0;
  Offset? _headerOffset;
  bool _isHeaderExpanded = false;

  static const double _mobilePrimaryFabRightInset = 12;
  static const double _mobilePrimaryFabBottomInset = 18;
  static const double _mobileOverlayRightReserve = 112;

  void _requestHeaderCollapse() {
    setState(() {
      _headerCollapseToken += 1;
    });
  }

  void _updateHeaderExpanded(bool value) {
    if (_isHeaderExpanded == value) {
      return;
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size viewportSize = mediaQuery.size;
    final Offset candidate =
        _headerOffset ??
        Offset(_mobileHeaderScreenInset, mediaQuery.padding.top + 4);

    setState(() {
      _isHeaderExpanded = value;
      final double maxWidth =
          viewportSize.width - (_mobileHeaderScreenInset * 2);
      final double headerWidth = value
          ? maxWidth
          : (_mobileHeaderCompactWidth < maxWidth
                ? _mobileHeaderCompactWidth
                : maxWidth);
      final double headerHeight = value
          ? _mobileHeaderExpandedHeight
          : _mobileHeaderCompactHeight;
      const double minLeft = _mobileHeaderScreenInset;
      final double minTop = mediaQuery.padding.top + 4;
      final double maxLeft =
          viewportSize.width - headerWidth - _mobileHeaderScreenInset;
      final double maxTop =
          viewportSize.height - headerHeight - mediaQuery.padding.bottom - 8;

      _headerOffset = Offset(
        candidate.dx.clamp(minLeft, maxLeft < minLeft ? minLeft : maxLeft),
        candidate.dy.clamp(minTop, maxTop < minTop ? minTop : maxTop),
      );
    });
  }

  void _updateHeaderOffset({
    required Offset candidate,
    required Size viewportSize,
    required EdgeInsets safePadding,
  }) {
    final double maxWidth = viewportSize.width - (_mobileHeaderScreenInset * 2);
    final double headerWidth = _isHeaderExpanded
        ? maxWidth
        : (_mobileHeaderCompactWidth < maxWidth
              ? _mobileHeaderCompactWidth
              : maxWidth);
    final double headerHeight = _isHeaderExpanded
        ? _mobileHeaderExpandedHeight
        : _mobileHeaderCompactHeight;

    const double minLeft = _mobileHeaderScreenInset;
    final double minTop = safePadding.top + 4;
    final double maxLeft =
        viewportSize.width - headerWidth - _mobileHeaderScreenInset;
    final double maxTop =
        viewportSize.height - headerHeight - safePadding.bottom - 8;

    setState(() {
      _headerOffset = Offset(
        candidate.dx.clamp(minLeft, maxLeft < minLeft ? minLeft : maxLeft),
        candidate.dy.clamp(minTop, maxTop < minTop ? minTop : maxTop),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<PlanElement> resolvedElements = widget.renderElements
        .map((BattlePlanRenderElement item) => item.element)
        .toList(growable: false);
    final PlanElement? selectedElement = widget.controller.selectedElementFrom(
      resolvedElements,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size viewportSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final Offset effectiveHeaderOffset =
            _headerOffset ??
            Offset(_mobileHeaderScreenInset, mediaQuery.padding.top + 4);

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: BattlePlanCanvas(
                mapAsset: widget.mapAsset,
                renderElements: widget.renderElements,
                viewState: widget.controller.viewState,
                isReadOnly: widget.playbackState.isLocked,
                onBackgroundTap: () {
                  _requestHeaderCollapse();
                  widget.controller.clearSelection();
                },
                onSelectElement: (int elementId) {
                  _requestHeaderCollapse();
                  widget.controller.selectElement(elementId);
                },
                onStartDragging: (int elementId) {
                  _requestHeaderCollapse();
                  widget.controller.startDragging(elementId);
                },
                onUpdateDragging: (PlanElement element, Offset delta) {
                  widget.controller.updateDragging(
                    element: element,
                    delta: delta,
                    mapWidth: widget.mapAsset.width.toDouble(),
                    mapHeight: widget.mapAsset.height.toDouble(),
                  );
                },
                onCommitDragging: widget.controller.commitDragging,
                onCancelDragging: widget.controller.cancelDragging,
                onStartResizing: (int elementId) {
                  _requestHeaderCollapse();
                  widget.controller.startResizing(elementId);
                },
                onUpdateResizing: (PlanElement element, Offset delta) {
                  widget.controller.updateResizing(
                    element: element,
                    delta: delta,
                    mapWidth: widget.mapAsset.width.toDouble(),
                    mapHeight: widget.mapAsset.height.toDouble(),
                  );
                },
                onCommitResizing: widget.controller.commitResizing,
                onCancelResizing: widget.controller.cancelResizing,
                onStartRotating: (int elementId) {
                  _requestHeaderCollapse();
                  widget.controller.startRotating(elementId);
                },
                onUpdateRotating: (PlanElement element, Offset aimPoint) {
                  widget.controller.updateRotating(
                    element: element,
                    aimPoint: aimPoint,
                  );
                },
                onCommitRotating: widget.controller.commitRotating,
                onCancelRotating: widget.controller.cancelRotating,
              ),
            ),
            Positioned(
              left: effectiveHeaderOffset.dx,
              top: effectiveHeaderOffset.dy,
              child: _DraggableHeaderAnchor(
                onDragUpdate: (Offset delta) {
                  _updateHeaderOffset(
                    candidate: effectiveHeaderOffset + delta,
                    viewportSize: viewportSize,
                    safePadding: mediaQuery.padding,
                  );
                },
                child: _MobileTopOverlay(
                  mapName: widget.mapAsset.displayName,
                  stepTitle: widget.currentStep.title,
                  elementsCount: widget.renderElements.length,
                  playbackState: widget.playbackState,
                  collapseToken: _headerCollapseToken,
                  onExpandedChanged: _updateHeaderExpanded,
                  onBackPressed: widget.onBackPressed,
                  onOpenSecondaryMenu: widget.onOpenSecondaryMenu,
                ),
              ),
            ),
            _MobilePrimaryFabAnchor(
              rightInset: _mobilePrimaryFabRightInset,
              bottomInset: _mobilePrimaryFabBottomInset,
              child: BattlePlanEditorMobileQuickMenu(
                isMutating:
                    widget.controller.isMutating ||
                    widget.playbackState.isLocked,
                onAddElement: widget.onAddElement,
              ),
            ),
            Positioned(
              top: 48,
              right: 8,
              child: SafeArea(
                bottom: false,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 204),
                  child: BattlePlanPlaybackControls(
                    state: widget.playbackState,
                    compact: true,
                    showStatusLabel: false,
                    onPlay: widget.onPlay,
                    onPause: widget.onPause,
                    onStop: widget.onStop,
                    onPreviousStep: widget.onPreviousStep,
                    onNextStep: widget.onNextStep,
                  ),
                ),
              ),
            ),
            if (selectedElement != null)
              Positioned(
                left: 12,
                right: _mobileOverlayRightReserve,
                bottom: 18,
                child: SafeArea(
                  top: false,
                  child: _MobileSelectionBar(
                    element: selectedElement,
                    isLocked:
                        widget.controller.isMutating ||
                        widget.playbackState.isLocked,
                    onEditSelected: widget.onEditSelected,
                    onDuplicateSelected: widget.onDuplicateSelected,
                    onDeleteSelected: widget.onDeleteSelected,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DraggableHeaderAnchor extends StatelessWidget {
  const _DraggableHeaderAnchor({
    required this.onDragUpdate,
    required this.child,
  });

  final ValueChanged<Offset> onDragUpdate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onPanUpdate: (DragUpdateDetails details) {
        onDragUpdate(details.delta);
      },
      child: child,
    );
  }
}

class _MobilePrimaryFabAnchor extends StatelessWidget {
  const _MobilePrimaryFabAnchor({
    required this.rightInset,
    required this.bottomInset,
    required this.child,
  });

  final double rightInset;
  final double bottomInset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: rightInset,
      bottom: bottomInset,
      child: SafeArea(top: false, child: child),
    );
  }
}

class _MobileTopOverlay extends StatefulWidget {
  const _MobileTopOverlay({
    required this.mapName,
    required this.stepTitle,
    required this.elementsCount,
    required this.playbackState,
    required this.collapseToken,
    required this.onExpandedChanged,
    required this.onBackPressed,
    required this.onOpenSecondaryMenu,
  });

  final String mapName;
  final String stepTitle;
  final int elementsCount;
  final BattlePlanPlaybackState playbackState;
  final int collapseToken;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback onBackPressed;
  final VoidCallback onOpenSecondaryMenu;

  @override
  State<_MobileTopOverlay> createState() => _MobileTopOverlayState();
}

class _MobileTopOverlayState extends State<_MobileTopOverlay> {
  static const Duration _autoCollapseDelay = Duration(seconds: 4);
  static const double _compactHeight = 44;
  static const double _expandedHeight = 108;

  bool _isExpanded = false;
  Timer? _autoCollapseTimer;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpandedChanged(_isExpanded);
    _syncAutoCollapseTimer();
  }

  @override
  void didUpdateWidget(covariant _MobileTopOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.collapseToken != oldWidget.collapseToken && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      widget.onExpandedChanged(false);
      _cancelAutoCollapseTimer();
    }
  }

  @override
  void dispose() {
    _cancelAutoCollapseTimer();
    super.dispose();
  }

  void _syncAutoCollapseTimer() {
    _cancelAutoCollapseTimer();
    if (!_isExpanded) {
      return;
    }

    _autoCollapseTimer = Timer(_autoCollapseDelay, () {
      if (!mounted || !_isExpanded) {
        return;
      }

      setState(() {
        _isExpanded = false;
      });
      widget.onExpandedChanged(false);
    });
  }

  void _cancelAutoCollapseTimer() {
    _autoCollapseTimer?.cancel();
    _autoCollapseTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius borderRadius = BorderRadius.circular(
      _isExpanded ? 16 : 999,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double expandedWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 12;
        final double compactWidth = expandedWidth < 296 ? expandedWidth : 296;

        return Align(
          alignment: Alignment.topLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: _isExpanded ? expandedWidth : compactWidth,
            height: _isExpanded ? _expandedHeight : _compactHeight,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withAlpha(
                      _isExpanded ? 108 : 96,
                    ),
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: colorScheme.outlineVariant.withAlpha(64),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _OverlayIconButton(
                              icon: BattlePlanEditorIcons.back,
                              tooltip: 'Retour',
                              onTap: widget.onBackPressed,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: InkWell(
                                onTap: _toggleExpanded,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.mapName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.labelMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        _isExpanded
                                            ? BattlePlanEditorIcons.expandLess
                                            : BattlePlanEditorIcons.expandMore,
                                        size: BattlePlanEditorIcons
                                            .compactIconSize,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            _OverlayIconButton(
                              icon: BattlePlanEditorIcons.more,
                              tooltip: 'Outils',
                              onTap: widget.onOpenSecondaryMenu,
                            ),
                          ],
                        ),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: !_isExpanded,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 140),
                              opacity: _isExpanded ? 1 : 0,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: <Widget>[
                                      _MobileInfoChip(
                                        icon: BattlePlanEditorIcons.route,
                                        label: widget.stepTitle,
                                      ),
                                      _MobileInfoChip(
                                        icon: BattlePlanEditorIcons.layers,
                                        label:
                                            '${widget.elementsCount} elements',
                                      ),
                                      _MobileInfoChip(
                                        icon: widget.playbackState.isPlaying
                                            ? BattlePlanEditorIcons.pause
                                            : BattlePlanEditorIcons.play,
                                        label: _playbackLabel(
                                          widget.playbackState,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _playbackLabel(BattlePlanPlaybackState state) {
    if (state.isPlaying) {
      return state.isAnimating
          ? 'Lecture ${(state.progress * 100).round()}%'
          : 'Lecture';
    }
    if (state.isPaused) {
      return 'Pause ${(state.progress * 100).round()}%';
    }
    if (state.isAnimating) {
      return 'Transition ${(state.progress * 100).round()}%';
    }
    return 'Pret';
  }
}

class _MobileInfoChip extends StatelessWidget {
  const _MobileInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(68)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: BattlePlanEditorIcons.compactIconSize - 2,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 128),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileSelectionBar extends StatelessWidget {
  const _MobileSelectionBar({
    required this.element,
    required this.isLocked,
    required this.onEditSelected,
    required this.onDuplicateSelected,
    required this.onDeleteSelected,
  });

  final PlanElement element;
  final bool isLocked;
  final VoidCallback onEditSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface.withAlpha(214),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colorScheme.outlineVariant.withAlpha(90)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    element.label?.trim().isNotEmpty == true
                        ? element.label!
                        : 'Element selectionne',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _OverlayIconButton(
                  icon: BattlePlanEditorIcons.edit,
                  tooltip: 'Editer',
                  onTap: isLocked ? null : onEditSelected,
                ),
                const SizedBox(width: 8),
                _OverlayIconButton(
                  icon: BattlePlanEditorIcons.duplicate,
                  tooltip: 'Dupliquer',
                  onTap: isLocked ? null : onDuplicateSelected,
                ),
                const SizedBox(width: 8),
                _OverlayIconButton(
                  icon: BattlePlanEditorIcons.delete,
                  tooltip: 'Supprimer',
                  isDestructive: true,
                  onTap: isLocked ? null : onDeleteSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayIconButton extends StatelessWidget {
  const _OverlayIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color accentColor = isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(92),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  (isDestructive
                          ? colorScheme.error
                          : colorScheme.outlineVariant)
                      .withAlpha(84),
            ),
          ),
          child: Icon(
            icon,
            size: BattlePlanEditorIcons.compactIconSize,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
