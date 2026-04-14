import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/battle_plan_repository.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/map_asset_repository.dart';

class FakeBattlePlanRepository implements BattlePlanRepository {
  const FakeBattlePlanRepository(this._battlePlans);

  final List<BattlePlan> _battlePlans;

  @override
  Stream<List<BattlePlan>> watchBattlePlans() {
    return Stream<List<BattlePlan>>.value(_battlePlans);
  }

  @override
  Future<List<BattlePlan>> getBattlePlans() async => _battlePlans;

  @override
  Future<BattlePlan?> getBattlePlanById(int id) async {
    for (final BattlePlan battlePlan in _battlePlans) {
      if (battlePlan.id == id) {
        return battlePlan;
      }
    }

    return null;
  }

  @override
  Future<BattlePlan?> getBattlePlanByNameAndMapId({
    required String name,
    required int mapId,
  }) async {
    for (final BattlePlan battlePlan in _battlePlans) {
      if (battlePlan.name == name && battlePlan.mapId == mapId) {
        return battlePlan;
      }
    }

    return null;
  }

  @override
  Future<int> createBattlePlan({required String name, required int mapId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBattlePlan(BattlePlan battlePlan) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteBattlePlan(int id) {
    throw UnimplementedError();
  }
}

class FakeMapAssetRepository implements MapAssetRepository {
  const FakeMapAssetRepository(this._mapAssets);

  final List<MapAsset> _mapAssets;

  @override
  Stream<List<MapAsset>> watchMapAssets() {
    return Stream<List<MapAsset>>.value(_mapAssets);
  }

  @override
  Future<List<MapAsset>> getMapAssets() async => _mapAssets;

  @override
  Future<MapAsset?> getMapAssetById(int id) async {
    for (final MapAsset mapAsset in _mapAssets) {
      if (mapAsset.id == id) {
        return mapAsset;
      }
    }

    return null;
  }

  @override
  Future<MapAsset?> getMapAssetByImagePath(String imagePath) async {
    for (final MapAsset mapAsset in _mapAssets) {
      if (mapAsset.imagePath == imagePath) {
        return mapAsset;
      }
    }

    return null;
  }

  @override
  Future<int> createMapAsset({
    required String name,
    required String logicalMapName,
    required int floorNumber,
    required String imagePath,
    required int width,
    required int height,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateMapAsset(MapAsset mapAsset) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteMapAsset(int id) {
    throw UnimplementedError();
  }
}
