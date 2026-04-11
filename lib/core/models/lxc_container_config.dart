// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'lxc_container_config.freezed.dart';
part 'lxc_container_config.g.dart';

const Set<String> kLxcContainerConfigStructuredKeys = {
  'hostname',
  'description',
  'tags',
  'memory',
  'swap',
  'cores',
  'cpulimit',
  'cpuunits',
  'ostype',
  'arch',
  'onboot',
  'startup',
  'unprivileged',
  'features',
  'rootfs',
};

String? _pickStructured(Map<String, String> norm, String key) =>
    norm.containsKey(key) ? norm[key] : null;

@freezed
sealed class LxcContainerConfig with _$LxcContainerConfig {
  const LxcContainerConfig._();

  const factory LxcContainerConfig({
    String? hostname,
    String? description,
    String? tags,
    String? memory,
    String? swap,
    String? cores,
    String? cpulimit,
    String? cpuunits,
    String? ostype,
    String? arch,
    String? onboot,
    String? startup,
    String? unprivileged,
    String? features,
    String? rootfs,
    @Default({}) Map<String, String> passthrough,
  }) = _LxcContainerConfig;

  factory LxcContainerConfig.fromJson(Map<String, dynamic> json) =>
      _$LxcContainerConfigFromJson(json);

  /// Parses flat `GET /nodes/{node}/lxc/{vmid}/config` `data` object.
  factory LxcContainerConfig.fromProxmoxConfigData(Map<String, dynamic> raw) {
    final norm = <String, String>{
      for (final e in raw.entries) e.key: proxmoxString(e.value),
    };
    final passthrough = <String, String>{
      for (final e in norm.entries)
        if (!kLxcContainerConfigStructuredKeys.contains(e.key)) e.key: e.value,
    };
    return LxcContainerConfig(
      hostname: _pickStructured(norm, 'hostname'),
      description: _pickStructured(norm, 'description'),
      tags: _pickStructured(norm, 'tags'),
      memory: _pickStructured(norm, 'memory'),
      swap: _pickStructured(norm, 'swap'),
      cores: _pickStructured(norm, 'cores'),
      cpulimit: _pickStructured(norm, 'cpulimit'),
      cpuunits: _pickStructured(norm, 'cpuunits'),
      ostype: _pickStructured(norm, 'ostype'),
      arch: _pickStructured(norm, 'arch'),
      onboot: _pickStructured(norm, 'onboot'),
      startup: _pickStructured(norm, 'startup'),
      unprivileged: _pickStructured(norm, 'unprivileged'),
      features: _pickStructured(norm, 'features'),
      rootfs: _pickStructured(norm, 'rootfs'),
      passthrough: passthrough,
    );
  }

  Map<String, String> toFlatConfigMap() {
    final m = Map<String, String>.from(passthrough);
    void put(String key, String? v) {
      if (v != null) {
        m[key] = v;
      }
    }

    put('hostname', hostname);
    put('description', description);
    put('tags', tags);
    put('memory', memory);
    put('swap', swap);
    put('cores', cores);
    put('cpulimit', cpulimit);
    put('cpuunits', cpuunits);
    put('ostype', ostype);
    put('arch', arch);
    put('onboot', onboot);
    put('startup', startup);
    put('unprivileged', unprivileged);
    put('features', features);
    put('rootfs', rootfs);
    return m;
  }
}
