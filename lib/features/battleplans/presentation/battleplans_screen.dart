import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/core/constants/app_constants.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/battle_plan.dart';
import 'package:mgw_eva/features/battleplans/domain/entities/map_asset.dart';
import 'package:mgw_eva/features/battleplans/logic/battleplans_controller.dart';
import 'package:mgw_eva/features/battleplans/logic/battleplans_list_providers.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battle_plan_card.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battleplans_empty_state.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/battleplans_error_state.dart';
import 'package:mgw_eva/features/battleplans/presentation/widgets/create_battle_plan_dialog.dart';

class BattlePlansScreen extends ConsumerWidget {
  const BattlePlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<BattlePlan>> battlePlans = ref.watch(
      battlePlansProvider,
    );
    final AsyncValue<List<MapAsset>> mapAssets = ref.watch(
      battlePlanMapAssetsProvider,
    );
    final BattlePlansController controller = ref.read(
      battlePlansControllerProvider,
    );

    return AppPageBackground(
      child: SafeArea(
        child: ListView(
          padding: UiTokens.pagePadding,
          children: <Widget>[
            AppFadeSlideIn(
              child: AppPageHeader(
                title: AppConstants.battlePlansLabel,
                subtitle:
                    'Accede rapidement a tes plans tactiques locaux, cree de '
                    'nouvelles entrees et ouvre l\'editeur sur la vraie base '
                    'locale.',
                trailing: SizedBox(
                  width: 152,
                  child: FilledButton.icon(
                    onPressed: () => _handleCreateBattlePlan(
                      context: context,
                      controller: controller,
                      mapAssets: mapAssets,
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Nouveau'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: UiTokens.sectionGap),
            battlePlans.when(
              data: (List<BattlePlan> plans) {
                return mapAssets.when(
                  data: (List<MapAsset> maps) {
                    if (plans.isEmpty) {
                      return AppFadeSlideIn(
                        delay: const Duration(milliseconds: 80),
                        child: BattlePlansEmptyState(
                          hasMaps: maps.isNotEmpty,
                          onCreatePressed: maps.isEmpty
                              ? null
                              : () => _handleCreateBattlePlan(
                                  context: context,
                                  controller: controller,
                                  mapAssets: AsyncValue.data(maps),
                                ),
                        ),
                      );
                    }

                    final Map<int, MapAsset> mapsById = <int, MapAsset>{
                      for (final MapAsset map in maps) map.id: map,
                    };

                    return Column(
                      children: plans.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final BattlePlan plan = entry.value;
                        final MapAsset? mapAsset = mapsById[plan.mapId];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == plans.length - 1
                                ? 0
                                : UiTokens.cardGap,
                          ),
                          child: AppFadeSlideIn(
                            delay: Duration(
                              milliseconds: 70 + (index.clamp(0, 4) * 40),
                            ),
                            child: BattlePlanCard(
                              battlePlan: plan,
                              mapAsset: mapAsset,
                              onOpen: mapAsset == null
                                  ? null
                                  : () => _openBattlePlan(
                                      context: context,
                                      request: controller.buildOpenRequest(
                                        battlePlan: plan,
                                        mapAsset: mapAsset,
                                      ),
                                    ),
                              onDelete: () => _handleDeleteBattlePlan(
                                context: context,
                                controller: controller,
                                battlePlan: plan,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object error, StackTrace stackTrace) {
                    return BattlePlansErrorState(error: error);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) {
                return BattlePlansErrorState(error: error);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreateBattlePlan({
    required BuildContext context,
    required BattlePlansController controller,
    required AsyncValue<List<MapAsset>> mapAssets,
  }) async {
    final List<MapAsset>? maps = switch (mapAssets) {
      AsyncData<List<MapAsset>>(:final value) => value,
      _ => null,
    };
    if (maps == null || maps.isEmpty) {
      _showMessage(
        context,
        'Aucune carte locale disponible pour creer un battleplan.',
        isError: true,
      );
      return;
    }

    final CreateBattlePlanInput? input =
        await showDialog<CreateBattlePlanInput>(
          context: context,
          builder: (BuildContext context) {
            return CreateBattlePlanDialog(mapAssets: maps);
          },
        );

    if (input == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    final BattlePlansActionResult result = await controller.createBattlePlan(
      name: input.name,
      mapId: input.mapId,
    );

    if (!context.mounted) {
      return;
    }

    _handleResult(context, result);
  }

  Future<void> _handleDeleteBattlePlan({
    required BuildContext context,
    required BattlePlansController controller,
    required BattlePlan battlePlan,
  }) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Supprimer ce battleplan'),
              content: Text(
                'Le battleplan "${battlePlan.name}" et ses elements seront supprimes.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    final BattlePlansActionResult result = await controller.deleteBattlePlan(
      battlePlan,
    );

    if (!context.mounted) {
      return;
    }

    _handleResult(context, result);
  }

  void _openBattlePlan({
    required BuildContext context,
    required BattlePlanOpenRequest request,
  }) {
    debugPrint(
      '[Navigation] push battlePlanEditor id=${request.battlePlanId} '
      'name="${request.battlePlanName}" map="${request.mapImagePath}"',
    );
    context.pushNamed(
      RouteNames.battlePlanEditor,
      queryParameters: <String, String>{
        'id': request.battlePlanId.toString(),
        'name': request.battlePlanName,
        'map': request.mapImagePath,
      },
    );
  }

  void _handleResult(BuildContext context, BattlePlansActionResult result) {
    final BattlePlanOpenRequest? openRequest = result.openRequest;
    if (openRequest != null) {
      _openBattlePlan(context: context, request: openRequest);
      return;
    }

    final String? message = result.message;
    if (message == null) {
      return;
    }

    _showMessage(context, message, isError: result.isError);
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
