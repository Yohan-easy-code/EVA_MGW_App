class JsonTransferFormat {
  static const String appId = 'mgw_eva';
  static const int version = 4;

  const JsonTransferFormat._();
}

enum JsonImportConflictStrategy {
  replaceExisting,
  keepExisting,
  abortOnConflict,
}

class JsonImportConflictSummary {
  const JsonImportConflictSummary({
    required this.mapAssets,
    required this.weapons,
    required this.weaponAdvancedStats,
    required this.weaponDistanceProfiles,
    required this.battlePlans,
    required this.planElements,
  });

  final int mapAssets;
  final int weapons;
  final int weaponAdvancedStats;
  final int weaponDistanceProfiles;
  final int battlePlans;
  final int planElements;

  int get total =>
      mapAssets +
      weapons +
      weaponAdvancedStats +
      weaponDistanceProfiles +
      battlePlans +
      planElements;

  bool get hasConflicts => total > 0;
}

class JsonImportResult {
  const JsonImportResult({
    required this.strategy,
    required this.conflicts,
    required this.importedMapAssets,
    required this.importedWeapons,
    required this.importedWeaponAdvancedStats,
    required this.importedWeaponDistanceProfiles,
    required this.importedBattlePlans,
    required this.importedPlanElements,
  });

  final JsonImportConflictStrategy strategy;
  final JsonImportConflictSummary conflicts;
  final int importedMapAssets;
  final int importedWeapons;
  final int importedWeaponAdvancedStats;
  final int importedWeaponDistanceProfiles;
  final int importedBattlePlans;
  final int importedPlanElements;
}

class JsonImportConflictException implements Exception {
  const JsonImportConflictException(this.summary);

  final JsonImportConflictSummary summary;

  @override
  String toString() {
    return 'Conflits detectes pendant l\'import JSON '
        '(maps: ${summary.mapAssets}, weapons: ${summary.weapons}, '
        'weaponAdvancedStats: ${summary.weaponAdvancedStats}, '
        'weaponDistanceProfiles: ${summary.weaponDistanceProfiles}, '
        'battlePlans: ${summary.battlePlans}, planElements: ${summary.planElements}).';
  }
}
