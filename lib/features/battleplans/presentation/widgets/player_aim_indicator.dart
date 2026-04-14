import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/player_render_metrics.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';

class PlayerAimIndicator extends StatelessWidget {
  const PlayerAimIndicator({
    required this.angle,
    required this.metrics,
    required this.color,
    required this.showHandle,
    this.onStartRotating,
    this.onUpdateRotating,
    this.onCommitRotating,
    this.onCancelRotating,
    super.key,
  });

  final double angle;
  final PlayerRenderMetrics metrics;
  final Color color;
  final bool showHandle;
  final VoidCallback? onStartRotating;
  final ValueChanged<Offset>? onUpdateRotating;
  final VoidCallback? onCommitRotating;
  final VoidCallback? onCancelRotating;

  @override
  Widget build(BuildContext context) {
    final double extent = math.max(metrics.aimExtent, 56);

    return SizedBox(
      width: extent * 2,
      height: extent * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PlayerAimIndicatorPainter(
                  angle: angle,
                  metrics: metrics,
                  color: color,
                  showHandle: showHandle,
                ),
              ),
            ),
          ),
          if (showHandle)
            Positioned(
              left:
                  extent +
                  math.cos(angle) * metrics.aimLength -
                  metrics.rotationHandleDiameter / 2,
              top:
                  extent +
                  math.sin(angle) * metrics.aimLength -
                  metrics.rotationHandleDiameter / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: onStartRotating == null
                    ? null
                    : (_) => onStartRotating!(),
                onPanUpdate: onUpdateRotating == null
                    ? null
                    : (DragUpdateDetails details) {
                        onUpdateRotating!(details.globalPosition);
                      },
                onPanEnd: onCommitRotating == null
                    ? null
                    : (_) => onCommitRotating!(),
                onPanCancel: onCancelRotating,
                child: Container(
                  width: metrics.rotationHandleDiameter,
                  height: metrics.rotationHandleDiameter,
                  decoration: BoxDecoration(
                    color: color.withAlpha(240),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha(220),
                      width: 2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: color.withAlpha(120),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    BattlePlanEditorIcons.rotate,
                    size: metrics.rotationHandleIconSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlayerAimIndicatorPainter extends CustomPainter {
  const _PlayerAimIndicatorPainter({
    required this.angle,
    required this.metrics,
    required this.color,
    required this.showHandle,
  });

  final double angle;
  final PlayerRenderMetrics metrics;
  final Color color;
  final bool showHandle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset end =
        center + Offset(math.cos(angle), math.sin(angle)) * metrics.aimLength;

    final Paint linePaint = Paint()
      ..color = Colors.white.withAlpha(240)
      ..strokeWidth = metrics.aimStrokeWidth + 0.6
      ..strokeCap = StrokeCap.round;
    final Paint corePaint = Paint()
      ..color = color.withAlpha(250)
      ..strokeWidth = metrics.aimStrokeWidth
      ..strokeCap = StrokeCap.round;
    final Paint glowPaint = Paint()
      ..color = Colors.black.withAlpha(90)
      ..strokeWidth = metrics.aimGlowWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawLine(center, end, glowPaint);
    canvas.drawLine(center, end, linePaint);
    canvas.drawLine(center, end, corePaint);

    final Offset arrowLeft =
        end + Offset(math.cos(angle - 2.7), math.sin(angle - 2.7)) * 14;
    final Offset arrowRight =
        end + Offset(math.cos(angle + 2.7), math.sin(angle + 2.7)) * 14;
    canvas.drawLine(end, arrowLeft, linePaint);
    canvas.drawLine(end, arrowRight, linePaint);
    canvas.drawLine(end, arrowLeft, corePaint);
    canvas.drawLine(end, arrowRight, corePaint);

    if (showHandle) {
      final Paint handleHintPaint = Paint()
        ..color = Colors.white.withAlpha(145)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      final Paint handleHintGlowPaint = Paint()
        ..color = Colors.black.withAlpha(76)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        end,
        metrics.rotationHandleHintRadius,
        handleHintGlowPaint,
      );
      canvas.drawCircle(end, metrics.rotationHandleHintRadius, handleHintPaint);
    }
  }

  @override
  bool shouldRepaint(_PlayerAimIndicatorPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.metrics != metrics ||
        oldDelegate.color != color ||
        oldDelegate.showHandle != showHandle;
  }
}
