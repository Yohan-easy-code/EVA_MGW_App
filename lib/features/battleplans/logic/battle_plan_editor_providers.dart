import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/logic/battle_plan_timeline_service.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

@immutable
class BattlePlanEditorArgs {
  const BattlePlanEditorArgs({
    required this.battlePlanId,
    required this.battlePlanName,
    required this.mapAssetPath,
  });

  final int? battlePlanId;
  final String battlePlanName;
  final String mapAssetPath;

  @override
  bool operator ==(Object other) {
    return other is BattlePlanEditorArgs &&
        other.battlePlanId == battlePlanId &&
        other.battlePlanName == battlePlanName &&
        other.mapAssetPath == mapAssetPath;
  }

  @override
  int get hashCode => Object.hash(battlePlanId, battlePlanName, mapAssetPath);
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
        '[BattlePlanEditorSession] route id=${args.battlePlanId} '
        'name="${args.battlePlanName}" mapPath="${args.mapAssetPath}"',
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

      BattlePlan? battlePlan = args.battlePlanId == null
          ? await battlePlanRepository.getBattlePlanByNameAndMapId(
              name: args.battlePlanName,
              mapId: mapAsset.id,
            )
          : await battlePlanRepository.getBattlePlanById(args.battlePlanId!);
      debugPrint(
        '[BattlePlanEditorSession] battlePlan lookup='
        '${battlePlan == null ? 'null' : '${battlePlan.id}:${battlePlan.name} mapId=${battlePlan.mapId}'}',
      );

      if (battlePlan == null) {
        throw StateError(
          'Battleplan introuvable pour "${args.battlePlanName}" sur '
          '${mapAsset.displayName}.',
        );
      }

      if (battlePlan.mapId != mapAsset.id) {
        final MapAsset? previousMapAsset = await mapAssetRepository
            .getMapAssetById(battlePlan.mapId);
        debugPrint(
          '[BattlePlanEditorSession] update same battlePlanId=${battlePlan.id} '
          'oldMap="${previousMapAsset?.imagePath ?? battlePlan.mapId}" '
          'newMap="${mapAsset.imagePath}"',
        );
        await battlePlanRepository.updateBattlePlan(
          battlePlan.copyWith(mapId: mapAsset.id),
        );
        battlePlan = await battlePlanRepository.getBattlePlanById(
          battlePlan.id,
        );
        debugPrint(
          '[BattlePlanEditorSession] update confirmed battlePlanId=${battlePlan?.id} '
          'mapId=${battlePlan?.mapId}',
        );
      }
      final BattlePlan resolvedBattlePlan = battlePlan!;

      await ref
          .read(battlePlanTimelineServiceProvider)
          .ensureInitialTimeline(resolvedBattlePlan.id);

      return BattlePlanEditorSession(
        battlePlan: resolvedBattlePlan,
        mapAsset: mapAsset,
      );
    });

final battlePlanEditorMapAssetsProvider =
    StreamProvider.autoDispose<List<MapAsset>>((Ref ref) {
      return ref.watch(mapAssetRepositoryProvider).watchMapAssets();
    });

final battlePlanMapAssetPathsProvider = FutureProvider.autoDispose<Set<String>>(
  (Ref ref) async {
    final String manifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> decodedManifest =
        jsonDecode(manifest) as Map<String, dynamic>;

    return decodedManifest.keys.toSet();
  },
);
