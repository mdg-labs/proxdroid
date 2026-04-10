// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// Proxmox task lifecycle as returned by [GET /nodes/{node}/tasks] and
/// [GET /nodes/{node}/tasks/{upid}/status].
enum TaskStatus { running, ok, error, unknown }

/// Maps API / list `status` strings to [TaskStatus].
TaskStatus taskStatusFromApiString(Object? raw) {
  if (raw == null) return TaskStatus.unknown;
  final s = raw.toString().trim().toLowerCase();
  if (s.isEmpty) return TaskStatus.unknown;

  switch (s) {
    case 'running':
    case 'received':
    case 'queued':
    case 'processing':
    case 'zombie':
      return TaskStatus.running;
    case 'ok':
    case 'stopped':
      return TaskStatus.ok;
    case 'error':
      return TaskStatus.error;
    case 'unknown':
      return TaskStatus.unknown;
    case 'warn':
    case 'warning':
      return TaskStatus.ok;
    default:
      return TaskStatus.unknown;
  }
}

TaskStatus _taskStatusFromJson(Object? json) => taskStatusFromApiString(json);

Object? _taskStatusToJson(TaskStatus status) => switch (status) {
  TaskStatus.running => 'running',
  TaskStatus.ok => 'ok',
  TaskStatus.error => 'error',
  TaskStatus.unknown => 'unknown',
};

String _taskUpidFromJson(Object? json) {
  final s = proxmoxString(json);
  if (s.isEmpty) {
    throw const FormatException('Task.upid missing or empty in JSON');
  }
  return s;
}

String _taskNodeFromJson(Object? json) {
  final s = proxmoxString(json);
  if (s.isEmpty) {
    throw const FormatException('Task.node missing or empty in JSON');
  }
  return s;
}

String _taskTypeFromJson(Object? json) {
  final s = proxmoxString(json);
  return s.isEmpty ? 'unknown' : s;
}

/// Parses `data` from [GET /nodes/{node}/tasks/{upid}/status] when it is a
/// plain string or a map containing `status`.
TaskStatus taskStatusFromApiData(dynamic data) {
  if (data == null) return TaskStatus.unknown;
  if (data is String) return taskStatusFromApiString(data);
  if (data is Map) {
    final status = data['status'];
    if (status != null) return taskStatusFromApiString(status);
  }
  return TaskStatus.unknown;
}

@freezed
sealed class Task with _$Task {
  const factory Task({
    @JsonKey(fromJson: _taskUpidFromJson) required String upid,
    @JsonKey(fromJson: _taskNodeFromJson) required String node,
    @JsonKey(fromJson: _taskTypeFromJson) required String type,
    @JsonKey(fromJson: _taskStatusFromJson, toJson: _taskStatusToJson)
    required TaskStatus status,
    @JsonKey(name: 'starttime', fromJson: proxmoxInt) int? startTime,
    @JsonKey(name: 'endtime', fromJson: proxmoxInt) int? endTime,
    @JsonKey(fromJson: proxmoxString) @Default('') String user,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
