import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/app/app.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/shared/providers/app_startup_provider.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

import 'helpers/fake_battleplans_repositories.dart';

void main() {
  testWidgets('renders application shell', (WidgetTester tester) async {
    final DateTime now = DateTime.utc(2026, 4, 9, 10);
    const MapAsset mapAsset = MapAsset(
      id: 1,
      name: 'Orbital Station',
      logicalMapName: 'Orbital Station',
      floorNumber: 1,
      imagePath: AssetPaths.mapAtlantisFloor1,
      width: 1600,
      height: 900,
    );
    final BattlePlan battlePlan = BattlePlan(
      id: 1,
      name: 'Alpha Push',
      mapId: mapAsset.id,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((Ref ref) async {}),
          battlePlanRepositoryProvider.overrideWith(
            (Ref ref) => FakeBattlePlanRepository(<BattlePlan>[battlePlan]),
          ),
          mapAssetRepositoryProvider.overrideWith(
            (Ref ref) => const FakeMapAssetRepository(<MapAsset>[mapAsset]),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('BattlePlans'), findsWidgets);
    expect(find.text('Wiki'), findsWidgets);
    expect(find.text('Parametres'), findsWidgets);
    expect(find.text('Alpha Push'), findsOneWidget);
    expect(find.text('Ouvrir l\'editeur'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 120));
  });
}
