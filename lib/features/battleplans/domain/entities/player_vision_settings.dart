class PlayerVisionSettings {
  const PlayerVisionSettings({
    required this.visionRange,
    required this.visionFovDegrees,
    required this.showVisionCone,
    required this.showAimLine,
  });

  const PlayerVisionSettings.defaults()
    : visionRange = 340,
      visionFovDegrees = 68,
      showVisionCone = true,
      showAimLine = true;

  final double visionRange;
  final double visionFovDegrees;
  final bool showVisionCone;
  final bool showAimLine;

  PlayerVisionSettings copyWith({
    double? visionRange,
    double? visionFovDegrees,
    bool? showVisionCone,
    bool? showAimLine,
  }) {
    return PlayerVisionSettings(
      visionRange: visionRange ?? this.visionRange,
      visionFovDegrees: visionFovDegrees ?? this.visionFovDegrees,
      showVisionCone: showVisionCone ?? this.showVisionCone,
      showAimLine: showAimLine ?? this.showAimLine,
    );
  }
}
