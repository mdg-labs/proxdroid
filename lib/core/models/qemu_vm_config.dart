// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/guest_config_indexed_line.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'qemu_vm_config.freezed.dart';
part 'qemu_vm_config.g.dart';

/// Keys consumed as structured Tier-A fields (remainder → [passthrough]).
const Set<String> kQemuVmConfigStructuredKeys = {
  'name',
  'description',
  'tags',
  'memory',
  'sockets',
  'cores',
  'vcpus',
  'cpu',
  'ostype',
  'onboot',
  'startup',
  'agent',
};

String? _pickStructured(Map<String, String> norm, String key) =>
    norm.containsKey(key) ? norm[key] : null;

@freezed
sealed class QemuVmConfig with _$QemuVmConfig {
  const QemuVmConfig._();

  const factory QemuVmConfig({
    String? name,
    String? description,
    String? tags,
    String? memory,
    String? sockets,
    String? cores,
    String? vcpus,
    String? cpu,
    String? ostype,
    String? onboot,
    String? startup,
    String? agent,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<GuestConfigIndexedLine> netLines,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<GuestConfigIndexedLine> diskLines,
    @Default({}) Map<String, String> passthrough,
  }) = _QemuVmConfig;

  factory QemuVmConfig.fromJson(Map<String, dynamic> json) =>
      _$QemuVmConfigFromJson(json);

  /// Parses flat `GET /nodes/{node}/qemu/{vmid}/config` `data` object.
  ///
  /// All values are normalized to strings; keys not listed in Tier A remain
  /// in [passthrough] only.
  factory QemuVmConfig.fromProxmoxConfigData(Map<String, dynamic> raw) {
    final norm = <String, String>{
      for (final e in raw.entries) e.key: proxmoxString(e.value),
    };
    final netLines = guestConfigParseNetLines(norm);
    final diskLines = guestConfigParseQemuDiskLines(norm);
    final passthrough = <String, String>{
      for (final e in norm.entries)
        if (!kQemuVmConfigStructuredKeys.contains(e.key) &&
            !guestConfigIsNetKey(e.key) &&
            !guestConfigIsQemuDiskKey(e.key))
          e.key: e.value,
    };
    return QemuVmConfig(
      name: _pickStructured(norm, 'name'),
      description: _pickStructured(norm, 'description'),
      tags: _pickStructured(norm, 'tags'),
      memory: _pickStructured(norm, 'memory'),
      sockets: _pickStructured(norm, 'sockets'),
      cores: _pickStructured(norm, 'cores'),
      vcpus: _pickStructured(norm, 'vcpus'),
      cpu: _pickStructured(norm, 'cpu'),
      ostype: _pickStructured(norm, 'ostype'),
      onboot: _pickStructured(norm, 'onboot'),
      startup: _pickStructured(norm, 'startup'),
      agent: _pickStructured(norm, 'agent'),
      netLines: netLines,
      diskLines: diskLines,
      passthrough: passthrough,
    );
  }

  /// Reconstructs the flat string map (structured + passthrough) for lossless
  /// checks against the normalized GET payload.
  Map<String, String> toFlatConfigMap() {
    final m = Map<String, String>.from(passthrough);
    void put(String key, String? v) {
      if (v != null) {
        m[key] = v;
      }
    }

    put('name', name);
    put('description', description);
    put('tags', tags);
    put('memory', memory);
    put('sockets', sockets);
    put('cores', cores);
    put('vcpus', vcpus);
    put('cpu', cpu);
    put('ostype', ostype);
    put('onboot', onboot);
    put('startup', startup);
    put('agent', agent);
    for (final line in netLines) {
      m[line.apiKey] = line.value;
    }
    for (final line in diskLines) {
      m[line.apiKey] = line.value;
    }
    return m;
  }
}
