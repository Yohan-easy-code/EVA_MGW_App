import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/data/local/storage/json_transfer_models.dart';
import 'package:mgw_eva/features/settings/logic/settings_providers.dart';
import 'package:mgw_eva/shared/providers/theme_provider.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsControllerState>(
      SettingsController.new,
    );

class SettingsController extends Notifier<SettingsControllerState> {
  @override
  SettingsControllerState build() {
    return const SettingsControllerState();
  }

  Future<void> setDarkMode(bool enabled) async {
    final currentThemeMode = ref.read(themeModeProvider);
    debugPrint(
      '[SettingsController] theme toggle current=${currentThemeMode.name} '
      'enabled=$enabled',
    );
    await ref.read(themeModeProvider.notifier).setDarkMode(enabled);
  }

  Future<SettingsActionResult> exportJson() async {
    return _runBusy(() async {
      final File file = await ref
          .read(appDataTransferServiceProvider)
          .exportToJsonFile();
      return SettingsActionResult.info('Export JSON cree: ${file.path}');
    });
  }

  Future<String?> getSuggestedImportPath() {
    return ref.read(appDataTransferServiceProvider).getSuggestedImportPath();
  }

  Future<JsonImportConflictSummary> inspectImportConflicts(String path) {
    return ref
        .read(appDataTransferServiceProvider)
        .inspectImportConflictsFromJsonPath(path);
  }

  Future<SettingsActionResult> importJson({
    required String path,
    required JsonImportConflictStrategy strategy,
  }) async {
    return _runBusy(() async {
      final JsonImportResult result = await ref
          .read(appDataTransferServiceProvider)
          .importFromJsonPath(path, strategy: strategy);

      return SettingsActionResult.info(
        'Import JSON termine: ${result.importedMapAssets} cartes, '
        '${result.importedWeapons} armes, '
        '${result.importedBattlePlans} battleplans, '
        '${result.importedPlanElements} elements.',
      );
    });
  }

  Future<SettingsActionResult> resetDatabase() async {
    return _runBusy(() async {
      await ref.read(appDataTransferServiceProvider).resetDatabase();
      return const SettingsActionResult.info('Base locale reinitialisee.');
    });
  }

  Future<SettingsActionResult> purgeBattlePlans() async {
    return _runBusy(() async {
      await ref.read(appDataTransferServiceProvider).purgeBattlePlans();
      return const SettingsActionResult.info(
        'Battleplans locaux supprimes. Les cartes et armes locales sont conservees.',
      );
    });
  }

  Future<T> _runBusy<T>(Future<T> Function() operation) async {
    state = state.copyWith(isBusy: true);
    try {
      return await operation();
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isBusy: false);
      }
    }
  }
}

class SettingsControllerState {
  const SettingsControllerState({this.isBusy = false});

  final bool isBusy;

  SettingsControllerState copyWith({bool? isBusy}) {
    return SettingsControllerState(isBusy: isBusy ?? this.isBusy);
  }
}

class SettingsActionResult {
  const SettingsActionResult._({required this.message, required this.isError});

  const SettingsActionResult.info(String message)
    : this._(message: message, isError: false);

  const SettingsActionResult.error(String message)
    : this._(message: message, isError: true);

  final String message;
  final bool isError;
}
