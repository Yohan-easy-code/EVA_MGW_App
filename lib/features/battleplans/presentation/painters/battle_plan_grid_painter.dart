import 'package:flutter/material.dart';

class BattlePlanGridPainter extends CustomPainter {
  const BattlePlanGridPainter({
    required this.lineColor,
    required this.boldLineColor,
  });

  final Color lineColor;
  final Color boldLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const double smallStep = 48;
    const double boldEvery = 4;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final Paint boldPaint = Paint()
      ..color = boldLineColor
      ..strokeWidth = 1.4;

    double x = 0;
    int column = 0;
    while (x <= size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        column % boldEvery == 0 ? boldPaint : linePaint,
      );
      x += smallStep;
      column += 1;
    }

    double y = 0;
    int row = 0;
    while (y <= size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        row % boldEvery == 0 ? boldPaint : linePaint,
      );
      y += smallStep;
      row += 1;
    }
  }

  @override
  bool shouldRepaint(BattlePlanGridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.boldLineColor != boldLineColor;
  }
}
