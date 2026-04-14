import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/core/widgets/app_asset_view.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_canvas.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_view_state.dart';

import '../../helpers/test_app.dart';

void main() {
  group('BattlePlanCanvas', () {
    const MapAsset mapAsset = MapAsset(
      id: 1,
      name: 'ATLANTIS',
      logicalMapName: 'ATLANTIS',
      floorNumber: 1,
      imagePath: AssetPaths.mapAtlantisFloor1,
      width: 1600,
      height: 900,
    );

    Widget buildCanvas({required Size size}) {
      return buildTestApp(
        Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: BattlePlanCanvas(
              mapAsset: mapAsset,
              renderElements: const [],
              viewState: const BattlePlanEditorViewState(),
              isReadOnly: false,
              onBackgroundTap: () {},
              onSelectElement: (_) {},
              onStartDragging: (_) {},
              onUpdateDragging: (_, _) {},
              onCommitDragging: (_) {},
              onCancelDragging: (_) {},
              onStartResizing: (_) {},
              onUpdateResizing: (_, _) {},
              onCommitResizing: (_) {},
              onCancelResizing: (_) {},
              onStartRotating: (_) {},
              onUpdateRotating: (_, _) {},
              onCommitRotating: (_) {},
              onCancelRotating: (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('keeps the map surface visible with zero element', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCanvas(size: const Size(480, 320)));
      await tester.pump();

      expect(find.byType(AppAssetView), findsOneWidget);
      expect(
        tester.getSize(find.byType(BattlePlanCanvas)),
        const Size(480, 320),
      );
      expect(tester.getSize(find.byType(AppAssetView)).height, greaterThan(0));
      expect(tester.takeException(), isNull);
    });
  });
}
