import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/ui_tokens.dart';
import 'package:mgw_eva/core/widgets/app_page_scaffold.dart';
import 'package:mgw_eva/features/wiki/domain/entities/weapon.dart';

class WeaponDetailStatsPanel extends StatelessWidget {
  const WeaponDetailStatsPanel({required this.weapon, super.key});

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppSectionCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _CategoryChip(
                label: weapon.category,
                backgroundColor: colorScheme.primary.withAlpha(30),
                foregroundColor: colorScheme.primary,
              ),
              const _CategoryChip(
                label: 'Offline',
                backgroundColor: Color(0x1A27D3C3),
                foregroundColor: Color(0xFF27D3C3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            weapon.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            weapon.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF161F28), Color(0xFF111921)],
              ),
              border: Border.all(
                color: colorScheme.outlineVariant.withAlpha(96),
              ),
            ),
            child: Column(
              children: <Widget>[
                _StatRow(
                  label: 'Damage',
                  value: _formatStatValue(
                    weapon.averageDamage ?? weapon.damage,
                  ),
                  accentColor: const Color(0xFFD84F68),
                  icon: Icons.flash_on_rounded,
                ),
                const SizedBox(height: 14),
                _StatRow(
                  label: 'Fire Rate',
                  value: weapon.fireRate.toStringAsFixed(1),
                  accentColor: const Color(0xFFFFB84D),
                  icon: Icons.speed_rounded,
                ),
                const SizedBox(height: 14),
                _StatRow(
                  label: 'Ammo',
                  value: weapon.ammo.toString(),
                  accentColor: const Color(0xFF27D3C3),
                  icon: Icons.inventory_2_rounded,
                ),
                const SizedBox(height: 14),
                _StatRow(
                  label: 'Reload',
                  value: '${weapon.reloadTime.toStringAsFixed(1)} s',
                  accentColor: const Color(0xFF8FB4FF),
                  icon: Icons.restart_alt_rounded,
                ),
                const SizedBox(height: 14),
                _StatRow(
                  label: 'Range',
                  value: weapon.range.toStringAsFixed(0),
                  accentColor: const Color(0xFFE588FF),
                  icon: Icons.straighten_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MiniStatTile(
                label: 'Damage',
                value: _formatStatValue(weapon.averageDamage ?? weapon.damage),
              ),
              _MiniStatTile(
                label: 'Fire Rate',
                value: weapon.fireRate.toStringAsFixed(1),
              ),
              _MiniStatTile(label: 'Ammo', value: weapon.ammo.toString()),
              _MiniStatTile(
                label: 'Reload',
                value: '${weapon.reloadTime.toStringAsFixed(1)} s',
              ),
              _MiniStatTile(
                label: 'Range',
                value:
                    weapon.rangeMinLabel != null || weapon.rangeMaxLabel != null
                    ? '${weapon.rangeMinLabel ?? '-'} - ${weapon.rangeMaxLabel ?? '-'}'
                    : weapon.range.toStringAsFixed(0),
              ),
              if (weapon.bulletVelocity != null && weapon.bulletVelocity! > 0)
                _MiniStatTile(
                  label: 'Velocity',
                  value: '${weapon.bulletVelocity!.toStringAsFixed(0)} m/s',
                ),
              if (weapon.equipTime != null && weapon.equipTime! > 0)
                _MiniStatTile(
                  label: 'Equip',
                  value: '${weapon.equipTime!.toStringAsFixed(1)} s',
                ),
              if (weapon.accuracy != null)
                _MiniStatTile(
                  label: 'Accuracy',
                  value: weapon.accuracy!.toStringAsFixed(0),
                ),
              if (weapon.mobility != null)
                _MiniStatTile(
                  label: 'Mobility',
                  value: weapon.mobility!.toStringAsFixed(1),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accentColor.withAlpha(38),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: accentColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _MiniStatTile extends StatelessWidget {
  const _MiniStatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 108),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(84),
        borderRadius: BorderRadius.circular(UiTokens.cardRadius - 6),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(88)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

String _formatStatValue(num value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}
