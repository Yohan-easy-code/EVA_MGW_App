import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/assets/app_asset_kind.dart';
import 'package:mgw_eva/core/widgets/app_asset_view.dart';

import '../../helpers/test_app.dart';

void main() {
  group('AppAssetView', () {
    testWidgets('renders raster map assets with Image', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const AppAssetView(
            assetPath: 'assets/images/maps/atlantis/floor_1.png',
            assetKind: AppAssetKind.map,
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('renders svg assets with SvgPicture', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const AppAssetView(
            assetPath: 'assets/images/weapons/weapon_helios_rifle.svg',
            assetKind: AppAssetKind.weapon,
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });
}
