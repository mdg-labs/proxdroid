// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  upid: _taskUpidFromJson(json['upid']),
  node: _taskNodeFromJson(json['node']),
  type: _taskTypeFromJson(json['type']),
  status: _taskStatusFromJson(readTaskStatusJsonValue(json, 'status')),
  startTime: proxmoxInt(json['starttime']),
  endTime: proxmoxInt(json['endtime']),
  user: json['user'] == null ? '' : proxmoxString(json['user']),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'upid': instance.upid,
  'node': instance.node,
  'type': instance.type,
  'status': _taskStatusToJson(instance.status),
  'starttime': instance.startTime,
  'endtime': instance.endTime,
  'user': instance.user,
};
