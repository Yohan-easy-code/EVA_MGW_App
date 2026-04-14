class PlanElement {
  const PlanElement({
    required this.id,
    required this.battlePlanId,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.color,
    this.label,
    this.extraJson,
  });

  final int id;
  final int battlePlanId;
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final int color;
  final String? label;
  final String? extraJson;

  static const Object _unset = Object();

  PlanElement copyWith({
    int? id,
    int? battlePlanId,
    String? type,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    int? color,
    Object? label = _unset,
    Object? extraJson = _unset,
  }) {
    return PlanElement(
      id: id ?? this.id,
      battlePlanId: battlePlanId ?? this.battlePlanId,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      label: identical(label, _unset) ? this.label : label as String?,
      extraJson: identical(extraJson, _unset)
          ? this.extraJson
          : extraJson as String?,
    );
  }
}
