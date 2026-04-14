import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/data/local/db/app_database.dart';
import 'package:mgw_eva/data/local/seed/app_seed_service.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

final appSeedServiceProvider = Provider<AppSeedService>((Ref ref) {
  return AppSeedService(ref.watch(appDatabaseProvider));
});

final appStartupProvider = FutureProvider<void>((Ref ref) async {
  final AppDatabase database = ref.watch(appDatabaseProvider);
  await ref.watch(appSeedServiceProvider).seedIfNeeded();

  if (!kDebugMode) {
    return;
  }

  final file = await AppDatabase.resolveDatabaseFile();
  final battlePlans = await database.select(database.battlePlans).get();
  final summary = battlePlans
      .map((plan) => '${plan.id}:${plan.name}')
      .join(', ');

  debugPrint(
    '[Startup] sqlite="${file.path}" battlePlans=${battlePlans.length}'
    '${summary.isEmpty ? '' : ' loaded=[$summary]'}',
  );
});
