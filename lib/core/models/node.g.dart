// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Node _$NodeFromJson(Map<String, dynamic> json) => _Node(
  name: json['node'] as String,
  status: json['status'] as String?,
  cpu: proxmoxDouble(json['cpu']),
  maxCpu: proxmoxInt(json['maxcpu']),
  mem: proxmoxInt(json['mem']),
  maxMem: proxmoxInt(json['maxmem']),
  disk: proxmoxInt(json['disk']),
  maxDisk: proxmoxInt(json['maxdisk']),
  uptime: proxmoxInt(json['uptime']),
  sslFingerprint: json['ssl_fingerprint'] as String?,
  level: json['level'] as String?,
);

Map<String, dynamic> _$NodeToJson(_Node instance) => <String, dynamic>{
  'node': instance.name,
  'status': instance.status,
  'cpu': instance.cpu,
  'maxcpu': instance.maxCpu,
  'mem': instance.mem,
  'maxmem': instance.maxMem,
  'disk': instance.disk,
  'maxdisk': instance.maxDisk,
  'uptime': instance.uptime,
  'ssl_fingerprint': instance.sslFingerprint,
  'level': instance.level,
};
