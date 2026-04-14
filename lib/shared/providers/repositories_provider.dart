import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_battle_plan_step_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_map_asset_repository.dart';
import 'package:mgw_eva/features/battleplans/data/repositories/drift_plan_element_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_element_state_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_step_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/map_asset_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/plan_element_repository.dart';
import 'package:mgw_eva/features/wiki/data/repositories/drift_weapon_repository.dart';
import 'package:mgw_eva/features/wiki/domain/repositories/weapon_repository.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

final battlePlanRepositoryProvider = Provider<BattlePlanRepository>((Ref ref) {
  return DriftBattlePlanRepository(ref.watch(appDatabaseProvider));
});

final mapAssetRepositoryProvider = Provider<MapAssetRepository>((Ref ref) {
  return DriftMapAssetRepository(ref.watch(appDatabaseProvider));
});

final planElementRepositoryProvider = Provider<PlanElementRepository>((
  Ref ref,
) {
  return DriftPlanElementRepository(ref.watch(appDatabaseProvider));
});

final battlePlanStepRepositoryProvider = Provider<BattlePlanStepRepository>((
  Ref ref,
) {
  return DriftBattlePlanStepRepository(ref.watch(appDatabaseProvider));
});

final battlePlanStepElementStateRepositoryProvider =
    Provider<BattlePlanStepElementStateRepository>((Ref ref) {
      return DriftBattlePlanStepElementStateRepository(
        ref.watch(appDatabaseProvider),
      );
    });

final weaponRepositoryProvider = Provider<WeaponRepository>((Ref ref) {
  return DriftWeaponRepository(ref.watch(appDatabaseProvider));
});
