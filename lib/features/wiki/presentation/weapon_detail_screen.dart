import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/logic/weapon_detail_providers.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_detail_stats_panel.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_image_panel.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_related_weapons_section.dart';

class WeaponDetailScreen extends ConsumerWidget {
  const WeaponDetailScreen({required this.weaponId, super.key});

  final int weaponId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (weaponId <= 0) {
      return const Scaffold(
        appBar: _WeaponDetailAppBar(),
        body: _WeaponDetailMessageState(
          icon: Icons.error_outline_rounded,
          title: 'Route invalide',
          message: 'L\'identifiant d\'arme fourni par la route est invalide.',
        ),
      );
    }

    final AsyncValue<Weapon?> weaponAsync = ref.watch(
      weaponDetailProvider(weaponId),
    );
    final AsyncValue<List<Weapon>> relatedWeaponsAsync = ref.watch(
      relatedWeaponsProvider(weaponId),
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const _WeaponDetailAppBar(),
      body: weaponAsync.when(
        data: (Weapon? weapon) {
          if (weapon == null) {
            return const _WeaponDetailMessageState(
              icon: Icons.auto_stories_outlined,
              title: 'Arme introuvable',
              message:
                  'Aucune arme ne correspond a cet identifiant dans la base locale.',
            );
          }

          return AppPageBackground(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: <Widget>[
                  AppFadeSlideIn(
                    child: _WeaponDetailHeroSection(weapon: weapon),
                  ),
                  const SizedBox(height: UiTokens.sectionGap),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 90),
                    child: _WeaponDetailMetricsSection(weapon: weapon),
                  ),
                  if (weapon.headDamage != null ||
                      weapon.distanceProfiles.isNotEmpty) ...<Widget>[
                    const SizedBox(height: UiTokens.sectionGap),
                    AppFadeSlideIn(
                      delay: const Duration(milliseconds: 120),
                      child: _WeaponAdvancedStatsSection(weapon: weapon),
                    ),
                  ],
                  const SizedBox(height: UiTokens.sectionGap),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    child: relatedWeaponsAsync.when(
                      data: (List<Weapon> weapons) {
                        return WeaponRelatedWeaponsSection(
                          weapons: weapons,
                          currentWeaponId: weapon.id,
                        );
                      },
                      loading: () => const AppSectionCard(
                        child: _InlineSectionState(
                          icon: Icons.hourglass_top_rounded,
                          title: 'Chargement des armes',
                          message: 'Recuperation de la liste locale...',
                          showLoader: true,
                        ),
                      ),
                      error: (Object error, StackTrace stackTrace) {
                        return AppSectionCard(
                          child: _InlineSectionState(
                            icon: Icons.error_outline_rounded,
                            title: 'Erreur de chargement',
                            message: error.toString(),
                            iconColor: colorScheme.error,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const _WeaponDetailMessageState(
          icon: Icons.hourglass_top_rounded,
          title: 'Chargement',
          message: 'Chargement des details de l\'arme...',
          showLoader: true,
        ),
        error: (Object error, StackTrace stackTrace) {
          return _WeaponDetailMessageState(
            icon: Icons.error_outline_rounded,
            title: 'Erreur de chargement',
            message: error.toString(),
            messageColor: colorScheme.error,
          );
        },
      ),
    );
  }
}

class _WeaponDetailHeroSection extends StatelessWidget {
  const _WeaponDetailHeroSection({required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useTwoColumns = constraints.maxWidth >= 760;

        if (useTwoColumns) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 5, child: WeaponDetailStatsPanel(weapon: weapon)),
              const SizedBox(width: 18),
              Expanded(
                flex: 6,
                child: Hero(
                  tag: 'weapon-image-${weapon.id}',
                  child: WeaponImagePanel(
                    imagePath: weapon.imagePath,
                    height: 430,
                    placeholderLabel: weapon.name,
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'weapon-image-${weapon.id}',
              child: WeaponImagePanel(
                imagePath: weapon.imagePath,
                height: 260,
                placeholderLabel: weapon.name,
              ),
            ),
            const SizedBox(height: 18),
            WeaponDetailStatsPanel(weapon: weapon),
          ],
        );
      },
    );
  }
}

class _WeaponDetailMetricsSection extends StatelessWidget {
  const _WeaponDetailMetricsSection({required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lecture tactique',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Resume rapide des indicateurs utiles pour comparer les armes '
            'sans quitter la fiche.',
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              _MetricPanel(
                title: 'Impact',
                value: _formatStatValue(weapon.averageDamage ?? weapon.damage),
                description: 'Degats par tir',
                accentColor: const Color(0xFFD84F68),
              ),
              _MetricPanel(
                title: 'Cadence',
                value: weapon.fireRate.toStringAsFixed(1),
                description: 'Rafales / seconde',
                accentColor: const Color(0xFFFFB84D),
              ),
              _MetricPanel(
                title: 'Chargeur',
                value: weapon.ammo.toString(),
                description: 'Capacite de base',
                accentColor: const Color(0xFF27D3C3),
              ),
              _MetricPanel(
                title: 'Rechargement',
                value: '${weapon.reloadTime.toStringAsFixed(1)} s',
                description: 'Temps moyen',
                accentColor: const Color(0xFF8FB4FF),
              ),
              _MetricPanel(
                title: 'Portee',
                value:
                    weapon.rangeMinLabel != null || weapon.rangeMaxLabel != null
                    ? '${weapon.rangeMinLabel ?? '-'} - ${weapon.rangeMaxLabel ?? '-'}'
                    : weapon.range.toStringAsFixed(0),
                description: 'Fenetre de portee',
                accentColor: const Color(0xFFE588FF),
              ),
              if (weapon.accuracy != null)
                _MetricPanel(
                  title: 'Precision',
                  value: weapon.accuracy!.toStringAsFixed(0),
                  description: 'Indice de precision',
                  accentColor: const Color(0xFF8FB4FF),
                ),
              if (weapon.mobility != null)
                _MetricPanel(
                  title: 'Mobilite',
                  value: weapon.mobility!.toStringAsFixed(1),
                  description: 'Coefficient de deplacement',
                  accentColor: const Color(0xFF27D3C3),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPanel extends StatelessWidget {
  const _MetricPanel({
    required this.title,
    required this.value,
    required this.description,
    required this.accentColor,
  });

  final String title;
  final String value;
  final String description;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiTokens.cardRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[accentColor.withAlpha(36), const Color(0xFF16212A)],
        ),
        border: Border.all(color: accentColor.withAlpha(92)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeaponAdvancedStatsSection extends StatelessWidget {
  const _WeaponAdvancedStatsSection({required this.weapon});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Profil de degats',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Repartition des impacts et attenuation selon la distance.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          if (weapon.headDamage != null)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _MetricPanel(
                  title: 'Tete',
                  value: _formatStatValue(weapon.headDamage),
                  description: 'Degats sur tir a la tete',
                  accentColor: const Color(0xFFD84F68),
                ),
                _MetricPanel(
                  title: 'Corps',
                  value: _formatStatValue(weapon.bodyDamage),
                  description: 'Degats sur le torse',
                  accentColor: const Color(0xFFFFB84D),
                ),
                _MetricPanel(
                  title: 'Extremites',
                  value: _formatStatValue(weapon.limbDamage),
                  description: 'Degats sur bras et jambes',
                  accentColor: const Color(0xFF27D3C3),
                ),
                _MetricPanel(
                  title: 'Dispersion',
                  value: weapon.bulletSpreadDegrees?.toStringAsFixed(1) ?? '-',
                  description: 'Ouverture nominale en degres',
                  accentColor: const Color(0xFF8FB4FF),
                ),
              ],
            ),
          if (weapon.distanceProfiles.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(70),
                borderRadius: BorderRadius.circular(UiTokens.cardRadius),
                border: Border.all(
                  color: colorScheme.outlineVariant.withAlpha(90),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Degats par distance',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final WeaponDistanceProfile profile
                      in weapon.distanceProfiles) ...<Widget>[
                    _DistanceProfileRow(profile: profile),
                    if (profile != weapon.distanceProfiles.last)
                      const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
          if (weapon.tags.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: weapon.tags
                  .map((String tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(22),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatStatValue(num? value) {
  if (value == null) {
    return '-';
  }

  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

class _DistanceProfileRow extends StatelessWidget {
  const _DistanceProfileRow({required this.profile});

  final WeaponDistanceProfile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double normalized = profile.damageMultiplier.clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                profile.distanceLabel,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${(profile.damageMultiplier * 100).toStringAsFixed(0)}%',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: normalized,
            backgroundColor: colorScheme.surface.withAlpha(120),
          ),
        ),
      ],
    );
  }
}

class _WeaponDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _WeaponDetailAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          debugPrint('[Navigation] back from weapon detail');
          if (context.canPop()) {
            context.pop();
            return;
          }

          context.goNamed(RouteNames.wiki);
        },
        icon: const Icon(Icons.arrow_back_rounded),
        tooltip: 'Retour',
      ),
      title: const Text('Weapon Detail'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WeaponDetailMessageState extends StatelessWidget {
  const _WeaponDetailMessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.showLoader = false,
    this.messageColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showLoader;
  final Color? messageColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showLoader)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            else
              Icon(icon, size: 44, color: messageColor ?? colorScheme.primary),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: messageColor ?? colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineSectionState extends StatelessWidget {
  const _InlineSectionState({
    required this.icon,
    required this.title,
    required this.message,
    this.showLoader = false,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showLoader;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showLoader)
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          )
        else
          Icon(icon, color: iconColor ?? colorScheme.primary, size: 32),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
