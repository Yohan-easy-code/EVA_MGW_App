class BattlePlanStepElementState {
  const BattlePlanStepElementState({
    required this.id,
    required this.stepId,
    required this.planElementId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.color,
    required this.isVisible,
    this.label,
  });

  final int id;
  final int stepId;
  final int planElementId;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final int color;
  final String? label;
  final bool isVisible;

  BattlePlanStepElementState copyWith({
    int? id,
    int? stepId,
    int? planElementId,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    int? color,
    String? label,
    bool? isVisible,
  }) {
    return BattlePlanStepElementState(
      id: id ?? this.id,
      stepId: stepId ?? this.stepId,
      planElementId: planElementId ?? this.planElementId,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      label: label ?? this.label,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
