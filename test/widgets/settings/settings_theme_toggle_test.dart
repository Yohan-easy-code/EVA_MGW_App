import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgw_eva/app/theme/app_theme.dart';
import 'package:mgw_eva/data/local/storage/theme_preferences_service.dart';
import 'package:mgw_eva/features/settings/presentation/settings_screen.dart';
import 'package:mgw_eva/shared/providers/theme_provider.dart';

void main() {
  testWidgets('theme switch toggles between dark and light safely', (
    WidgetTester tester,
  ) async {
    final fakeThemePreferencesService = _FakeThemePreferencesService(
      initialMode: ThemeMode.dark,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themePreferencesServiceProvider.overrideWithValue(
            fakeThemePreferencesService,
          ),
        ],
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final ThemeMode themeMode = ref.watch(themeModeProvider);

            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const SettingsScreen(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);
    expect(fakeThemePreferencesService.persistedModes.last, ThemeMode.light);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(fakeThemePreferencesService.persistedModes.last, ThemeMode.dark);
    expect(tester.takeException(), isNull);
  });
}

class _FakeThemePreferencesService extends ThemePreferencesService {
  _FakeThemePreferencesService({required ThemeMode initialMode})
    : _storedMode = initialMode;

  ThemeMode _storedMode;
  final List<ThemeMode> persistedModes = <ThemeMode>[];

  @override
  Future<ThemeMode> loadThemeMode() async {
    return _storedMode;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final ThemeMode sanitizedMode = ThemePreferencesService.sanitizeMode(mode);
    _storedMode = sanitizedMode;
    persistedModes.add(sanitizedMode);
  }
}
