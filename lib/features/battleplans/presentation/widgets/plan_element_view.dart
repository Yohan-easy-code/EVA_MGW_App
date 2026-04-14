import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/plan_element.dart';
import 'package:mgw_eva/features/battleplans/presentation/models/player_render_metrics.dart';
import 'package:mgw_eva/features/battleplans/presentation/painters/arrow_element_painter.dart';
import 'package:mgw_eva/features/battleplans/presentation/painters/zone_circle_element_painter.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';
import 'package:mgw_eva/features/battleplans/state/plan_element_type.dart';

class PlanElementView extends StatelessWidget {
  const PlanElementView({
    required this.element,
    required this.isSelected,
    required this.isDragging,
    this.opacity = 1,
    super.key,
  });

  final PlanElement element;
  final bool isSelected;
  final bool isDragging;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final PlanElementType? type = PlanElementType.fromStorageKey(element.type);
    if (type == null || opacity <= 0.001) {
      return const SizedBox.shrink();
    }

    final PlayerRenderMetrics? playerMetrics = type == PlanElementType.player
        ? PlayerRenderMetrics.fromSize(Size(element.width, element.height))
        : null;

    final Widget child = switch (type) {
      PlanElementType.player => _PlayerElement(
        element: element,
        isSelected: isSelected,
        metrics: playerMetrics!,
      ),
      PlanElementType.marker => _IconElement(
        element: element,
        icon: BattlePlanEditorIcons.marker,
        iconScale: 1,
      ),
      PlanElementType.shield => _IconElement(
        element: element,
        icon: BattlePlanEditorIcons.shield,
        iconScale: 0.68,
      ),
      PlanElementType.plasma => _IconElement(
        element: element,
        icon: BattlePlanEditorIcons.plasma,
        iconScale: 0.62,
      ),
      PlanElementType.sticky => _RotatedIconElement(
        element: element,
        icon: BattlePlanEditorIcons.sticky,
        iconScale: 0.56,
        rotation: math.pi / 4,
      ),
      PlanElementType.sonnar => _SonnarElement(element: element),
      PlanElementType.text => _TextElement(element: element),
      PlanElementType.arrow => _ArrowElement(element: element),
      PlanElementType.zoneCircle => _ZoneCircleElement(element: element),
    };

    return Opacity(
      opacity: opacity.clamp(0, 1),
      child: AnimatedScale(
        scale: isDragging ? 1.04 : 1,
        duration: const Duration(milliseconds: 110),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(type.selectionRadius),
            border: isSelected && type != PlanElementType.player
                ? Border.all(color: Colors.white.withAlpha(232), width: 2)
                : null,
            boxShadow: isSelected && type != PlanElementType.player
                ? <BoxShadow>[
                    BoxShadow(
                      color: Color(element.color).withAlpha(84),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: math.max(element.width, 1),
            height: math.max(element.height, 1),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ArrowElement extends StatelessWidget {
  const _ArrowElement({required this.element});

  final PlanElement element;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: element.rotation,
      child: CustomPaint(
        painter: ArrowElementPainter(color: Color(element.color)),
      ),
    );
  }
}

class _ZoneCircleElement extends StatelessWidget {
  const _ZoneCircleElement({required this.element});

  final PlanElement element;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(element.color);

    return CustomPaint(
      painter: ZoneCircleElementPainter(color: color),
      child: Center(
        child: _MapGlyph(
          icon: BattlePlanEditorIcons.zone,
          size: math.max(element.width * 0.18, 16),
          color: color.withAlpha(245),
          shadowBlur: 0,
        ),
      ),
    );
  }
}

class _PlayerElement extends StatelessWidget {
  const _PlayerElement({
    required this.element,
    required this.isSelected,
    required this.metrics,
  });

  final PlanElement element;
  final bool isSelected;
  final PlayerRenderMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(element.color);

    return Center(
      child: SizedBox.square(
        dimension: metrics.bodyDiameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(
                    color: Colors.white.withAlpha(238),
                    width: metrics.selectionOutlineWidth,
                  )
                : null,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: color.withAlpha(74),
                      blurRadius: metrics.selectionHaloBlur,
                      spreadRadius: metrics.selectionHaloSpread,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: _MapGlyph(
              icon: BattlePlanEditorIcons.player,
              size: metrics.iconSize,
              color: color,
              shadowBlur: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconElement extends StatelessWidget {
  const _IconElement({
    required this.element,
    required this.icon,
    required this.iconScale,
  });

  final PlanElement element;
  final IconData icon;
  final double iconScale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _MapGlyph(
        icon: icon,
        size: math.max(math.min(element.width, element.height) * iconScale, 18),
        color: Color(element.color).withAlpha(250),
      ),
    );
  }
}

class _RotatedIconElement extends StatelessWidget {
  const _RotatedIconElement({
    required this.element,
    required this.icon,
    required this.iconScale,
    required this.rotation,
  });

  final PlanElement element;
  final IconData icon;
  final double iconScale;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: rotation,
        child: _MapGlyph(
          icon: icon,
          size: math.max(
            math.min(element.width, element.height) * iconScale,
            18,
          ),
          color: Color(element.color).withAlpha(252),
        ),
      ),
    );
  }
}

class _SonnarElement extends StatelessWidget {
  const _SonnarElement({required this.element});

  final PlanElement element;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(element.color);

    return CustomPaint(
      painter: _SonnarElementPainter(color: color),
      child: Center(
        child: _MapGlyph(
          icon: BattlePlanEditorIcons.sonnar,
          size: math.max(element.width * 0.36, 18),
          color: color.withAlpha(252),
          shadowBlur: 0,
        ),
      ),
    );
  }
}

class _MapGlyph extends StatelessWidget {
  const _MapGlyph({
    required this.icon,
    required this.size,
    required this.color,
    this.shadowBlur = 4,
  });

  final IconData icon;
  final double size;
  final Color color;
  final double shadowBlur;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size + 6,
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: color,
          shadows: shadowBlur <= 0
              ? null
              : <Shadow>[
                  Shadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: shadowBlur,
                  ),
                ],
        ),
      ),
    );
  }
}

class _TextElement extends StatelessWidget {
  const _TextElement({required this.element});

  final PlanElement element;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(element.color);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(188),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(235), width: 1.6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Center(
          child: Text(
            element.label ?? 'Text',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SonnarElementPainter extends CustomPainter {
  const _SonnarElementPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2;

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final Paint sweepPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withAlpha(30);

    for (final double factor in <double>[0.38, 0.64, 0.9]) {
      ringPaint.color = color.withAlpha((188 - (factor * 44)).round());
      canvas.drawCircle(center, radius * factor, ringPaint);
    }

    final Rect sweepRect = Rect.fromCircle(
      center: center,
      radius: radius * 0.92,
    );
    canvas.drawArc(sweepRect, -0.9, 1.3, true, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _SonnarElementPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
