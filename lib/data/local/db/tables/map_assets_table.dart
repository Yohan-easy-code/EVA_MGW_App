import 'package:drift/drift.dart';

class MapAssets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  TextColumn get logicalMapName => text()
      .named('logical_map_name')
      .withLength(min: 1, max: 120)
      .withDefault(const Constant(''))();

  IntColumn get floorNumber =>
      integer().named('floor_number').withDefault(const Constant(1))();

  TextColumn get imagePath =>
      text().named('image_path').withLength(min: 1, max: 255)();

  IntColumn get width =>
      integer().customConstraint('NOT NULL CHECK ("width" >= 1)')();

  IntColumn get height =>
      integer().customConstraint('NOT NULL CHECK ("height" >= 1)')();
}
