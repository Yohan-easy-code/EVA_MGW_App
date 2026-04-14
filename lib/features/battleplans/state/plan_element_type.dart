import 'package:flutter/material.dart';
import 'package:mgw_eva/features/battleplans/state/battle_plan_editor_icons.dart';

enum PlanElementType {
  player(
    storageKey: 'player',
    label: 'Player',
    subtitle: 'Ajoute un pion joueur circulaire.',
    icon: BattlePlanEditorIcons.player,
  ),
  marker(
    storageKey: 'marker',
    label: 'Marker',
    subtitle: 'Ajoute un marqueur de position.',
    icon: BattlePlanEditorIcons.marker,
  ),
  shield(
    storageKey: 'shield',
    label: 'Bouclier',
    subtitle: 'Ajoute un repere defensif de protection.',
    icon: BattlePlanEditorIcons.shield,
  ),
  plasma(
    storageKey: 'plasma',
    label: 'Plasma',
    subtitle: 'Ajoute un repere d\'energie plasma.',
    icon: BattlePlanEditorIcons.plasma,
  ),
  sticky(
    storageKey: 'sticky',
    label: 'Sticky',
    subtitle: 'Ajoute une charge collante tactique.',
    icon: BattlePlanEditorIcons.sticky,
  ),
  sonnar(
    storageKey: 'sonnar',
    label: 'Sonnar',
    subtitle: 'Ajoute un repere de scan ou radar.',
    icon: BattlePlanEditorIcons.sonnar,
  ),
  text(
    storageKey: 'text',
    label: 'Text',
    subtitle: 'Ajoute un bloc de texte tactique.',
    icon: BattlePlanEditorIcons.text,
  ),
  arrow(
    storageKey: 'arrow',
    label: 'Arrow',
    subtitle: 'Ajoute une fleche tactique orientee.',
    icon: BattlePlanEditorIcons.arrow,
  ),
  zoneCircle(
    storageKey: 'zone_circle',
    label: 'Zone Circle',
    subtitle: 'Ajoute une zone circulaire visible sur la carte.',
    icon: BattlePlanEditorIcons.zone,
  );

  const PlanElementType({
    required this.storageKey,
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String storageKey;
  final String label;
  final String subtitle;
  final IconData icon;

  double get selectionRadius {
    return switch (this) {
      PlanElementType.text || PlanElementType.arrow => 18,
      PlanElementType.player ||
      PlanElementType.marker ||
      PlanElementType.plasma ||
      PlanElementType.sonnar ||
      PlanElementType.zoneCircle => 999,
      PlanElementType.shield || PlanElementType.sticky => 20,
    };
  }

  static PlanElementType? fromStorageKey(String value) {
    for (final PlanElementType type in values) {
      if (type.storageKey == value) {
        return type;
      }
    }

    return null;
  }

  NewPlanElementDefaults defaults({
    required double mapWidth,
    required double mapHeight,
  }) {
    return switch (this) {
      PlanElementType.player => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 58,
        height: 58,
        color: 0xFF27D3C3,
        label: 'Player',
      ),
      PlanElementType.marker => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 42,
        height: 42,
        color: 0xFFFFB84D,
        label: 'Marker',
      ),
      PlanElementType.shield => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 56,
        height: 56,
        color: 0xFF63D7FF,
        label: 'Bouclier',
      ),
      PlanElementType.plasma => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 54,
        height: 54,
        color: 0xFF8F7CFF,
        label: 'Plasma',
      ),
      PlanElementType.sticky => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 50,
        height: 50,
        color: 0xFFFF7A59,
        label: 'Sticky',
      ),
      PlanElementType.sonnar => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 58,
        height: 58,
        color: 0xFF78E7B1,
        label: 'Sonnar',
      ),
      PlanElementType.text => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 120,
        height: 42,
        color: 0xFFFFFFFF,
        label: 'Note',
      ),
      PlanElementType.arrow => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 148,
        height: 72,
        color: 0xFFD84F68,
        label: 'Arrow',
      ),
      PlanElementType.zoneCircle => NewPlanElementDefaults.centered(
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        width: 144,
        height: 144,
        color: 0xFF8FB4FF,
        label: 'Zone',
      ),
    };
  }
}

class NewPlanElementDefaults {
  const NewPlanElementDefaults({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
    required this.label,
  });

  factory NewPlanElementDefaults.centered({
    required double mapWidth,
    required double mapHeight,
    required double width,
    required double height,
    required int color,
    required String label,
  }) {
    return NewPlanElementDefaults(
      x: (mapWidth - width) / 2,
      y: (mapHeight - height) / 2,
      width: width,
      height: height,
      color: color,
      label: label,
    );
  }

  final double x;
  final double y;
  final double width;
  final double height;
  final int color;
  final String label;
}
