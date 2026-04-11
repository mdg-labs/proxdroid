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
    case 'failed':
    case 'failure':
    case 'aborted':
    case 'canceled':
    case 'cancelled':
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
/// plain string or a map containing `status` / `exitstatus`.
///
/// PVE uses `status`: `running` | `stopped` for this endpoint; success vs
/// failure is in optional `exitstatus` (`OK` vs a message such as `TASK ERROR:`).
TaskStatus taskStatusFromApiData(dynamic data) {
  if (data == null) return TaskStatus.unknown;
  if (data is String) return taskStatusFromApiString(data);
  if (data is Map) {
    final statusVal = data['status'];
    final statusStr = statusVal?.toString().trim().toLowerCase();
    if (statusStr == 'stopped') {
      final exit = data['exitstatus'];
      final exitStr = exit?.toString().trim() ?? '';
      if (exitStr.isEmpty || exitStr.toLowerCase() == 'ok') {
        return TaskStatus.ok;
      }
      return TaskStatus.error;
    }
    if (statusStr == 'running') {
      return TaskStatus.running;
    }
    if (statusVal != null) {
      return taskStatusFromApiString(statusVal);
    }
  }
  return TaskStatus.unknown;
}

/// Derives a JSON value for [Task.status] from a [GET /nodes/{node}/tasks] row.
///
/// PVE list rows differ from [GET …/tasks/{upid}/status]:
/// - Archive lines store the outcome in `status` only (no `exitstatus` on the
///   list schema). Values come from [PVE::UPID::read_status]: `OK`,
///   `WARNINGS: N`, `unexpected status`, or the **message body** after
///   `TASK ERROR:` (e.g. `VM is locked`) — not the operation `type`.
/// - Some proxies or versions may still send `exitstatus`; treat like the
///   status endpoint when present.
Object? readTaskStatusJsonValue(Map json, String key) {
  final statusRaw = json['status'];
  final typeStr = proxmoxString(json['type']);
  final exitRaw = json['exitstatus'];
  final exitStr = exitRaw?.toString().trim() ?? '';

  if (taskStatusFromApiString(statusRaw) == TaskStatus.running) {
    return statusRaw;
  }

  if (exitStr.isNotEmpty && exitStr.toLowerCase() != 'ok') {
    return 'error';
  }

  if (typeStr.toLowerCase().contains('task error')) {
    return 'error';
  }

  final statusNorm = statusRaw?.toString().trim().toLowerCase() ?? '';
  if (statusNorm == 'stopped') {
    return 'ok';
  }

  // Archive / list outcome strings (see PVE::UPID::read_status).
  if (statusNorm == 'ok') {
    return 'ok';
  }
  if (RegExp(r'^warnings:\s*\d+$').hasMatch(statusNorm)) {
    return 'ok';
  }
  if (statusNorm.contains('task error')) {
    return 'error';
  }
  if (statusNorm == 'unexpected status') {
    return statusRaw;
  }
  if (statusNorm == 'unknown') {
    return statusRaw;
  }

  final parsed = taskStatusFromApiString(statusRaw);
  if (parsed != TaskStatus.unknown) {
    return statusRaw;
  }

  // Non-empty free-form `status` is an error message from the task log.
  if (statusNorm.isNotEmpty) {
    return 'error';
  }

  return statusRaw;
}

@freezed
sealed class Task with _$Task {
  const factory Task({
    @JsonKey(fromJson: _taskUpidFromJson) required String upid,
    @JsonKey(fromJson: _taskNodeFromJson) required String node,
    @JsonKey(fromJson: _taskTypeFromJson) required String type,
    @JsonKey(
      readValue: readTaskStatusJsonValue,
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    required TaskStatus status,
    @JsonKey(name: 'starttime', fromJson: proxmoxInt) int? startTime,
    @JsonKey(name: 'endtime', fromJson: proxmoxInt) int? endTime,
    @JsonKey(fromJson: proxmoxString) @Default('') String user,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
