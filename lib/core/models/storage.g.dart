// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Storage _$StorageFromJson(Map<String, dynamic> json) => _Storage(
  id: json['storage'] as String,
  node: json['node'] as String,
  type: json['type'] == null ? '' : proxmoxString(json['type']),
  content:
      json['content'] == null
          ? const []
          : storageContentKindsFromJson(json['content']),
  total: proxmoxInt(json['total']),
  used: proxmoxInt(json['used']),
  available: proxmoxInt(json['avail']),
  active:
      json['active'] == null ? false : storageActiveFromJson(json['active']),
);

Map<String, dynamic> _$StorageToJson(_Storage instance) => <String, dynamic>{
  'storage': instance.id,
  'node': instance.node,
  'type': instance.type,
  'content': instance.content,
  'total': instance.total,
  'used': instance.used,
  'avail': instance.available,
  'active': instance.active,
};
