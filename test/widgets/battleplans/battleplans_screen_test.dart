import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/presentation/battleplans_screen.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

import '../../helpers/fake_battleplans_repositories.dart';
import '../../helpers/test_app.dart';

void main() {
  group('BattlePlansScreen', () {
    testWidgets('renders local battleplan entries from the database', (
      WidgetTester tester,
    ) async {
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
        buildTestApp(
          const BattlePlansScreen(),
          overrides: [
            battlePlanRepositoryProvider.overrideWith(
              (Ref ref) => FakeBattlePlanRepository(<BattlePlan>[battlePlan]),
            ),
            mapAssetRepositoryProvider.overrideWith(
              (Ref ref) => const FakeMapAssetRepository(<MapAsset>[mapAsset]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('BattlePlans'), findsOneWidget);
      expect(find.text('Alpha Push'), findsOneWidget);
      expect(find.text('Carte: Orbital Station • Etage 1'), findsOneWidget);
      expect(find.text('Ouvrir l\'editeur'), findsOneWidget);
      expect(find.text('Nouveau'), findsOneWidget);
    });
  });
}
