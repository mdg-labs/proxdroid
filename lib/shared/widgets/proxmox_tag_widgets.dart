import 'package:flutter/material.dart';

import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/core/utils/proxmox_tag_color_resolve.dart';

/// Layout density for [ProxmoxTagBadge] / [ProxmoxTagRow].
enum ProxmoxTagDensity { compact, comfortable }

IconData? proxmoxTagIconData(String? iconKey) {
  if (iconKey == null || iconKey.isEmpty) return null;
  switch (iconKey.toLowerCase()) {
    case 'computer':
    case 'desktop':
      return Icons.computer_outlined;
    case 'database':
    case 'storage':
      return Icons.storage_outlined;
    case 'server':
    case 'network':
      return Icons.dns_outlined;
    case 'mail':
    case 'email':
      return Icons.mail_outline;
    case 'web':
    case 'globe':
      return Icons.public_outlined;
    case 'security':
    case 'shield':
      return Icons.shield_outlined;
    default:
      return Icons.label_outline;
  }
}

/// Single guest tag chip (Proxmox-style colors when available).
class ProxmoxTagBadge extends StatelessWidget {
  const ProxmoxTagBadge({
    required this.tag,
    required this.clusterTagHexByLabel,
    this.density = ProxmoxTagDensity.compact,
    super.key,
  });

  final ProxmoxGuestTag tag;
  final Map<String, String> clusterTagHexByLabel;
  final ProxmoxTagDensity density;

  @override
  Widget build(BuildContext context) {
    final bg = resolveProxmoxTagBackgroundColor(tag, clusterTagHexByLabel);
    final fg = resolveProxmoxTagForegroundColor(tag, bg);
    final icon = proxmoxTagIconData(tag.iconKey);
    final compact = density == ProxmoxTagDensity.compact;
    final fontSize = compact ? 10.5 : 12.0;
    final iconSize = compact ? 11.0 : 14.0;
    final hPad = compact ? 6.0 : 8.0;
    final vPad = compact ? 3.0 : 5.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: fg),
              SizedBox(width: compact ? 3 : 4),
            ],
            Flexible(
              child: Text(
                tag.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal row of [ProxmoxTagBadge] for list rows or detail headers.
class ProxmoxTagRow extends StatelessWidget {
  const ProxmoxTagRow({
    required this.tags,
    required this.clusterTagHexByLabel,
    this.density = ProxmoxTagDensity.compact,
    this.spacing = 6,
    super.key,
  });

  final List<ProxmoxGuestTag> tags;
  final Map<String, String> clusterTagHexByLabel;
  final ProxmoxTagDensity density;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: spacing,
      runSpacing: spacing * 0.67,
      children:
          tags
              .map(
                (t) => ProxmoxTagBadge(
                  tag: t,
                  clusterTagHexByLabel: clusterTagHexByLabel,
                  density: density,
                ),
              )
              .toList(),
    );
  }
}
