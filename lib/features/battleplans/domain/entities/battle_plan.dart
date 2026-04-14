class BattlePlan {
  const BattlePlan({
    required this.id,
    required this.name,
    required this.mapId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final int mapId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BattlePlan copyWith({
    int? id,
    String? name,
    int? mapId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BattlePlan(
      id: id ?? this.id,
      name: name ?? this.name,
      mapId: mapId ?? this.mapId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
