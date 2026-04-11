import 'dart:convert';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

/// Parsed `GET /version` `data` object (daemon version + optional UI hints).
final class ProxmoxVersion {
  const ProxmoxVersion({
    required this.version,
    this.release,
    this.tagBackgroundHexByTagLabel = const {},
  });

  final String version;
  final String? release;

  /// Lowercase tag label → 6-char uppercase RGB hex (background from datacenter).
  final Map<String, String> tagBackgroundHexByTagLabel;

  factory ProxmoxVersion.fromDataJson(Map<String, dynamic> json) {
    final v = json['version'];
    final r = json['release'];
    return ProxmoxVersion(
      version: v is String ? v : v?.toString() ?? '',
      release: r is String ? r : r?.toString(),
      tagBackgroundHexByTagLabel: parseProxmoxTagColorsFromVersionJson(
        json['tag-colors'],
      ),
    );
  }
}

/// Parses PVE `/version` `tag-colors` (shape varies by major version).
Map<String, String> parseProxmoxTagColorsFromVersionJson(Object? raw) {
  final out = <String, String>{};
  if (raw == null) return Map.unmodifiable(out);

  Object? decoded = raw;
  if (raw is String && raw.trim().isNotEmpty) {
    try {
      decoded = jsonDecode(raw) as Object?;
    } catch (_) {
      decoded = raw;
    }
  }

  if (decoded is Map) {
    for (final e in decoded.entries) {
      final k = e.key.toString().trim().toLowerCase();
      if (k.isEmpty) continue;
      final hex = _tagColorValueToHex(e.value);
      if (hex != null) out[k] = hex;
    }
  }
  return Map.unmodifiable(out);
}

String? _tagColorValueToHex(Object? value) {
  if (value == null) return null;
  if (value is String) {
    final s = value.trim();
    if (s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length >= 2) {
      final bg = proxmoxNormalizeHexColor(parts[1]);
      if (bg != null) return bg;
    }
    return proxmoxNormalizeHexColor(s);
  }
  if (value is Map) {
    final nested =
        value['color'] ??
        value['background'] ??
        value['bg'] ??
        value['value'];
    return _tagColorValueToHex(nested);
  }
  return null;
}
