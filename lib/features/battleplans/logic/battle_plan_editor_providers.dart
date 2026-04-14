import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_timeline_service.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

@immutable
class BattlePlanEditorArgs {
  const BattlePlanEditorArgs({
    required this.battlePlanName,
    required this.mapAssetPath,
  });

  final String battlePlanName;
  final String mapAssetPath;

  @override
  bool operator ==(Object other) {
    return other is BattlePlanEditorArgs &&
        other.battlePlanName == battlePlanName &&
        other.mapAssetPath == mapAssetPath;
  }

  @override
  int get hashCode => Object.hash(battlePlanName, mapAssetPath);
}

class BattlePlanEditorSession {
  const BattlePlanEditorSession({
    required this.battlePlan,
    required this.mapAsset,
  });

  final BattlePlan battlePlan;
  final MapAsset mapAsset;
}

final battlePlanEditorSessionProvider = FutureProvider.autoDispose
    .family<BattlePlanEditorSession, BattlePlanEditorArgs>((
      Ref ref,
      BattlePlanEditorArgs args,
    ) async {
      final mapAssetRepository = ref.watch(mapAssetRepositoryProvider);
      final battlePlanRepository = ref.watch(battlePlanRepositoryProvider);
      debugPrint(
        '[BattlePlanEditorSession] route name="${args.battlePlanName}" '
        'mapPath="${args.mapAssetPath}"',
      );

      final MapAsset? mapAsset = await mapAssetRepository
          .getMapAssetByImagePath(args.mapAssetPath);
      debugPrint(
        '[BattlePlanEditorSession] mapAsset result='
        '${mapAsset == null ? 'null' : '${mapAsset.id}:${mapAsset.name}'}',
      );

      if (mapAsset == null) {
        throw StateError('Map asset not found for path: ${args.mapAssetPath}');
      }

      final BattlePlan? battlePlan = await battlePlanRepository
          .getBattlePlanByNameAndMapId(
            name: args.battlePlanName,
            mapId: mapAsset.id,
          );
      debugPrint(
        '[BattlePlanEditorSession] battlePlan lookup='
        '${battlePlan == null ? 'null' : '${battlePlan.id}:${battlePlan.name}'}',
      );

      if (battlePlan == null) {
        throw StateError(
          'Battleplan introuvable pour "${args.battlePlanName}" sur '
          '${mapAsset.displayName}.',
        );
      }

      await ref
          .read(battlePlanTimelineServiceProvider)
          .ensureInitialTimeline(battlePlan.id);

      return BattlePlanEditorSession(
        battlePlan: battlePlan,
        mapAsset: mapAsset,
      );
    });

final battlePlanEditorMapAssetsProvider =
    StreamProvider.autoDispose<List<MapAsset>>((Ref ref) {
      return ref.watch(mapAssetRepositoryProvider).watchMapAssets();
    });
