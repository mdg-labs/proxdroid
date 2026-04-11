// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vm _$VmFromJson(Map<String, dynamic> json) => _Vm(
  vmid: _vmidFromJson(json['vmid']),
  name: _vmNameFromJson(json['name']),
  status: _vmStatusFromJson(json['status']),
  node: json['node'] as String,
  cpu: proxmoxDouble(json['cpu']),
  maxMem: proxmoxInt(json['maxmem']),
  mem: proxmoxInt(json['mem']),
  maxDisk: proxmoxInt(json['maxdisk']),
  disk: proxmoxInt(json['disk']),
  uptime: proxmoxInt(json['uptime']),
  tags: json['tags'] == null ? const [] : guestTagsFromJson(json['tags']),
);

Map<String, dynamic> _$VmToJson(_Vm instance) => <String, dynamic>{
  'vmid': instance.vmid,
  'name': instance.name,
  'status': _vmStatusToJson(instance.status),
  'node': instance.node,
  'cpu': instance.cpu,
  'maxmem': instance.maxMem,
  'mem': instance.mem,
  'maxdisk': instance.maxDisk,
  'disk': instance.disk,
  'uptime': instance.uptime,
  'tags': guestTagsToJson(instance.tags),
};
