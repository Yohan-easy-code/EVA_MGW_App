import 'dart:math' as math;

import 'package:flutter/material.dart';

class ZoneCircleElementPainter extends CustomPainter {
  const ZoneCircleElementPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.max(0, math.min(size.width, size.height) / 2);
    final Paint fillPaint = Paint()
      ..color = color.withAlpha(64)
      ..style = PaintingStyle.fill;
    final Paint glowPaint = Paint()
      ..color = color.withAlpha(52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(7, radius * 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final Paint ringPaint = Paint()
      ..color = color.withAlpha(245)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(3.2, radius * 0.055);
    final Paint outerContrastPaint = Paint()
      ..color = Colors.white.withAlpha(168)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, radius * 0.02);
    final Paint innerRingPaint = Paint()
      ..color = color.withAlpha(176)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, radius * 0.028);

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, glowPaint);
    canvas.drawCircle(center, radius, ringPaint);
    canvas.drawCircle(center, radius * 0.94, outerContrastPaint);
    canvas.drawCircle(center, radius * 0.68, innerRingPaint);
  }

  @override
  bool shouldRepaint(covariant ZoneCircleElementPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
