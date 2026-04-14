import 'dart:math' as math;

import 'package:flutter/material.dart';

class ArrowElementPainter extends CustomPainter {
  const ArrowElementPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withAlpha(88)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = math.max(6, size.height * 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final Paint outlinePaint = Paint()
      ..color = Colors.white.withAlpha(210)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = math.max(4.8, size.height * 0.16);
    final Paint shaftPaint = Paint()
      ..color = color.withAlpha(250)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = math.max(4, size.height * 0.14);
    final Paint fillPaint = Paint()
      ..color = color.withAlpha(112)
      ..style = PaintingStyle.fill;

    final double centerY = size.height / 2;
    final double startX = size.width * 0.12;
    final double endX = size.width * 0.84;
    final double headLength = math.min(size.width * 0.22, 32);
    final double headHalfHeight = math.max(size.height * 0.22, 10);

    final Path bodyPath = Path()
      ..moveTo(startX, centerY)
      ..lineTo(endX, centerY);
    final Path headPath = Path()
      ..moveTo(endX - headLength, centerY - headHalfHeight)
      ..lineTo(endX, centerY)
      ..lineTo(endX - headLength, centerY + headHalfHeight)
      ..close();

    canvas.drawPath(
      Path()..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            startX,
            centerY - shaftPaint.strokeWidth / 2,
            endX - startX - headLength * 0.35,
            shaftPaint.strokeWidth,
          ),
          Radius.circular(shaftPaint.strokeWidth),
        ),
      ),
      fillPaint,
    );
    canvas.drawPath(bodyPath, shadowPaint);
    canvas.drawPath(bodyPath, outlinePaint);
    canvas.drawPath(bodyPath, shaftPaint);
    canvas.drawPath(headPath, fillPaint);
    canvas.drawPath(headPath, outlinePaint);
    canvas.drawPath(headPath, shaftPaint);
  }

  @override
  bool shouldRepaint(covariant ArrowElementPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
