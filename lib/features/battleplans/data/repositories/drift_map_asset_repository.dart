import 'package:drift/drift.dart';
import 'package:mgw_eva/core/assets/map_asset_path_resolver.dart';
import 'package:mgw_eva/data/local/db/app_database.dart' as db;
import 'package:mgw_eva/features/battleplans/data/mappers/map_asset_mapper.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/domain/repositories/map_asset_repository.dart';

class DriftMapAssetRepository implements MapAssetRepository {
  DriftMapAssetRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<MapAsset>> watchMapAssets() {
    final query = _database.select(_database.mapAssets)
      ..orderBy(<OrderClauseGenerator<db.$MapAssetsTable>>[
        (db.$MapAssetsTable table) => OrderingTerm(
          expression: table.logicalMapName,
          mode: OrderingMode.asc,
        ),
        (db.$MapAssetsTable table) =>
            OrderingTerm(expression: table.floorNumber, mode: OrderingMode.asc),
      ]);

    return query.watch().map(
      (List<db.MapAsset> rows) => _toSupportedDomainMaps(rows),
    );
  }

  @override
  Future<List<MapAsset>> getMapAssets() {
    final query = _database.select(_database.mapAssets)
      ..orderBy(<OrderClauseGenerator<db.$MapAssetsTable>>[
        (db.$MapAssetsTable table) => OrderingTerm(
          expression: table.logicalMapName,
          mode: OrderingMode.asc,
        ),
        (db.$MapAssetsTable table) =>
            OrderingTerm(expression: table.floorNumber, mode: OrderingMode.asc),
      ]);

    return query.get().then(
      (List<db.MapAsset> rows) => _toSupportedDomainMaps(rows),
    );
  }

  @override
  Future<MapAsset?> getMapAssetById(int id) {
    return (_database.select(_database.mapAssets)
          ..where((db.$MapAssetsTable table) => table.id.equals(id)))
        .getSingleOrNull()
        .then((db.MapAsset? row) => _toSupportedDomainMap(row));
  }

  @override
  Future<MapAsset?> getMapAssetByImagePath(String imagePath) {
    final String? canonicalPath = MapAssetPathResolver.tryResolveCanonicalPath(
      imagePath,
    );
    if (canonicalPath == null) {
      return Future<MapAsset?>.value(null);
    }

    return (_database.select(_database.mapAssets).get()).then((
      List<db.MapAsset> rows,
    ) {
      for (final db.MapAsset row in rows) {
        final String? rowCanonicalPath =
            MapAssetPathResolver.tryResolveCanonicalPath(row.imagePath);
        if (rowCanonicalPath == null) {
          continue;
        }

        if (rowCanonicalPath == canonicalPath) {
          return _toSupportedDomainMap(row);
        }
      }

      return null;
    });
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
    final String storedImagePath =
        MapAssetPathResolver.tryResolveCanonicalPath(imagePath) ??
        MapAssetPathResolver.sanitize(imagePath);
    return _database
        .into(_database.mapAssets)
        .insert(
          db.MapAssetsCompanion.insert(
            name: name.trim(),
            logicalMapName: Value<String>(logicalMapName.trim()),
            floorNumber: Value<int>(floorNumber),
            imagePath: storedImagePath,
            width: width,
            height: height,
          ),
        );
  }

  @override
  Future<bool> updateMapAsset(MapAsset mapAsset) {
    final String storedImagePath =
        MapAssetPathResolver.tryResolveCanonicalPath(mapAsset.imagePath) ??
        MapAssetPathResolver.sanitize(mapAsset.imagePath);
    return (_database.update(_database.mapAssets)
          ..where((db.$MapAssetsTable table) => table.id.equals(mapAsset.id)))
        .write(
          db.MapAssetsCompanion(
            name: Value<String>(mapAsset.name.trim()),
            logicalMapName: Value<String>(mapAsset.logicalMapName.trim()),
            floorNumber: Value<int>(mapAsset.floorNumber),
            imagePath: Value<String>(storedImagePath),
            width: Value<int>(mapAsset.width),
            height: Value<int>(mapAsset.height),
          ),
        )
        .then((int rows) => rows > 0);
  }

  @override
  Future<bool> deleteMapAsset(int id) {
    return (_database.delete(_database.mapAssets)
          ..where((db.$MapAssetsTable table) => table.id.equals(id)))
        .go()
        .then((int rows) => rows > 0);
  }

  List<MapAsset> _toSupportedDomainMaps(List<db.MapAsset> rows) {
    return rows
        .map((db.MapAsset row) => _toSupportedDomainMap(row))
        .whereType<MapAsset>()
        .toList(growable: false);
  }

  MapAsset? _toSupportedDomainMap(db.MapAsset? row) {
    if (row == null) {
      return null;
    }

    final String? canonicalPath = MapAssetPathResolver.tryResolveCanonicalPath(
      row.imagePath,
    );
    if (canonicalPath == null) {
      return null;
    }

    return row.toDomain().copyWith(imagePath: canonicalPath);
  }
}
