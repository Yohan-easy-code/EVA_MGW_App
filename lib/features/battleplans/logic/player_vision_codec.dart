import 'dart:convert';

import 'package:mgw_eva/features/battleplans/domain/entities/player_vision_settings.dart';

final class PlayerVisionCodec {
  const PlayerVisionCodec._();

  static const String _visionKey = 'player_vision';
  static const String _rangeKey = 'vision_range';
  static const String _fovKey = 'vision_fov_degrees';
  static const String _showConeKey = 'show_vision_cone';
  static const String _showAimLineKey = 'show_aim_line';

  static PlayerVisionSettings fromExtraJson(String? extraJson) {
    if (extraJson == null || extraJson.trim().isEmpty) {
      return const PlayerVisionSettings.defaults();
    }

    try {
      final Object? decoded = jsonDecode(extraJson);
      if (decoded is! Map<String, Object?>) {
        return const PlayerVisionSettings.defaults();
      }

      final Object? rawVision = decoded[_visionKey];
      if (rawVision is! Map<String, Object?>) {
        return const PlayerVisionSettings.defaults();
      }

      return PlayerVisionSettings(
        visionRange: _toDouble(rawVision[_rangeKey], fallback: 340),
        visionFovDegrees: _toDouble(rawVision[_fovKey], fallback: 68),
        showVisionCone: _toBool(rawVision[_showConeKey], fallback: true),
        showAimLine: _toBool(rawVision[_showAimLineKey], fallback: true),
      );
    } catch (_) {
      return const PlayerVisionSettings.defaults();
    }
  }

  static String encode(PlayerVisionSettings settings, {String? extraJson}) {
    Map<String, Object?> root = <String, Object?>{};
    if (extraJson != null && extraJson.trim().isNotEmpty) {
      try {
        final Object? decoded = jsonDecode(extraJson);
        if (decoded is Map<String, Object?>) {
          root = Map<String, Object?>.from(decoded);
        }
      } catch (_) {}
    }

    root[_visionKey] = <String, Object?>{
      _rangeKey: settings.visionRange,
      _fovKey: settings.visionFovDegrees,
      _showConeKey: settings.showVisionCone,
      _showAimLineKey: settings.showAimLine,
    };

    return jsonEncode(root);
  }

  static String defaultsJson() {
    return encode(const PlayerVisionSettings.defaults());
  }

  static double _toDouble(Object? value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }

    return fallback;
  }

  static bool _toBool(Object? value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }

    return fallback;
  }
}
