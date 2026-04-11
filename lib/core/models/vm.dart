// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'vm.freezed.dart';
part 'vm.g.dart';

enum VmStatus { running, stopped, paused, unknown }

VmStatus _vmStatusFromJson(Object? json) {
  if (json == null) return VmStatus.unknown;
  switch (json.toString().toLowerCase()) {
    case 'running':
      return VmStatus.running;
    case 'stopped':
    case 'prelaunch':
      return VmStatus.stopped;
    case 'paused':
      return VmStatus.paused;
    default:
      return VmStatus.unknown;
  }
}

Object? _vmStatusToJson(VmStatus status) => switch (status) {
  VmStatus.running => 'running',
  VmStatus.stopped => 'stopped',
  VmStatus.paused => 'paused',
  VmStatus.unknown => 'unknown',
};

int _vmidFromJson(Object? json) {
  final v = proxmoxInt(json);
  if (v == null) {
    throw FormatException('Vm.vmid missing or invalid in JSON');
  }
  return v;
}

String _vmNameFromJson(Object? json) {
  final s = proxmoxString(json);
  return s.isEmpty ? '' : s;
}

@freezed
sealed class Vm with _$Vm {
  const factory Vm({
    @JsonKey(fromJson: _vmidFromJson) required int vmid,
    @JsonKey(fromJson: _vmNameFromJson) required String name,
    @JsonKey(fromJson: _vmStatusFromJson, toJson: _vmStatusToJson)
    required VmStatus status,
    required String node,
    @JsonKey(fromJson: proxmoxDouble) double? cpu,
    @JsonKey(name: 'maxmem', fromJson: proxmoxInt) int? maxMem,
    @JsonKey(fromJson: proxmoxInt) int? mem,
    @JsonKey(name: 'maxdisk', fromJson: proxmoxInt) int? maxDisk,
    @JsonKey(fromJson: proxmoxInt) int? disk,
    @JsonKey(fromJson: proxmoxInt) int? uptime,
    @JsonKey(fromJson: guestTagsFromJson, toJson: guestTagsToJson)
    @Default([])
    List<ProxmoxGuestTag> tags,
  }) = _Vm;

  factory Vm.fromJson(Map<String, dynamic> json) => _$VmFromJson(json);

  /// [GET /cluster/resources] row with `type: qemu`.
  factory Vm.fromClusterResourcesItem(Map<String, dynamic> json) {
    if (json['type'] != 'qemu') {
      throw ArgumentError(
        'Expected cluster resource type qemu, got ${json['type']}',
      );
    }
    return Vm.fromJson(json);
  }

  /// Row from [GET /nodes/{node}/qemu]; [node] is injected (not in list payload).
  factory Vm.fromQemuListRow(
    Map<String, dynamic> json, {
    required String node,
  }) {
    final m = Map<String, dynamic>.from(json);
    m['node'] = node;
    return Vm.fromJson(m);
  }
}
