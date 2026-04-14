import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/data/local/storage/theme_preferences_service.dart';

final themePreferencesServiceProvider = Provider<ThemePreferencesService>((
  Ref ref,
) {
  return const ThemePreferencesService();
});

class ThemeModeController extends Notifier<ThemeMode> {
  bool _didRestore = false;
  static const ThemeMode _safeDefaultThemeMode =
      ThemePreferencesService.defaultThemeMode;

  @override
  ThemeMode build() {
    if (!_didRestore) {
      _didRestore = true;
      Future<void>.microtask(_restoreThemeMode);
    }

    debugPrint(
      '[ThemeModeController] build default=${_safeDefaultThemeMode.name}',
    );
    return _safeDefaultThemeMode;
  }

  Future<void> setDarkMode(bool enabled) async {
    debugPrint(
      '[ThemeModeController] toggle darkMode enabled=$enabled '
      'current=${state.name}',
    );
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final ThemeMode sanitizedMode = ThemePreferencesService.sanitizeMode(mode);
    final ThemeMode previousMode = state;
    debugPrint(
      '[ThemeModeController] setThemeMode old=${previousMode.name} '
      'requested=${mode.name} new=${sanitizedMode.name}',
    );

    if (previousMode == sanitizedMode) {
      return;
    }

    state = sanitizedMode;

    try {
      await ref
          .read(themePreferencesServiceProvider)
          .saveThemeMode(sanitizedMode);
      debugPrint('[ThemeModeController] persisted mode=${sanitizedMode.name}');
    } catch (error) {
      debugPrint('[ThemeModeController] persist failed: $error');
    }
  }

  Future<void> _restoreThemeMode() async {
    final ThemeMode providerMode = ThemePreferencesService.sanitizeMode(
      await ref.read(themePreferencesServiceProvider).loadThemeMode(),
    );
    debugPrint(
      '[ThemeModeController] restored provider value=${providerMode.name}',
    );

    if (!ref.mounted) {
      return;
    }

    state = providerMode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
