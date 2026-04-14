import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ThemePreferencesService {
  const ThemePreferencesService();

  static const String _fileName = 'app_preferences.json';
  static const String _themeModeKey = 'theme_mode';
  static const ThemeMode defaultThemeMode = ThemeMode.dark;

  Future<ThemeMode> loadThemeMode() async {
    try {
      final File file = await _preferencesFile();
      if (!await file.exists()) {
        debugPrint(
          '[ThemePreferences] no preference file, default='
          '${defaultThemeMode.name}',
        );
        return defaultThemeMode;
      }

      final String content = await file.readAsString();
      final Object? decoded = jsonDecode(content);
      if (decoded is! Map<String, Object?>) {
        debugPrint(
          '[ThemePreferences] invalid json root, fallback='
          '${defaultThemeMode.name}',
        );
        return defaultThemeMode;
      }

      final String storedValue = decoded[_themeModeKey] as String? ?? '';
      debugPrint('[ThemePreferences] read raw value="$storedValue"');

      final ThemeMode sanitizedMode = sanitizeStoredValue(storedValue);
      debugPrint('[ThemePreferences] loaded mode=${sanitizedMode.name}');
      return sanitizedMode;
    } catch (error) {
      debugPrint(
        '[ThemePreferences] read failed: $error, '
        'fallback=${defaultThemeMode.name}',
      );
      return defaultThemeMode;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final File file = await _preferencesFile();
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final ThemeMode sanitizedMode = sanitizeMode(mode);
    debugPrint('[ThemePreferences] persist mode=${sanitizedMode.name}');
    await file.writeAsString(
      jsonEncode(<String, Object?>{_themeModeKey: sanitizedMode.name}),
      flush: true,
    );
  }

  Future<File> _preferencesFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, _fileName));
  }

  static ThemeMode sanitizeStoredValue(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => defaultThemeMode,
    };
  }

  static ThemeMode sanitizeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => ThemeMode.dark,
      ThemeMode.light => ThemeMode.light,
      ThemeMode.system => defaultThemeMode,
    };
  }
}
