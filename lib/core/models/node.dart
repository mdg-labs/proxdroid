import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';

/// Cluster node summary; values are filled from the Proxmox API in Phase 2.
@freezed
sealed class Node with _$Node {
  const factory Node({
    required String name,
    String? status,
    double? cpu,
    int? maxCpu,
    int? mem,
    int? maxMem,
    int? uptime,
  }) = _Node;
}
