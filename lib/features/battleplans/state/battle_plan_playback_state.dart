enum BattlePlanPlaybackMode { stopped, playing, paused }

class BattlePlanPlaybackState {
  const BattlePlanPlaybackState({
    required this.mode,
    required this.transitionDuration,
    this.fromStepId,
    this.toStepId,
    this.progress = 0,
    this.autoAdvance = false,
  });

  const BattlePlanPlaybackState.stopped({
    this.transitionDuration = const Duration(milliseconds: 650),
  }) : mode = BattlePlanPlaybackMode.stopped,
       fromStepId = null,
       toStepId = null,
       progress = 0,
       autoAdvance = false;

  final BattlePlanPlaybackMode mode;
  final int? fromStepId;
  final int? toStepId;
  final double progress;
  final bool autoAdvance;
  final Duration transitionDuration;

  bool get isPlaying => mode == BattlePlanPlaybackMode.playing;
  bool get isPaused => mode == BattlePlanPlaybackMode.paused;
  bool get isStopped => mode == BattlePlanPlaybackMode.stopped;
  bool get isAnimating => fromStepId != null && toStepId != null;
  bool get isLocked => isAnimating || isPlaying || isPaused;

  BattlePlanPlaybackState copyWith({
    BattlePlanPlaybackMode? mode,
    Object? fromStepId = _unset,
    Object? toStepId = _unset,
    double? progress,
    bool? autoAdvance,
    Duration? transitionDuration,
  }) {
    return BattlePlanPlaybackState(
      mode: mode ?? this.mode,
      fromStepId: identical(fromStepId, _unset)
          ? this.fromStepId
          : fromStepId as int?,
      toStepId: identical(toStepId, _unset) ? this.toStepId : toStepId as int?,
      progress: progress ?? this.progress,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      transitionDuration: transitionDuration ?? this.transitionDuration,
    );
  }

  static const Object _unset = Object();
}
