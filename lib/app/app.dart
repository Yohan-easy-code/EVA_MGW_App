import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgw_eva/app/theme/app_theme.dart';
import 'package:mgw_eva/core/constants/app_constants.dart';
import 'package:mgw_eva/core/widgets/app_brand_logo.dart';
import 'package:mgw_eva/shared/providers/app_startup_provider.dart';
import 'package:mgw_eva/shared/providers/router_provider.dart';
import 'package:mgw_eva/shared/providers/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final startup = ref.watch(appStartupProvider);

    return startup.when(
      data: (_) => _buildAppShell(router: router, themeMode: themeMode),
      loading: () => _buildAppShell(
        router: router,
        themeMode: themeMode,
        home: const _StartupScreen(),
      ),
      error: (Object error, StackTrace stackTrace) => _buildAppShell(
        router: router,
        themeMode: themeMode,
        home: _StartupErrorScreen(error: error),
      ),
    );
  }

  MaterialApp _buildAppShell({
    required ThemeMode themeMode,
    required RouterConfig<Object> router,
    Widget? home,
  }) {
    if (home != null) {
      return MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        home: home,
      );
    }

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AppBrandLogo(size: 72),
            const SizedBox(height: 16),
            Text(
              'Initialisation locale',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBrandLogo(
                size: 72,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.errorContainer.withAlpha(180),
              ),
              const SizedBox(height: 16),
              Text(
                'Echec de l\'initialisation',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
