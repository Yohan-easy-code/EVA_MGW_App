import 'dart:ui';

class PlayerVisionRenderData {
  const PlayerVisionRenderData({
    required this.origin,
    required this.rotation,
    required this.range,
    required this.fovDegrees,
    required this.color,
    required this.showCone,
    required this.showAimLine,
    required this.isSelected,
  });

  final Offset origin;
  final double rotation;
  final double range;
  final double fovDegrees;
  final Color color;
  final bool showCone;
  final bool showAimLine;
  final bool isSelected;
}
