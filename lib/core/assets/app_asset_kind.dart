import 'package:flutter/material.dart';
import 'package:mgw_eva/core/constants/asset_paths.dart';

enum AppAssetKind {
  map(
    placeholderAssetPath: AssetPaths.mapPlaceholder,
    emptyTitle: 'Carte indisponible',
    emptySubtitle: 'Aucun asset de carte n\'est renseigne.',
    errorTitle: 'Carte invalide',
    errorSubtitle: 'Le fichier local de la carte est introuvable ou corrompu.',
    icon: Icons.map_outlined,
  ),
  weapon(
    placeholderAssetPath: AssetPaths.weaponPlaceholder,
    emptyTitle: 'Visuel indisponible',
    emptySubtitle: 'Aucun asset d\'arme n\'est renseigne.',
    errorTitle: 'Visuel invalide',
    errorSubtitle: 'Le fichier local de l\'arme est introuvable ou corrompu.',
    icon: Icons.image_not_supported_outlined,
  );

  const AppAssetKind({
    required this.placeholderAssetPath,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.errorTitle,
    required this.errorSubtitle,
    required this.icon,
  });

  final String placeholderAssetPath;
  final String emptyTitle;
  final String emptySubtitle;
  final String errorTitle;
  final String errorSubtitle;
  final IconData icon;
}
