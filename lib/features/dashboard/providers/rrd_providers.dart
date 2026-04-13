import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/data/rrd_repository.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';

part 'rrd_providers.g.dart';

@riverpod
Future<RrdRepository?> rrdRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) {
    return null;
  }
  return RrdRepository(client);
}

/// QEMU guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
/// are typically ~60s apart, so faster polling adds little value.
@riverpod
class VmRrdData extends _$VmRrdData {
  @override
  Future<List<ResourceDataPoint>> build(
    String node,
    int vmid,
    ChartTimeframe timeframe,
  ) async {
    final timer = Timer.periodic(const Duration(seconds: 60), (_) {
      ref.invalidateSelf();
    });
    ref.onDispose(timer.cancel);

    final repo = await ref.watch(rrdRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }
    return repo.getVmRrd(node, vmid, timeframe);
  }
}

/// LXC guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
@riverpod
class LxcRrdData extends _$LxcRrdData {
  @override
  Future<List<ResourceDataPoint>> build(
    String node,
    int ctid,
    ChartTimeframe timeframe,
  ) async {
    final timer = Timer.periodic(const Duration(seconds: 60), (_) {
      ref.invalidateSelf();
    });
    ref.onDispose(timer.cancel);

    final repo = await ref.watch(rrdRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }
    return repo.getLxcRrd(node, ctid, timeframe);
  }
}

/// Node-level RRD series (dashboard compact charts).
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
@riverpod
class NodeRrdData extends _$NodeRrdData {
  @override
  Future<List<ResourceDataPoint>> build(
    String node,
    ChartTimeframe timeframe,
  ) async {
    final timer = Timer.periodic(const Duration(seconds: 60), (_) {
      ref.invalidateSelf();
    });
    ref.onDispose(timer.cancel);

    final repo = await ref.watch(rrdRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }
    return repo.getNodeRrd(node, timeframe);
  }
}

/// Normalizes RRD CPU samples to a 0–1 style utilization (matches chart layer).
double _normClusterCpuSample(double raw) => raw > 1.5 ? raw / 100.0 : raw;

/// Merges per-node RRD lists **by sample index** (same [ChartTimeframe] and
/// Proxmox ordering yields aligned rows). CPU = mean of available node CPU
/// values; memory = sum of available node `mem` bytes (cluster total).
List<ResourceDataPoint> mergeClusterNodeRrdByIndex(
  List<List<ResourceDataPoint>> series,
) {
  if (series.isEmpty) {
    return const [];
  }
  final nonempty = series.where((s) => s.isNotEmpty).toList();
  if (nonempty.isEmpty) {
    return const [];
  }
  var minLen = nonempty.first.length;
  for (final s in nonempty) {
    if (s.length < minLen) {
      minLen = s.length;
    }
  }
  if (minLen == 0) {
    return const [];
  }
  final out = <ResourceDataPoint>[];
  for (var i = 0; i < minLen; i++) {
    var ts = nonempty.first[i].timestamp;
    var cpuSum = 0.0;
    var cpuCount = 0;
    double memSum = 0;
    var memCount = 0;
    for (final s in nonempty) {
      final p = s[i];
      ts = p.timestamp;
      final c = p.cpu;
      if (c != null) {
        cpuSum += _normClusterCpuSample(c);
        cpuCount++;
      }
      final m = p.mem;
      if (m != null) {
        memSum += m;
        memCount++;
      }
    }
    out.add(
      ResourceDataPoint(
        timestamp: ts,
        cpu: cpuCount > 0 ? cpuSum / cpuCount : null,
        mem: memCount > 0 ? memSum : null,
      ),
    );
  }
  return out;
}

/// Dashboard cluster CPU/RAM chart: one rrddata fetch per **online** node,
/// merged with [mergeClusterNodeRrdByIndex]. Failed nodes are skipped
/// (partial cluster). Refreshes every 60s like [NodeRrdData].
@riverpod
class ClusterAggregatedNodeRrd extends _$ClusterAggregatedNodeRrd {
  @override
  Future<List<ResourceDataPoint>> build(ChartTimeframe timeframe) async {
    final timer = Timer.periodic(const Duration(seconds: 60), (_) {
      ref.invalidateSelf();
    });
    ref.onDispose(timer.cancel);

    final nodes = await ref.watch(nodeListProvider.future);
    final onlineNames =
        nodes
            .where((n) => (n.status ?? '').toLowerCase() == 'online')
            .map((n) => n.name)
            .toList();
    if (onlineNames.isEmpty) {
      return const [];
    }

    final repo = await ref.watch(rrdRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }

    final series = <List<ResourceDataPoint>>[];
    for (final name in onlineNames) {
      try {
        final pts = await repo.getNodeRrd(name, timeframe);
        if (pts.isNotEmpty) {
          series.add(pts);
        }
      } on Object {
        // Skip nodes that error; remaining nodes still form a real partial series.
      }
    }
    return mergeClusterNodeRrdByIndex(series);
  }
}
