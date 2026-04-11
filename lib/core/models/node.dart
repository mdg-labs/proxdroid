// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'node.freezed.dart';
part 'node.g.dart';

/// Cluster node: [GET /nodes], [GET /nodes/{node}/status], or `type=node` rows
/// from [GET /cluster/resources].
///
/// [name] maps from Proxmox `node`. For [GET /nodes/{node}/status], the API client
/// injects `node` and flattens `memory` / `rootfs` / `cpuinfo` before [fromJson].
@freezed
sealed class Node with _$Node {
  const factory Node({
    @JsonKey(name: 'node') required String name,
    String? status,
    @JsonKey(fromJson: proxmoxDouble) double? cpu,
    @JsonKey(name: 'maxcpu', fromJson: proxmoxInt) int? maxCpu,
    @JsonKey(fromJson: proxmoxInt) int? mem,
    @JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,
    @JsonKey(fromJson: proxmoxInt) int? disk,
    @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,
    @JsonKey(fromJson: proxmoxInt) int? uptime,
    @JsonKey(name: 'ssl_fingerprint') String? sslFingerprint,
    String? level,

    /// From [GET /nodes/{node}/status] `swap` map (flattened by the API client).
    @JsonKey(name: 'swapused', fromJson: proxmoxInt) int? swapUsed,
    @JsonKey(name: 'swaptotal', fromJson: proxmoxInt) int? swapTotal,

    /// First value of Proxmox `loadavg` (1 minute).
    @JsonKey(name: 'loadavg1m', fromJson: proxmoxDouble) double? loadavg1m,

    /// CPU I/O wait when exposed by the node status payload.
    @JsonKey(name: 'iowait', fromJson: proxmoxDouble) double? ioWait,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
}
