class BattlePlanStep {
  const BattlePlanStep({
    required this.id,
    required this.battlePlanId,
    required this.title,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int battlePlanId;
  final String title;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  BattlePlanStep copyWith({
    int? id,
    int? battlePlanId,
    String? title,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BattlePlanStep(
      id: id ?? this.id,
      battlePlanId: battlePlanId ?? this.battlePlanId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
