import 'dart:math' as math;
import 'dart:ui';

class PlayerVisionResult {
  const PlayerVisionResult({required this.polygon, required this.aimEnd});

  final List<Offset> polygon;
  final Offset aimEnd;
}

final class PlayerVisionService {
  const PlayerVisionService._();

  static PlayerVisionResult compute({
    required Offset origin,
    required double angle,
    required double range,
    required double fovDegrees,
    int segmentCount = 28,
  }) {
    final double clampedRange = range.clamp(24, 1200);
    final double fovRadians = (fovDegrees.clamp(8, 175) * math.pi) / 180;
    final double startAngle = angle - (fovRadians / 2);
    final double endAngle = angle + (fovRadians / 2);
    final List<Offset> polygon = <Offset>[origin];

    for (int index = 0; index <= segmentCount; index += 1) {
      final double t = index / segmentCount;
      final double currentAngle = startAngle + (endAngle - startAngle) * t;
      polygon.add(
        origin +
            Offset(math.cos(currentAngle), math.sin(currentAngle)) *
                clampedRange,
      );
    }

    final Offset aimEnd =
        origin + Offset(math.cos(angle), math.sin(angle)) * clampedRange;

    return PlayerVisionResult(polygon: polygon, aimEnd: aimEnd);
  }
}
