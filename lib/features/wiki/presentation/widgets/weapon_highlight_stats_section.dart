import 'package:flutter/material.dart';

class WeaponHighlightStatsSection extends StatelessWidget {
  const WeaponHighlightStatsSection({
    required this.damage,
    required this.fireRate,
    required this.ammo,
    super.key,
  });

  final int damage;
  final double fireRate;
  final int ammo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _HighlightStatCard(
            label: 'Damage',
            value: damage.toString(),
            icon: Icons.flash_on_rounded,
            accentColor: const Color(0xFFD84F68),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HighlightStatCard(
            label: 'Fire Rate',
            value: fireRate.toStringAsFixed(1),
            icon: Icons.speed_rounded,
            accentColor: const Color(0xFFFFB84D),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HighlightStatCard(
            label: 'Ammo',
            value: ammo.toString(),
            icon: Icons.inventory_2_rounded,
            accentColor: const Color(0xFF27D3C3),
          ),
        ),
      ],
    );
  }
}

class _HighlightStatCard extends StatelessWidget {
  const _HighlightStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[accentColor.withAlpha(48), const Color(0xFF18222C)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: accentColor),
            const SizedBox(height: 22),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(170),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
