import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_image_panel.dart';

class WeaponCard extends StatelessWidget {
  const WeaponCard({required this.weapon, super.key});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: colorScheme.primary.withAlpha(22),
        onTap: () {
          debugPrint(
            '[Navigation] push weapon detail id=${weapon.id} name="${weapon.name}"',
          );
          context.pushNamed(
            RouteNames.wikiWeaponDetail,
            pathParameters: <String, String>{'weaponId': weapon.id.toString()},
          );
        },
        child: AnimatedContainer(
          duration: UiTokens.quick,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'weapon-image-${weapon.id}',
                child: WeaponImagePanel(
                  imagePath: weapon.imagePath,
                  height: 156,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      weapon.category,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _WeaponStatChip(
                    label: 'DMG',
                    value: weapon.damage.toString(),
                  ),
                  _WeaponStatChip(
                    label: 'RPM',
                    value: weapon.fireRate.toStringAsFixed(1),
                  ),
                  _WeaponStatChip(label: 'Ammo', value: weapon.ammo.toString()),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                weapon.name,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weapon.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatColumn(
                      label: 'Reload',
                      value: '${weapon.reloadTime.toStringAsFixed(1)} s',
                    ),
                  ),
                  Expanded(
                    child: _StatColumn(
                      label: 'Range',
                      value: weapon.range.toStringAsFixed(0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeaponStatChip extends StatelessWidget {
  const _WeaponStatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(100)),
      ),
      child: Text(
        '$label $value',
        style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
