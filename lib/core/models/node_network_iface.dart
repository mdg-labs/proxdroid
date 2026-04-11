// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'node_network_iface.freezed.dart';
part 'node_network_iface.g.dart';

/// Row from [GET /nodes/{node}/network].
@freezed
sealed class NodeNetworkIface with _$NodeNetworkIface {
  const factory NodeNetworkIface({
    @JsonKey(fromJson: proxmoxString) required String iface,
    @JsonKey(fromJson: proxmoxString) @Default('') String type,
  }) = _NodeNetworkIface;

  const NodeNetworkIface._();

  factory NodeNetworkIface.fromJson(Map<String, dynamic> json) =>
      _$NodeNetworkIfaceFromJson(json);

  /// Interfaces suitable as `bridge=` targets for QEMU/LXC (Linux bridge,
  /// OVS bridge, VLAN on bridge; excludes plain `eth` uplinks).
  bool get isGuestAttachableBridge {
    final t = type.toLowerCase();
    if (t == 'bridge' || t == 'ovsbridge' || t == 'vlan') {
      return iface.isNotEmpty;
    }
    if (t == 'bond' && iface.startsWith('bond')) {
      return true;
    }
    if (iface.startsWith('vmbr')) {
      return true;
    }
    return false;
  }
}
