// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qemu_vm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QemuVmConfig _$QemuVmConfigFromJson(Map<String, dynamic> json) =>
    _QemuVmConfig(
      name: json['name'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      memory: json['memory'] as String?,
      sockets: json['sockets'] as String?,
      cores: json['cores'] as String?,
      vcpus: json['vcpus'] as String?,
      cpu: json['cpu'] as String?,
      ostype: json['ostype'] as String?,
      onboot: json['onboot'] as String?,
      startup: json['startup'] as String?,
      agent: json['agent'] as String?,
      passthrough:
          (json['passthrough'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$QemuVmConfigToJson(_QemuVmConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'memory': instance.memory,
      'sockets': instance.sockets,
      'cores': instance.cores,
      'vcpus': instance.vcpus,
      'cpu': instance.cpu,
      'ostype': instance.ostype,
      'onboot': instance.onboot,
      'startup': instance.startup,
      'agent': instance.agent,
      'passthrough': instance.passthrough,
    };
