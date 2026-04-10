// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupJob _$BackupJobFromJson(Map<String, dynamic> json) => _BackupJob(
  id: json['id'] as String,
  vmids: json['vmid'] == null ? const [] : backupVmidsFromJson(json['vmid']),
  storage: json['storage'] == null ? '' : proxmoxString(json['storage']),
  schedule: json['schedule'] == null ? '' : proxmoxString(json['schedule']),
  lastRun: proxmoxInt(json['last-run']),
  nextRun: proxmoxInt(json['next-run']),
);

Map<String, dynamic> _$BackupJobToJson(_BackupJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vmid': instance.vmids,
      'storage': instance.storage,
      'schedule': instance.schedule,
      'last-run': instance.lastRun,
      'next-run': instance.nextRun,
    };

_BackupContent _$BackupContentFromJson(Map<String, dynamic> json) =>
    _BackupContent(
      volid: proxmoxString(json['volid']),
      vmid: backupContentVmidFromJson(json['vmid']),
      format: json['format'] == null ? '' : proxmoxString(json['format']),
      size: proxmoxInt(json['size']),
      ctime: proxmoxInt(json['ctime']),
      content: json['content'] == null ? '' : proxmoxString(json['content']),
    );

Map<String, dynamic> _$BackupContentToJson(_BackupContent instance) =>
    <String, dynamic>{
      'volid': instance.volid,
      'vmid': instance.vmid,
      'format': instance.format,
      'size': instance.size,
      'ctime': instance.ctime,
      'content': instance.content,
    };
