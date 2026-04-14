import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});
