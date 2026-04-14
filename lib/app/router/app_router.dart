import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/core/widgets/app_tab_scaffold.dart';
import 'package:mgw_eva/features/battleplans/presentation/battle_plan_editor_screen.dart';
import 'package:mgw_eva/features/battleplans/presentation/battleplans_screen.dart';
import 'package:mgw_eva/features/settings/presentation/settings_screen.dart';
import 'package:mgw_eva/features/wiki/presentation/weapon_detail_screen.dart';
import 'package:mgw_eva/features/wiki/presentation/wiki_screen.dart';

GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: RouteNames.battleplansPath,
    errorBuilder: (context, state) {
      final Object? error = state.error;
      debugPrint('[Router] navigation error=${error.runtimeType}: $error');

      return _RouteErrorScreen(
        message: error?.toString() ?? 'Une erreur de navigation est survenue.',
      );
    },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppTabScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.battleplansPath,
                name: RouteNames.battleplans,
                builder: (context, state) => const BattlePlansScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.wikiPath,
                name: RouteNames.wiki,
                builder: (context, state) => const WikiScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: RouteNames.wikiWeaponDetailPath,
                    name: RouteNames.wikiWeaponDetail,
                    builder: (context, state) {
                      final String rawWeaponId =
                          state.pathParameters['weaponId'] ?? '';
                      final int weaponId = int.tryParse(rawWeaponId) ?? 0;
                      debugPrint(
                        '[Router] weaponDetail rawWeaponId="$rawWeaponId" parsed=$weaponId',
                      );

                      return WeaponDetailScreen(weaponId: weaponId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.settingsPath,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.battlePlanEditorPath,
        name: RouteNames.battlePlanEditor,
        builder: (context, state) {
          final int? battlePlanId = int.tryParse(
            state.uri.queryParameters['id'] ?? '',
          );
          final String name =
              state.uri.queryParameters['name'] ?? 'Battle Plan V1';
          final String mapAssetPath = state.uri.queryParameters['map'] ?? '';
          debugPrint(
            '[Router] battlePlanEditor id=$battlePlanId '
            'name="$name" map="$mapAssetPath"',
          );

          return BattlePlanEditorScreen(
            battlePlanId: battlePlanId,
            battlePlanName: name,
            mapAssetPath: mapAssetPath,
          );
        },
      ),
    ],
  );
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Erreur de navigation',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.goNamed(RouteNames.battleplans),
                child: const Text('Retour aux battleplans'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
