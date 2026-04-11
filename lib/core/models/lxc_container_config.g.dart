// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lxc_container_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LxcContainerConfig _$LxcContainerConfigFromJson(Map<String, dynamic> json) =>
    _LxcContainerConfig(
      hostname: json['hostname'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      memory: json['memory'] as String?,
      swap: json['swap'] as String?,
      cores: json['cores'] as String?,
      cpulimit: json['cpulimit'] as String?,
      cpuunits: json['cpuunits'] as String?,
      ostype: json['ostype'] as String?,
      arch: json['arch'] as String?,
      onboot: json['onboot'] as String?,
      startup: json['startup'] as String?,
      unprivileged: json['unprivileged'] as String?,
      features: json['features'] as String?,
      rootfs: json['rootfs'] as String?,
      passthrough:
          (json['passthrough'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$LxcContainerConfigToJson(_LxcContainerConfig instance) =>
    <String, dynamic>{
      'hostname': instance.hostname,
      'description': instance.description,
      'tags': instance.tags,
      'memory': instance.memory,
      'swap': instance.swap,
      'cores': instance.cores,
      'cpulimit': instance.cpulimit,
      'cpuunits': instance.cpuunits,
      'ostype': instance.ostype,
      'arch': instance.arch,
      'onboot': instance.onboot,
      'startup': instance.startup,
      'unprivileged': instance.unprivileged,
      'features': instance.features,
      'rootfs': instance.rootfs,
      'passthrough': instance.passthrough,
    };
