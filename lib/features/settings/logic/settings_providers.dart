import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/data/local/storage/app_data_transfer_service.dart';
import 'package:mgw_eva/shared/providers/app_startup_provider.dart';
import 'package:mgw_eva/shared/providers/database_provider.dart';

final appDataTransferServiceProvider = Provider<AppDataTransferService>((
  Ref ref,
) {
  return AppDataTransferService(
    ref.watch(appDatabaseProvider),
    ref.watch(appSeedServiceProvider),
  );
});
