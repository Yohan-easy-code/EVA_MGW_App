import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_editor_providers.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

import '../../helpers/test_database.dart';

void main() {
  group('battlePlanEditorSessionProvider', () {
    test('does not create a missing battleplan implicitly', () async {
      final database = createTestDatabase();
      addTearDown(database.close);

      await AppSeedService(database).seedIfNeeded();

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWith((Ref ref) => database)],
      );
      addTearDown(container.dispose);

      const args = BattlePlanEditorArgs(
        battlePlanName: 'Plan fantome',
        mapAssetPath: AssetPaths.mapAtlantisFloor1,
      );

      await expectLater(
        container.read(battlePlanEditorSessionProvider(args).future),
        throwsA(isA<StateError>()),
      );

      final battlePlans = await database.select(database.battlePlans).get();
      expect(battlePlans, isEmpty);
    });
  });
}
