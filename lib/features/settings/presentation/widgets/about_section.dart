import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/app_constants.dart';
import 'package:mgw_eva/core/widgets/app_brand_logo.dart';
import 'package:mgw_eva/features/settings/presentation/widgets/settings_section_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionCard(
      title: 'A Propos',
      subtitle:
          'Informations produit et socle technique utilise pour l\'application locale.',
      icon: Icons.info_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AppBrandLogo(size: 52),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  AppConstants.appName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          AboutRow(label: 'Application', value: AppConstants.appName),
          SizedBox(height: 10),
          AboutRow(label: 'Version', value: '1.0.0+1'),
          SizedBox(height: 10),
          AboutRow(
            label: 'Stack',
            value: 'Flutter, Riverpod, GoRouter, Drift, SQLite',
          ),
          SizedBox(height: 10),
          AboutRow(
            label: 'Mode',
            value: '100 % local, hors ligne, sans backend',
          ),
        ],
      ),
    );
  }
}

class AboutRow extends StatelessWidget {
  const AboutRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
