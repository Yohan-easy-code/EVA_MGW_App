import 'package:flutter/material.dart';

abstract final class UiTokens {
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(20, 24, 20, 32);
  static const EdgeInsets pageHorizontalPadding = EdgeInsets.symmetric(
    horizontal: 20,
  );
  static const double headerGap = 10;
  static const double sectionGap = 20;
  static const double cardGap = 16;
  static const double cardRadius = 24;
  static const double panelRadius = 28;
  static const Duration quick = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 460);

  static const List<Color> pageGradient = <Color>[
    Color(0xFF0B1218),
    Color(0xFF10161D),
    Color(0xFF0F1720),
  ];
}
