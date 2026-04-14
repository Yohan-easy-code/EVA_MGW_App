import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/shared/providers/repositories_provider.dart';

final battlePlansControllerProvider = Provider<BattlePlansController>(
  BattlePlansController.new,
);

class BattlePlansController {
  const BattlePlansController(this._ref);

  final Ref _ref;

  Future<BattlePlansActionResult> createBattlePlan({
    required String name,
    required int mapId,
  }) async {
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const BattlePlansActionResult.error(
        'Le nom du battleplan est requis.',
      );
    }

    final battlePlanRepository = _ref.read(battlePlanRepositoryProvider);
    final mapAssetRepository = _ref.read(mapAssetRepositoryProvider);

    final BattlePlan? existing = await battlePlanRepository
        .getBattlePlanByNameAndMapId(name: trimmedName, mapId: mapId);
    final MapAsset? selectedMap = await mapAssetRepository.getMapAssetById(
      mapId,
    );

    if (selectedMap == null) {
      return const BattlePlansActionResult.error('Carte introuvable.');
    }

    if (existing != null) {
      return BattlePlansActionResult.open(
        _buildOpenRequest(existing, selectedMap),
      );
    }

    final int id = await battlePlanRepository.createBattlePlan(
      name: trimmedName,
      mapId: mapId,
    );
    final BattlePlan? created = await battlePlanRepository.getBattlePlanById(
      id,
    );

    if (created == null) {
      return const BattlePlansActionResult.error(
        'Impossible de charger le battleplan cree.',
      );
    }

    return BattlePlansActionResult.open(
      _buildOpenRequest(created, selectedMap),
    );
  }

  Future<BattlePlansActionResult> deleteBattlePlan(
    BattlePlan battlePlan,
  ) async {
    final bool deleted = await _ref
        .read(battlePlanRepositoryProvider)
        .deleteBattlePlan(battlePlan.id);

    if (!deleted) {
      return const BattlePlansActionResult.error(
        'Suppression du battleplan impossible.',
      );
    }

    return const BattlePlansActionResult.info('Battleplan supprime.');
  }

  BattlePlanOpenRequest buildOpenRequest({
    required BattlePlan battlePlan,
    required MapAsset mapAsset,
  }) {
    return _buildOpenRequest(battlePlan, mapAsset);
  }

  BattlePlanOpenRequest _buildOpenRequest(
    BattlePlan battlePlan,
    MapAsset mapAsset,
  ) {
    return BattlePlanOpenRequest(
      battlePlanId: battlePlan.id,
      battlePlanName: battlePlan.name,
      mapImagePath: mapAsset.imagePath,
    );
  }
}

class BattlePlansActionResult {
  const BattlePlansActionResult._({
    required this.message,
    required this.isError,
    this.openRequest,
  });

  const BattlePlansActionResult.info(String message)
    : this._(message: message, isError: false);

  const BattlePlansActionResult.error(String message)
    : this._(message: message, isError: true);

  const BattlePlansActionResult.open(BattlePlanOpenRequest request)
    : this._(message: null, isError: false, openRequest: request);

  final String? message;
  final bool isError;
  final BattlePlanOpenRequest? openRequest;
}

class BattlePlanOpenRequest {
  const BattlePlanOpenRequest({
    required this.battlePlanId,
    required this.battlePlanName,
    required this.mapImagePath,
  });

  final int battlePlanId;
  final String battlePlanName;
  final String mapImagePath;
}
