import 'package:drift/native.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';

AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
