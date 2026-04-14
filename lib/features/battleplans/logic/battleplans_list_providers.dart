import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

final battlePlansProvider = StreamProvider.autoDispose<List<BattlePlan>>((
  Ref ref,
) {
  return ref.watch(battlePlanRepositoryProvider).watchBattlePlans();
});

final battlePlanMapAssetsProvider = StreamProvider.autoDispose<List<MapAsset>>((
  Ref ref,
) {
  return ref.watch(mapAssetRepositoryProvider).watchMapAssets();
});
