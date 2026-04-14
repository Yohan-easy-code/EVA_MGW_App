import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/features/battleplans/logic/player_vision_service.dart';

void main() {
  group('PlayerVisionService', () {
    test('keeps full range with no obstacle on aim line', () {
      final PlayerVisionResult result = PlayerVisionService.compute(
        origin: const Offset(100, 100),
        angle: 0,
        range: 300,
        fovDegrees: 60,
      );

      expect((result.aimEnd.dx - 400).abs(), lessThan(0.01));
      expect((result.aimEnd.dy - 100).abs(), lessThan(0.01));
      expect(result.polygon.length, greaterThan(10));
    });

    test('builds a stable sector polygon around the aim line', () {
      final PlayerVisionResult result = PlayerVisionService.compute(
        origin: const Offset(100, 100),
        angle: 0,
        range: 400,
        fovDegrees: 60,
      );

      expect((result.aimEnd.dx - 500).abs(), lessThan(0.01));
      expect((result.aimEnd.dy - 100).abs(), lessThan(0.01));
      expect(result.polygon.first, const Offset(100, 100));
      expect(result.polygon.length, greaterThan(20));
    });

    test('narrows the sector correctly with a smaller fov', () {
      final PlayerVisionResult result = PlayerVisionService.compute(
        origin: const Offset(0, 0),
        angle: 0,
        range: 100,
        fovDegrees: 30,
      );

      expect(result.polygon.length, greaterThan(20));
      expect(result.polygon.last.dy.abs(), lessThan(30));
    });
  });
}
