import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class PlayerRenderMetrics {
  const PlayerRenderMetrics({
    required this.bodyDiameter,
    required this.iconSize,
    required this.selectionHaloSpread,
    required this.selectionHaloBlur,
    required this.selectionOutlineWidth,
    required this.aimLength,
    required this.aimStrokeWidth,
    required this.aimGlowWidth,
    required this.rotationHandleDiameter,
    required this.rotationHandleIconSize,
    required this.rotationHandleOrbitPadding,
    required this.rotationHandleHintRadius,
  });

  factory PlayerRenderMetrics.fromSize(Size size) {
    final double bodyDiameter = math.max(math.min(size.width, size.height), 24);

    return PlayerRenderMetrics(
      bodyDiameter: bodyDiameter,
      iconSize: math.max(bodyDiameter * 0.48, 18),
      selectionHaloSpread: math.max(bodyDiameter * 0.035, 1),
      selectionHaloBlur: math.max(bodyDiameter * 0.12, 6),
      selectionOutlineWidth: math.max(bodyDiameter * 0.035, 1.6),
      aimLength: math.max(bodyDiameter * 1.05, 40),
      aimStrokeWidth: math.max(bodyDiameter * 0.04, 2),
      aimGlowWidth: math.max(bodyDiameter * 0.1, 4),
      rotationHandleDiameter: math.max(bodyDiameter * 0.42, 28),
      rotationHandleIconSize: math.max(bodyDiameter * 0.22, 16),
      rotationHandleOrbitPadding: math.max(bodyDiameter * 0.14, 8),
      rotationHandleHintRadius: math.max(bodyDiameter * 0.26, 12),
    );
  }

  final double bodyDiameter;
  final double iconSize;
  final double selectionHaloSpread;
  final double selectionHaloBlur;
  final double selectionOutlineWidth;
  final double aimLength;
  final double aimStrokeWidth;
  final double aimGlowWidth;
  final double rotationHandleDiameter;
  final double rotationHandleIconSize;
  final double rotationHandleOrbitPadding;
  final double rotationHandleHintRadius;

  double get aimExtent {
    return math.max(
      aimLength + rotationHandleOrbitPadding + rotationHandleDiameter / 2,
      bodyDiameter / 2,
    );
  }
}
