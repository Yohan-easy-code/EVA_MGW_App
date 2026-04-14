import 'package:drift/drift.dart';
import 'package:mgw_eva/data/local/db/tables/map_assets_table.dart';

class BattlePlans extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  IntColumn get mapId => integer()
      .named('map_id')
      .references(MapAssets, #id, onDelete: KeyAction.restrict)();

  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}
