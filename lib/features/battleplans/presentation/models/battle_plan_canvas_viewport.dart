import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class BattlePlanCanvasViewport {
  const BattlePlanCanvasViewport({
    required this.scale,
    required this.mapRect,
    required this.renderedMapSize,
  });

  factory BattlePlanCanvasViewport.fromConstraints({
    required BoxConstraints constraints,
    required double mapWidth,
    required double mapHeight,
  }) {
    final Size available = Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : mapWidth,
      constraints.maxHeight.isFinite ? constraints.maxHeight : mapHeight,
    );

    final double safeWidth = available.width <= 0 ? mapWidth : available.width;
    final double safeHeight = available.height <= 0
        ? mapHeight
        : available.height;
    final double scale = math.min(safeWidth / mapWidth, safeHeight / mapHeight);
    final Size renderedMapSize = Size(mapWidth * scale, mapHeight * scale);
    final Rect mapRect = Alignment.center.inscribe(
      renderedMapSize,
      Offset.zero & available,
    );

    return BattlePlanCanvasViewport(
      scale: scale,
      mapRect: mapRect,
      renderedMapSize: renderedMapSize,
    );
  }

  final double scale;
  final Rect mapRect;
  final Size renderedMapSize;

  Offset toViewportOffset(Offset logicalOffset) {
    return mapRect.topLeft +
        Offset(logicalOffset.dx * scale, logicalOffset.dy * scale);
  }

  Offset toMapLocalOffset(Offset logicalOffset) {
    return Offset(logicalOffset.dx * scale, logicalOffset.dy * scale);
  }

  Size toViewportSize(Size logicalSize) {
    return Size(
      math.max(logicalSize.width * scale, 1),
      math.max(logicalSize.height * scale, 1),
    );
  }

  Offset toLogicalVector(Offset viewportDelta) {
    if (scale <= 0) {
      return viewportDelta;
    }

    return Offset(viewportDelta.dx / scale, viewportDelta.dy / scale);
  }

  Offset toLogicalPoint(Offset viewportPoint) {
    if (scale <= 0) {
      return viewportPoint;
    }

    final Offset pointInMap = viewportPoint - mapRect.topLeft;

    return Offset(pointInMap.dx / scale, pointInMap.dy / scale);
  }
}
