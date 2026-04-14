import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_playback_state.dart';

class BattlePlanPlaybackControls extends StatelessWidget {
  const BattlePlanPlaybackControls({
    required this.state,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onPreviousStep,
    required this.onNextStep,
    this.compact = false,
    this.showStatusLabel = true,
    super.key,
  });

  final BattlePlanPlaybackState state;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;
  final bool compact;
  final bool showStatusLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(68),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 8 : 12),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isNarrow = constraints.maxWidth < 270;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    _PlaybackIconButton(
                      icon: BattlePlanEditorIcons.previous,
                      tooltip: 'Etape precedente',
                      onPressed: state.isAnimating ? null : onPreviousStep,
                    ),
                    _PlaybackIconButton(
                      icon: state.isPlaying
                          ? BattlePlanEditorIcons.pause
                          : BattlePlanEditorIcons.play,
                      tooltip: state.isPlaying ? 'Pause' : 'Play',
                      onPressed: state.isPlaying ? onPause : onPlay,
                      isPrimary: true,
                    ),
                    _PlaybackIconButton(
                      icon: BattlePlanEditorIcons.stop,
                      tooltip: 'Stop',
                      onPressed: state.isStopped && !state.isAnimating
                          ? null
                          : onStop,
                    ),
                    _PlaybackIconButton(
                      icon: BattlePlanEditorIcons.next,
                      tooltip: 'Etape suivante',
                      onPressed: state.isAnimating ? null : onNextStep,
                    ),
                  ],
                ),
                if (showStatusLabel) ...<Widget>[
                  SizedBox(height: isNarrow ? 8 : 10),
                  Text(
                    _labelForState(state),
                    maxLines: isNarrow ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  String _labelForState(BattlePlanPlaybackState state) {
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

    return 'Pret a lire';
  }
}

class _PlaybackIconButton extends StatelessWidget {
  const _PlaybackIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: onPressed == null
                ? colorScheme.surface.withAlpha(45)
                : isPrimary
                ? colorScheme.primary.withAlpha(26)
                : colorScheme.surface.withAlpha(90),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: onPressed == null
                  ? colorScheme.outlineVariant.withAlpha(50)
                  : isPrimary
                  ? colorScheme.primary.withAlpha(140)
                  : colorScheme.outlineVariant.withAlpha(80),
            ),
          ),
          child: Icon(
            icon,
            size: BattlePlanEditorIcons.panelIconSize,
            color: onPressed == null
                ? colorScheme.onSurfaceVariant.withAlpha(90)
                : isPrimary
                ? colorScheme.primary
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
