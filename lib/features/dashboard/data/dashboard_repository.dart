import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/features/dashboard/data/node_repository.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';

/// Thin composition of feature repositories for dashboard-oriented reads.
///
/// Does not call [Dio] or duplicate API paths — only delegates to the injected
/// repositories (Phase 2.4 can add aggregations here without new endpoints).
class DashboardRepository {
  DashboardRepository(this._nodes, this._vms, this._containers);

  final NodeRepository _nodes;
  final VmRepository _vms;
  final ContainerRepository _containers;

  Future<List<Node>> getNodes() => _nodes.getNodes();

  Future<List<Vm>> getAllVms() => _vms.getAllVms();

  Future<List<Container>> getAllContainers() => _containers.getAllContainers();
}
