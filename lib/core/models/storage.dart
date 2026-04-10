// ignore_for_file: invalid_annotation_target
// @JsonKey on Freezed factory parameters is supported by code generation.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:proxdroid/core/models/proxmox_json_helpers.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

/// Normalizes PVE `content` (comma-separated string or JSON array) to tokens.
List<String> storageContentKindsFromJson(Object? json) {
  if (json == null) return const [];
  if (json is List) {
    return json
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  final s = proxmoxString(json);
  if (s.isEmpty) return const [];
  return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

bool storageActiveFromJson(Object? json) {
  if (json == null) return false;
  if (json is bool) return json;
  final i = proxmoxInt(json);
  return i != null && i != 0;
}

@freezed
sealed class Storage with _$Storage {
  const factory Storage({
    /// Pool id (`storage` in PVE JSON).
    @JsonKey(name: 'storage') required String id,
    required String node,
    @JsonKey(fromJson: proxmoxString) @Default('') String type,
    @JsonKey(name: 'content', fromJson: storageContentKindsFromJson)
    @Default([])
    List<String> content,
    @JsonKey(fromJson: proxmoxInt) int? total,
    @JsonKey(fromJson: proxmoxInt) int? used,
    @JsonKey(name: 'avail', fromJson: proxmoxInt) int? available,
    @JsonKey(fromJson: storageActiveFromJson) @Default(false) bool active,
  }) = _Storage;

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);

  /// Row from [GET /nodes/{node}/storage]; [node] is injected.
  factory Storage.fromNodeStorageListRow(
    Map<String, dynamic> json, {
    required String node,
  }) {
    final m = Map<String, dynamic>.from(json);
    m['node'] = node;
    return Storage.fromJson(m);
  }
}
