import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

/// One guest tag from Proxmox `tags` (semicolon-separated string on qemu/lxc).
///
/// Inline `color=` / `icon=` segments are merged with the preceding tag name;
/// see [parseProxmoxGuestTagsString].
final class ProxmoxGuestTag {
  const ProxmoxGuestTag({
    required this.label,
    this.inlineBackgroundHex,
    this.inlineForegroundHex,
    this.iconKey,
  });

  final String label;
  final String? inlineBackgroundHex;
  final String? inlineForegroundHex;
  final String? iconKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxmoxGuestTag &&
          other.label == label &&
          other.inlineBackgroundHex == inlineBackgroundHex &&
          other.inlineForegroundHex == inlineForegroundHex &&
          other.iconKey == iconKey;

  @override
  int get hashCode =>
      Object.hash(label, inlineBackgroundHex, inlineForegroundHex, iconKey);
}

bool _isPropertyOnlySegment(String segment) {
  final eq = segment.indexOf('=');
  if (eq <= 0) return false;
  final key = segment.substring(0, eq).trim().toLowerCase();
  return key == 'color' ||
      key == 'icon' ||
      key == 'iconcolor' ||
      key == 'textcolor';
}

/// Merges `;`-split pieces so `prod;color=ABABAB` stays one tag.
List<String> mergeProxmoxTagSegments(List<String> rawParts) {
  final out = <String>[];
  for (final p in rawParts) {
    if (p.isEmpty) continue;
    if (_isPropertyOnlySegment(p) && out.isNotEmpty) {
      out[out.length - 1] = '${out.last};$p';
    } else {
      out.add(p);
    }
  }
  return out;
}

String? _normalizeHexColor(String? raw) => proxmoxNormalizeHexColor(raw);

({String key, String value})? _parseKeyValue(String part) {
  final eq = part.indexOf('=');
  if (eq <= 0) return null;
  final k = part.substring(0, eq).trim();
  final v = part.substring(eq + 1).trim();
  if (k.isEmpty) return null;
  return (key: k, value: v);
}

/// Parses one merged segment (e.g. `prod` or `prod;color=EE00FF;icon=computer`).
ProxmoxGuestTag parseSingleGuestTagSegment(String segment) {
  final parts =
      segment
          .split(';')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
  if (parts.isEmpty) {
    return const ProxmoxGuestTag(label: '');
  }
  final label = parts.first;
  String? bg;
  String? fg;
  String? icon;
  for (var i = 1; i < parts.length; i++) {
    final kv = _parseKeyValue(parts[i]);
    if (kv == null) continue;
    switch (kv.key.toLowerCase()) {
      case 'color':
        bg = _normalizeHexColor(kv.value) ?? bg;
        break;
      case 'textcolor':
        fg = _normalizeHexColor(kv.value) ?? fg;
        break;
      case 'icon':
        icon = kv.value.isEmpty ? null : kv.value;
        break;
      case 'iconcolor':
        fg = _normalizeHexColor(kv.value) ?? fg;
        break;
      default:
        break;
    }
  }
  return ProxmoxGuestTag(
    label: label,
    inlineBackgroundHex: bg,
    inlineForegroundHex: fg,
    iconKey: icon,
  );
}

/// Parses the full `tags` field from cluster resources / guest list rows.
List<ProxmoxGuestTag> parseProxmoxGuestTagsString(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return const [];
  final pieces =
      trimmed
          .split(';')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
  final merged = mergeProxmoxTagSegments(pieces);
  return merged
      .map(parseSingleGuestTagSegment)
      .where((t) => t.label.isNotEmpty)
      .toList();
}

List<ProxmoxGuestTag> guestTagsFromJson(Object? json) {
  final s = proxmoxString(json);
  return parseProxmoxGuestTagsString(s);
}

/// Lossy round-trip: labels only (matches common PVE `tags` string shape).
String? guestTagsToJson(List<ProxmoxGuestTag> tags) {
  if (tags.isEmpty) return null;
  return tags.map((t) => t.label).join(';');
}
