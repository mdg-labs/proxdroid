// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

/// Parses `vmid` from jobs: single id, comma-separated string, or JSON array.
List<int> backupVmidsFromJson(Object? json) {
  if (json == null) return const [];
  if (json is int) return [json];
  if (json is num) return [json.toInt()];
  if (json is List) {
    return json.map(proxmoxInt).whereType<int>().toList();
  }
  final s = proxmoxString(json);
  if (s.isEmpty) return const [];
  return s
      .split(RegExp(r'[,\s;]+'))
      .map((p) => int.tryParse(p.trim()))
      .whereType<int>()
      .toList();
}

int? backupContentVmidFromJson(Object? json) => proxmoxInt(json);

@freezed
sealed class BackupJob with _$BackupJob {
  const factory BackupJob({
    required String id,
    @JsonKey(name: 'vmid', fromJson: backupVmidsFromJson)
    @Default([])
    List<int> vmids,
    @JsonKey(fromJson: proxmoxString) @Default('') String storage,
    @JsonKey(fromJson: proxmoxString) @Default('') String schedule,
    @JsonKey(name: 'last-run', fromJson: proxmoxInt) int? lastRun,
    @JsonKey(name: 'next-run', fromJson: proxmoxInt) int? nextRun,
  }) = _BackupJob;

  factory BackupJob.fromJson(Map<String, dynamic> json) =>
      _$BackupJobFromJson(json);
}

@freezed
sealed class BackupContent with _$BackupContent {
  const factory BackupContent({
    @JsonKey(fromJson: proxmoxString) required String volid,
    @JsonKey(fromJson: backupContentVmidFromJson) int? vmid,
    @JsonKey(fromJson: proxmoxString) @Default('') String format,
    @JsonKey(fromJson: proxmoxInt) int? size,
    @JsonKey(fromJson: proxmoxInt) int? ctime,

    /// PVE content kind (e.g. `backup`, `iso`).
    @JsonKey(fromJson: proxmoxString) @Default('') String content,
  }) = _BackupContent;

  factory BackupContent.fromJson(Map<String, dynamic> json) =>
      _$BackupContentFromJson(json);
}
