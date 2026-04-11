import 'package:flutter/material.dart';

import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

Color _hexToColor(String hex6) =>
    Color(0xFF000000 | int.parse(hex6, radix: 16));

/// PVE-style background: inline hex, then cluster map, then deterministic hue.
Color resolveProxmoxTagBackgroundColor(
  ProxmoxGuestTag tag,
  Map<String, String> clusterHexByLabelLowercase,
) {
  final inline = proxmoxNormalizeHexColor(tag.inlineBackgroundHex);
  if (inline != null) {
    return _hexToColor(inline);
  }
  final cluster = proxmoxNormalizeHexColor(
    clusterHexByLabelLowercase[tag.label.trim().toLowerCase()],
  );
  if (cluster != null) {
    return _hexToColor(cluster);
  }
  return _hashTagColor(tag.label);
}

Color _hashTagColor(String label) {
  var h = 0;
  for (final c in label.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  final hue = (h % 360).toDouble();
  return HSLColor.fromAHSL(1, hue, 0.42, 0.38).toColor();
}

Color contrastingForegroundOn(Color background) {
  final luminance = background.computeLuminance();
  return luminance > 0.55 ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
}

Color resolveProxmoxTagForegroundColor(
  ProxmoxGuestTag tag,
  Color background,
) {
  final inline = proxmoxNormalizeHexColor(tag.inlineForegroundHex);
  if (inline != null) {
    return _hexToColor(inline);
  }
  return contrastingForegroundOn(background);
}
