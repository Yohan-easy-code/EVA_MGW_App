import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/core/constants/app_constants.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/data/local/storage/json_transfer_models.dart';
import 'package:mgw_eva/features/settings/logic/settings_controller.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/about_section.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/import_json_path_dialog.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/import_strategy_dialog.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/reset_database_dialog.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:mgw_eva/shared/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final bool isBusy = ref.watch(settingsControllerProvider).isBusy;
    final SettingsController controller = ref.read(
      settingsControllerProvider.notifier,
    );

    return AppPageBackground(
      child: SafeArea(
        child: ListView(
          padding: UiTokens.pagePadding,
          children: <Widget>[
            const AppFadeSlideIn(
              child: AppPageHeader(
                title: AppConstants.settingsLabel,
                subtitle:
                    'Maintenance locale, export/import JSON et informations '
                    'produit sans dependance distante.',
              ),
            ),
            const SizedBox(height: UiTokens.sectionGap),
            AppFadeSlideIn(
              delay: const Duration(milliseconds: 50),
              child: SettingsSectionCard(
                title: 'Apparence',
                subtitle:
                    'Preference locale de theme pour garder une experience '
                    'coherente a chaque relance.',
                icon: Icons.dark_mode_outlined,
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Theme sombre'),
                  subtitle: const Text(
                    'Desactive pour basculer en theme clair local.',
                  ),
                  value: themeMode == ThemeMode.dark,
                  onChanged: isBusy ? null : controller.setDarkMode,
                ),
              ),
            ),
            const SizedBox(height: UiTokens.cardGap),
            AppFadeSlideIn(
              delay: const Duration(milliseconds: 70),
              child: SettingsSectionCard(
                title: 'Transfert JSON',
                subtitle:
                    'Exporte l\'etat local complet et importe un fichier JSON '
                    'avec verification des conflits avant ecriture.',
                icon: Icons.swap_horiz_rounded,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isBusy
                            ? null
                            : () => _exportJson(context, controller),
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Exporter en JSON'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: isBusy
                            ? null
                            : () => _importJson(context, controller),
                        icon: const Icon(Icons.drive_folder_upload_rounded),
                        label: const Text('Importer depuis un chemin'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiTokens.cardGap),
            AppFadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: SettingsSectionCard(
                title: 'Base Locale',
                subtitle:
                    'Purge les battleplans de developpement ou reinitialise '
                    'entierement la base SQLite avant reseed catalogue.',
                icon: Icons.storage_rounded,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: isBusy
                            ? null
                            : () =>
                                  _confirmPurgeBattlePlans(context, controller),
                        style: FilledButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                        ),
                        icon: const Icon(Icons.delete_sweep_rounded),
                        label: const Text('Purger les battleplans'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: isBusy
                            ? null
                            : () => _confirmResetDatabase(context, controller),
                        style: FilledButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Reset DB'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiTokens.cardGap),
            const AppFadeSlideIn(
              delay: Duration(milliseconds: 170),
              child: AboutSection(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportJson(
    BuildContext context,
    SettingsController controller,
  ) async {
    final SettingsActionResult result;
    try {
      result = await controller.exportJson();
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Echec export JSON: $error', isError: true);
      return;
    }

    if (!context.mounted) {
      return;
    }

    _showMessage(context, result.message, isError: result.isError);
  }

  Future<void> _importJson(
    BuildContext context,
    SettingsController controller,
  ) async {
    final String? importPath = await _promptImportPath(context, controller);
    if (importPath == null) {
      return;
    }

    try {
      final JsonImportConflictSummary conflicts = await controller
          .inspectImportConflicts(importPath);

      if (!context.mounted) {
        return;
      }

      final JsonImportConflictStrategy? strategy = await _promptImportStrategy(
        context,
        conflicts,
      );
      if (!context.mounted) {
        return;
      }

      if (strategy == null) {
        _showMessage(context, 'Import annule.');
        return;
      }

      final SettingsActionResult result = await controller.importJson(
        path: importPath,
        strategy: strategy,
      );
      if (!context.mounted) {
        return;
      }

      _showMessage(context, result.message, isError: result.isError);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Echec import JSON: $error', isError: true);
    }
  }

  Future<String?> _promptImportPath(
    BuildContext context,
    SettingsController controller,
  ) async {
    final String? suggestedPath = await controller.getSuggestedImportPath();

    if (!context.mounted) {
      return null;
    }

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return ImportJsonPathDialog(initialPath: suggestedPath);
      },
    );

    if (!context.mounted) {
      return null;
    }

    if (result == null || result.trim().isEmpty) {
      _showMessage(context, 'Import annule.');
      return null;
    }

    return result.trim();
  }

  Future<JsonImportConflictStrategy?> _promptImportStrategy(
    BuildContext context,
    JsonImportConflictSummary conflicts,
  ) async {
    return showDialog<JsonImportConflictStrategy>(
      context: context,
      builder: (BuildContext context) {
        return ImportStrategyDialog(conflicts: conflicts);
      },
    );
  }

  Future<void> _confirmPurgeBattlePlans(
    BuildContext context,
    SettingsController controller,
  ) async {
    final bool shouldPurge =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const ResetDatabaseDialog(
              title: 'Purger les battleplans',
              message:
                  'Cette action supprime uniquement les battleplans locaux, '
                  'leurs elements et leurs etapes. Les cartes et armes seedees '
                  'sont conservees.',
              confirmLabel: 'Purger',
            );
          },
        ) ??
        false;

    if (!shouldPurge) {
      return;
    }

    try {
      final SettingsActionResult result = await controller.purgeBattlePlans();
      if (!context.mounted) {
        return;
      }

      _showMessage(context, result.message, isError: result.isError);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Echec purge battleplans: $error', isError: true);
    }
  }

  Future<void> _confirmResetDatabase(
    BuildContext context,
    SettingsController controller,
  ) async {
    final bool shouldReset =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const ResetDatabaseDialog(
              title: 'Reset DB',
              message:
                  'Cette action supprime toutes les donnees locales puis '
                  'recharge uniquement les cartes et armes seedees. '
                  'Aucun battleplan ne sera recree automatiquement. Continuer ?',
              confirmLabel: 'Confirmer',
            );
          },
        ) ??
        false;

    if (!shouldReset) {
      return;
    }

    try {
      final SettingsActionResult result = await controller.resetDatabase();
      if (!context.mounted) {
        return;
      }

      _showMessage(context, result.message, isError: result.isError);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Echec reset DB: $error', isError: true);
    }
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
