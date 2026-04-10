// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'container.freezed.dart';
part 'container.g.dart';

/// LXC power states only (no `paused` — use [VmStatus] for QEMU).
enum ContainerStatus { running, stopped, unknown }

ContainerStatus _containerStatusFromJson(Object? json) {
  if (json == null) return ContainerStatus.unknown;
  switch (json.toString().toLowerCase()) {
    case 'running':
      return ContainerStatus.running;
    case 'stopped':
    case 'prelaunch':
      return ContainerStatus.stopped;
    default:
      return ContainerStatus.unknown;
  }
}

Object? _containerStatusToJson(ContainerStatus status) => switch (status) {
  ContainerStatus.running => 'running',
  ContainerStatus.stopped => 'stopped',
  ContainerStatus.unknown => 'unknown',
};

int _ctidFromJson(Object? json) {
  final v = proxmoxInt(json);
  if (v == null) {
    throw FormatException('Container vmid (ctid) missing or invalid in JSON');
  }
  return v;
}

String _containerNameFromJson(Object? json) {
  final s = proxmoxString(json);
  return s.isEmpty ? '' : s;
}

@freezed
sealed class Container with _$Container {
  const factory Container({
    @JsonKey(fromJson: _ctidFromJson) required int vmid,
    @JsonKey(fromJson: _containerNameFromJson) required String name,
    @JsonKey(fromJson: _containerStatusFromJson, toJson: _containerStatusToJson)
    required ContainerStatus status,
    required String node,
    @JsonKey(fromJson: proxmoxDouble) double? cpu,
    @JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,
    @JsonKey(fromJson: proxmoxInt) int? mem,
    @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,
    @JsonKey(fromJson: proxmoxInt) int? disk,
    @JsonKey(fromJson: proxmoxInt) int? uptime,
    String? ostype,
  }) = _Container;

  factory Container.fromJson(Map<String, dynamic> json) =>
      _$ContainerFromJson(json);

  /// [GET /cluster/resources] row with `type: lxc`.
  factory Container.fromClusterResourcesItem(Map<String, dynamic> json) {
    if (json['type'] != 'lxc') {
      throw ArgumentError(
        'Expected cluster resource type lxc, got ${json['type']}',
      );
    }
    return Container.fromJson(json);
  }

  /// Row from [GET /nodes/{node}/lxc]; [node] is injected.
  factory Container.fromLxcListRow(
    Map<String, dynamic> json, {
    required String node,
  }) {
    final m = Map<String, dynamic>.from(json);
    m['node'] = node;
    return Container.fromJson(m);
  }
}
