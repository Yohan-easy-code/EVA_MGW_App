import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/logic/player_vision_service.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/battle_plan_canvas_viewport.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/player_vision_render_data.dart';

class PlayerVisionPainter extends CustomPainter {
  const PlayerVisionPainter({
    required this.viewport,
    required this.visionResults,
  });

  final BattlePlanCanvasViewport viewport;
  final List<(PlayerVisionRenderData, PlayerVisionResult)> visionResults;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (PlayerVisionRenderData data, PlayerVisionResult result)
        in visionResults) {
      final Color baseColor = data.color;
      if (data.showCone && result.polygon.length >= 3) {
        final Path conePath = Path();
        final Offset first = viewport.toMapLocalOffset(result.polygon.first);
        conePath.moveTo(first.dx, first.dy);
        for (final Offset point in result.polygon.skip(1)) {
          final Offset mapped = viewport.toMapLocalOffset(point);
          conePath.lineTo(mapped.dx, mapped.dy);
        }
        conePath.close();

        final Paint fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor.withAlpha(data.isSelected ? 34 : 22);
        final Paint strokePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = data.isSelected ? 1.4 : 0.9
          ..color = baseColor.withAlpha(data.isSelected ? 112 : 78);

        canvas.drawPath(conePath, fillPaint);
        canvas.drawPath(conePath, strokePaint);
      }

      if (data.showAimLine) {
        final Offset origin = viewport.toMapLocalOffset(data.origin);
        final Offset aimEnd = viewport.toMapLocalOffset(result.aimEnd);
        final Paint linePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = data.isSelected ? 2 : 1.6
          ..color = baseColor.withAlpha(248);

        canvas.drawLine(origin, aimEnd, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlayerVisionPainter oldDelegate) {
    return oldDelegate.viewport != viewport ||
        oldDelegate.visionResults != visionResults;
  }
}
