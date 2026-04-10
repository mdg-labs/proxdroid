// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Container _$ContainerFromJson(Map<String, dynamic> json) => _Container(
  vmid: _ctidFromJson(json['vmid']),
  name: _containerNameFromJson(json['name']),
  status: _containerStatusFromJson(json['status']),
  node: json['node'] as String,
  cpu: proxmoxDouble(json['cpu']),
  maxMem: proxmoxInt(json['maxmem']),
  mem: proxmoxInt(json['mem']),
  maxDisk: proxmoxInt(json['maxdisk']),
  disk: proxmoxInt(json['disk']),
  uptime: proxmoxInt(json['uptime']),
  ostype: json['ostype'] as String?,
);

Map<String, dynamic> _$ContainerToJson(_Container instance) =>
    <String, dynamic>{
      'vmid': instance.vmid,
      'name': instance.name,
      'status': _containerStatusToJson(instance.status),
      'node': instance.node,
      'cpu': instance.cpu,
      'maxmem': instance.maxMem,
      'mem': instance.mem,
      'maxdisk': instance.maxDisk,
      'disk': instance.disk,
      'uptime': instance.uptime,
      'ostype': instance.ostype,
    };
