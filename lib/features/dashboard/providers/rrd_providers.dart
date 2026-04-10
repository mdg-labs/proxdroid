import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/data/rrd_repository.dart';
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
