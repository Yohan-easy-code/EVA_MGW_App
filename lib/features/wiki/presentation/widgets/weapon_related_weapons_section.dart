import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mgw_eva/app/router/route_names.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';
import 'package:mgw_eva/features/wiki/presentation/widgets/weapon_image_panel.dart';

class WeaponRelatedWeaponsSection extends StatelessWidget {
  const WeaponRelatedWeaponsSection({
    required this.weapons,
    required this.currentWeaponId,
    super.key,
  });

  final List<Weapon> weapons;
  final int currentWeaponId;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppSectionCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Armes associees',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Autres profils disponibles dans la base locale.',
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          if (weapons.isEmpty)
            const _RelatedEmptyState()
          else
            SizedBox(
              height: 224,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: weapons.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 14);
                },
                itemBuilder: (BuildContext context, int index) {
                  return _RelatedWeaponCard(
                    weapon: weapons[index],
                    isCurrent: weapons[index].id == currentWeaponId,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RelatedWeaponCard extends StatelessWidget {
  const _RelatedWeaponCard({required this.weapon, required this.isCurrent});

  final Weapon weapon;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 212,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isCurrent
              ? null
              : () {
                  debugPrint(
                    '[Navigation] push related weapon detail '
                    'id=${weapon.id} name="${weapon.name}"',
                  );
                  context.pushReplacementNamed(
                    RouteNames.wikiWeaponDetail,
                    pathParameters: <String, String>{
                      'weaponId': weapon.id.toString(),
                    },
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                WeaponImagePanel(
                  imagePath: weapon.imagePath,
                  height: 96,
                  placeholderLabel: weapon.name,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(24),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    weapon.category,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  weapon.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    _InlineStat(label: 'DMG', value: weapon.damage.toString()),
                    const SizedBox(width: 10),
                    _InlineStat(label: 'Ammo', value: weapon.ammo.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(84),
        borderRadius: BorderRadius.circular(UiTokens.cardRadius - 8),
      ),
      child: Text(
        '$label $value',
        style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _RelatedEmptyState extends StatelessWidget {
  const _RelatedEmptyState();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(70),
        borderRadius: BorderRadius.circular(UiTokens.cardRadius),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(88)),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.auto_stories_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'Aucune autre arme locale a afficher.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
