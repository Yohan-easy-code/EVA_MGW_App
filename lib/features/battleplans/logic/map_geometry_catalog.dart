import 'dart:ui';

import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';

class MapObstacleRect {
  const MapObstacleRect(this.rect);

  final Rect rect;
}

class MapGeometryDefinition {
  const MapGeometryDefinition({
    required this.width,
    required this.height,
    required this.obstacles,
  });

  final double width;
  final double height;
  final List<MapObstacleRect> obstacles;
}

final class MapGeometryCatalog {
  const MapGeometryCatalog._();

  static MapGeometryDefinition forMap(MapAsset mapAsset) {
    return switch (mapAsset.logicalMapName) {
      'ATLANTIS' => MapGeometryDefinition(
        width: mapAsset.width.toDouble(),
        height: mapAsset.height.toDouble(),
        obstacles: const <MapObstacleRect>[
          MapObstacleRect(Rect.fromLTWH(120, 86, 190, 68)),
          MapObstacleRect(Rect.fromLTWH(386, 138, 92, 218)),
          MapObstacleRect(Rect.fromLTWH(548, 102, 212, 58)),
          MapObstacleRect(Rect.fromLTWH(726, 224, 116, 286)),
          MapObstacleRect(Rect.fromLTWH(968, 102, 92, 216)),
          MapObstacleRect(Rect.fromLTWH(1128, 92, 278, 74)),
          MapObstacleRect(Rect.fromLTWH(220, 516, 228, 64)),
          MapObstacleRect(Rect.fromLTWH(514, 610, 178, 56)),
          MapObstacleRect(Rect.fromLTWH(824, 566, 104, 218)),
          MapObstacleRect(Rect.fromLTWH(1038, 492, 268, 70)),
          MapObstacleRect(Rect.fromLTWH(1302, 636, 132, 110)),
        ],
      ),
      'HELIOS' => MapGeometryDefinition(
        width: mapAsset.width.toDouble(),
        height: mapAsset.height.toDouble(),
        obstacles: const <MapObstacleRect>[
          MapObstacleRect(Rect.fromLTWH(110, 120, 210, 70)),
          MapObstacleRect(Rect.fromLTWH(300, 286, 106, 274)),
          MapObstacleRect(Rect.fromLTWH(522, 110, 118, 220)),
          MapObstacleRect(Rect.fromLTWH(706, 92, 224, 76)),
          MapObstacleRect(Rect.fromLTWH(878, 256, 88, 248)),
          MapObstacleRect(Rect.fromLTWH(1026, 182, 238, 60)),
          MapObstacleRect(Rect.fromLTWH(1268, 92, 150, 202)),
          MapObstacleRect(Rect.fromLTWH(154, 658, 252, 66)),
          MapObstacleRect(Rect.fromLTWH(520, 544, 210, 62)),
          MapObstacleRect(Rect.fromLTWH(756, 670, 170, 64)),
          MapObstacleRect(Rect.fromLTWH(1068, 582, 242, 76)),
        ],
      ),
      'THE CLIFF' => MapGeometryDefinition(
        width: mapAsset.width.toDouble(),
        height: mapAsset.height.toDouble(),
        obstacles: const <MapObstacleRect>[
          MapObstacleRect(Rect.fromLTWH(132, 96, 228, 72)),
          MapObstacleRect(Rect.fromLTWH(426, 96, 96, 250)),
          MapObstacleRect(Rect.fromLTWH(626, 142, 286, 64)),
          MapObstacleRect(Rect.fromLTWH(960, 96, 88, 204)),
          MapObstacleRect(Rect.fromLTWH(1150, 128, 250, 60)),
          MapObstacleRect(Rect.fromLTWH(214, 470, 228, 60)),
          MapObstacleRect(Rect.fromLTWH(528, 384, 106, 244)),
          MapObstacleRect(Rect.fromLTWH(742, 476, 218, 68)),
          MapObstacleRect(Rect.fromLTWH(1058, 410, 98, 260)),
          MapObstacleRect(Rect.fromLTWH(1218, 566, 200, 72)),
        ],
      ),
      _ => MapGeometryDefinition(
        width: mapAsset.width.toDouble(),
        height: mapAsset.height.toDouble(),
        obstacles: const <MapObstacleRect>[],
      ),
    };
  }
}
