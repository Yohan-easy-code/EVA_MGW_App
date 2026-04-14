import 'package:drift/drift.dart';

class Weapons extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  TextColumn get category => text().withLength(min: 1, max: 80)();

  TextColumn get imagePath =>
      text().named('image_path').withLength(min: 1, max: 255)();

  IntColumn get damage =>
      integer().customConstraint('NOT NULL CHECK ("damage" >= 0)')();

  RealColumn get fireRate => real()
      .named('fire_rate')
      .customConstraint('NOT NULL CHECK ("fire_rate" >= 0)')();

  IntColumn get ammo =>
      integer().customConstraint('NOT NULL CHECK ("ammo" >= 0)')();

  RealColumn get reloadTime => real()
      .named('reload_time')
      .customConstraint('NOT NULL CHECK ("reload_time" >= 0)')();

  RealColumn get range =>
      real().customConstraint('NOT NULL CHECK ("range" >= 0)')();

  TextColumn get description => text().withLength(min: 1, max: 4000)();
}
