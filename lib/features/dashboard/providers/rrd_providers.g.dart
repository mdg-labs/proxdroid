// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rrd_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rrdRepositoryHash() => r'0d2789e007b7ee08ff09c205a26abadaac1d1654';

/// See also [rrdRepository].
@ProviderFor(rrdRepository)
final rrdRepositoryProvider =
    AutoDisposeFutureProvider<RrdRepository?>.internal(
      rrdRepository,
      name: r'rrdRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$rrdRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RrdRepositoryRef = AutoDisposeFutureProviderRef<RrdRepository?>;
String _$vmRrdDataHash() => r'05c838034728e90039144f7d1dfa77799ab5a83e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VmRrdData
    extends BuildlessAutoDisposeAsyncNotifier<List<ResourceDataPoint>> {
  late final String node;
  late final int vmid;
  late final ChartTimeframe timeframe;

  FutureOr<List<ResourceDataPoint>> build(
    String node,
    int vmid,
    ChartTimeframe timeframe,
  );
}

/// QEMU guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
/// are typically ~60s apart, so faster polling adds little value.
///
/// Copied from [VmRrdData].
@ProviderFor(VmRrdData)
const vmRrdDataProvider = VmRrdDataFamily();

/// QEMU guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
/// are typically ~60s apart, so faster polling adds little value.
///
/// Copied from [VmRrdData].
class VmRrdDataFamily extends Family<AsyncValue<List<ResourceDataPoint>>> {
  /// QEMU guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
  /// are typically ~60s apart, so faster polling adds little value.
  ///
  /// Copied from [VmRrdData].
  const VmRrdDataFamily();

  /// QEMU guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
  /// are typically ~60s apart, so faster polling adds little value.
  ///
  /// Copied from [VmRrdData].
  VmRrdDataProvider call(String node, int vmid, ChartTimeframe timeframe) {
    return VmRrdDataProvider(node, vmid, timeframe);
  }

  @override
  VmRrdDataProvider getProviderOverride(covariant VmRrdDataProvider provider) {
    return call(provider.node, provider.vmid, provider.timeframe);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vmRrdDataProvider';
}

/// QEMU guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
/// are typically ~60s apart, so faster polling adds little value.
///
/// Copied from [VmRrdData].
class VmRrdDataProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VmRrdData,
          List<ResourceDataPoint>
        > {
  /// QEMU guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to — Proxmox rrddata points
  /// are typically ~60s apart, so faster polling adds little value.
  ///
  /// Copied from [VmRrdData].
  VmRrdDataProvider(String node, int vmid, ChartTimeframe timeframe)
    : this._internal(
        () =>
            VmRrdData()
              ..node = node
              ..vmid = vmid
              ..timeframe = timeframe,
        from: vmRrdDataProvider,
        name: r'vmRrdDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$vmRrdDataHash,
        dependencies: VmRrdDataFamily._dependencies,
        allTransitiveDependencies: VmRrdDataFamily._allTransitiveDependencies,
        node: node,
        vmid: vmid,
        timeframe: timeframe,
      );

  VmRrdDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.vmid,
    required this.timeframe,
  }) : super.internal();

  final String node;
  final int vmid;
  final ChartTimeframe timeframe;

  @override
  FutureOr<List<ResourceDataPoint>> runNotifierBuild(
    covariant VmRrdData notifier,
  ) {
    return notifier.build(node, vmid, timeframe);
  }

  @override
  Override overrideWith(VmRrdData Function() create) {
    return ProviderOverride(
      origin: this,
      override: VmRrdDataProvider._internal(
        () =>
            create()
              ..node = node
              ..vmid = vmid
              ..timeframe = timeframe,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        vmid: vmid,
        timeframe: timeframe,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VmRrdData, List<ResourceDataPoint>>
  createElement() {
    return _VmRrdDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VmRrdDataProvider &&
        other.node == node &&
        other.vmid == vmid &&
        other.timeframe == timeframe;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, vmid.hashCode);
    hash = _SystemHash.combine(hash, timeframe.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VmRrdDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<ResourceDataPoint>> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `vmid` of this provider.
  int get vmid;

  /// The parameter `timeframe` of this provider.
  ChartTimeframe get timeframe;
}

class _VmRrdDataProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VmRrdData,
          List<ResourceDataPoint>
        >
    with VmRrdDataRef {
  _VmRrdDataProviderElement(super.provider);

  @override
  String get node => (origin as VmRrdDataProvider).node;
  @override
  int get vmid => (origin as VmRrdDataProvider).vmid;
  @override
  ChartTimeframe get timeframe => (origin as VmRrdDataProvider).timeframe;
}

String _$lxcRrdDataHash() => r'5d8020c3f00ea9d645f5d4f9889c51a4388b6ef8';

abstract class _$LxcRrdData
    extends BuildlessAutoDisposeAsyncNotifier<List<ResourceDataPoint>> {
  late final String node;
  late final int ctid;
  late final ChartTimeframe timeframe;

  FutureOr<List<ResourceDataPoint>> build(
    String node,
    int ctid,
    ChartTimeframe timeframe,
  );
}

/// LXC guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [LxcRrdData].
@ProviderFor(LxcRrdData)
const lxcRrdDataProvider = LxcRrdDataFamily();

/// LXC guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [LxcRrdData].
class LxcRrdDataFamily extends Family<AsyncValue<List<ResourceDataPoint>>> {
  /// LXC guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [LxcRrdData].
  const LxcRrdDataFamily();

  /// LXC guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [LxcRrdData].
  LxcRrdDataProvider call(String node, int ctid, ChartTimeframe timeframe) {
    return LxcRrdDataProvider(node, ctid, timeframe);
  }

  @override
  LxcRrdDataProvider getProviderOverride(
    covariant LxcRrdDataProvider provider,
  ) {
    return call(provider.node, provider.ctid, provider.timeframe);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lxcRrdDataProvider';
}

/// LXC guest RRD series for charts.
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [LxcRrdData].
class LxcRrdDataProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LxcRrdData,
          List<ResourceDataPoint>
        > {
  /// LXC guest RRD series for charts.
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [LxcRrdData].
  LxcRrdDataProvider(String node, int ctid, ChartTimeframe timeframe)
    : this._internal(
        () =>
            LxcRrdData()
              ..node = node
              ..ctid = ctid
              ..timeframe = timeframe,
        from: lxcRrdDataProvider,
        name: r'lxcRrdDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lxcRrdDataHash,
        dependencies: LxcRrdDataFamily._dependencies,
        allTransitiveDependencies: LxcRrdDataFamily._allTransitiveDependencies,
        node: node,
        ctid: ctid,
        timeframe: timeframe,
      );

  LxcRrdDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.ctid,
    required this.timeframe,
  }) : super.internal();

  final String node;
  final int ctid;
  final ChartTimeframe timeframe;

  @override
  FutureOr<List<ResourceDataPoint>> runNotifierBuild(
    covariant LxcRrdData notifier,
  ) {
    return notifier.build(node, ctid, timeframe);
  }

  @override
  Override overrideWith(LxcRrdData Function() create) {
    return ProviderOverride(
      origin: this,
      override: LxcRrdDataProvider._internal(
        () =>
            create()
              ..node = node
              ..ctid = ctid
              ..timeframe = timeframe,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        ctid: ctid,
        timeframe: timeframe,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LxcRrdData, List<ResourceDataPoint>>
  createElement() {
    return _LxcRrdDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LxcRrdDataProvider &&
        other.node == node &&
        other.ctid == ctid &&
        other.timeframe == timeframe;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, ctid.hashCode);
    hash = _SystemHash.combine(hash, timeframe.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LxcRrdDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<ResourceDataPoint>> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `ctid` of this provider.
  int get ctid;

  /// The parameter `timeframe` of this provider.
  ChartTimeframe get timeframe;
}

class _LxcRrdDataProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LxcRrdData,
          List<ResourceDataPoint>
        >
    with LxcRrdDataRef {
  _LxcRrdDataProviderElement(super.provider);

  @override
  String get node => (origin as LxcRrdDataProvider).node;
  @override
  int get ctid => (origin as LxcRrdDataProvider).ctid;
  @override
  ChartTimeframe get timeframe => (origin as LxcRrdDataProvider).timeframe;
}

String _$nodeRrdDataHash() => r'd885df1293b63d552ac243bea13ab6f5d27a95da';

abstract class _$NodeRrdData
    extends BuildlessAutoDisposeAsyncNotifier<List<ResourceDataPoint>> {
  late final String node;
  late final ChartTimeframe timeframe;

  FutureOr<List<ResourceDataPoint>> build(
    String node,
    ChartTimeframe timeframe,
  );
}

/// Node-level RRD series (dashboard compact charts).
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [NodeRrdData].
@ProviderFor(NodeRrdData)
const nodeRrdDataProvider = NodeRrdDataFamily();

/// Node-level RRD series (dashboard compact charts).
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [NodeRrdData].
class NodeRrdDataFamily extends Family<AsyncValue<List<ResourceDataPoint>>> {
  /// Node-level RRD series (dashboard compact charts).
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [NodeRrdData].
  const NodeRrdDataFamily();

  /// Node-level RRD series (dashboard compact charts).
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [NodeRrdData].
  NodeRrdDataProvider call(String node, ChartTimeframe timeframe) {
    return NodeRrdDataProvider(node, timeframe);
  }

  @override
  NodeRrdDataProvider getProviderOverride(
    covariant NodeRrdDataProvider provider,
  ) {
    return call(provider.node, provider.timeframe);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nodeRrdDataProvider';
}

/// Node-level RRD series (dashboard compact charts).
///
/// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
///
/// Copied from [NodeRrdData].
class NodeRrdDataProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NodeRrdData,
          List<ResourceDataPoint>
        > {
  /// Node-level RRD series (dashboard compact charts).
  ///
  /// Re-fetches every **60 seconds** while listened to (see [VmRrdData]).
  ///
  /// Copied from [NodeRrdData].
  NodeRrdDataProvider(String node, ChartTimeframe timeframe)
    : this._internal(
        () =>
            NodeRrdData()
              ..node = node
              ..timeframe = timeframe,
        from: nodeRrdDataProvider,
        name: r'nodeRrdDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$nodeRrdDataHash,
        dependencies: NodeRrdDataFamily._dependencies,
        allTransitiveDependencies: NodeRrdDataFamily._allTransitiveDependencies,
        node: node,
        timeframe: timeframe,
      );

  NodeRrdDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.timeframe,
  }) : super.internal();

  final String node;
  final ChartTimeframe timeframe;

  @override
  FutureOr<List<ResourceDataPoint>> runNotifierBuild(
    covariant NodeRrdData notifier,
  ) {
    return notifier.build(node, timeframe);
  }

  @override
  Override overrideWith(NodeRrdData Function() create) {
    return ProviderOverride(
      origin: this,
      override: NodeRrdDataProvider._internal(
        () =>
            create()
              ..node = node
              ..timeframe = timeframe,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        timeframe: timeframe,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NodeRrdData, List<ResourceDataPoint>>
  createElement() {
    return _NodeRrdDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodeRrdDataProvider &&
        other.node == node &&
        other.timeframe == timeframe;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, timeframe.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NodeRrdDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<ResourceDataPoint>> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `timeframe` of this provider.
  ChartTimeframe get timeframe;
}

class _NodeRrdDataProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NodeRrdData,
          List<ResourceDataPoint>
        >
    with NodeRrdDataRef {
  _NodeRrdDataProviderElement(super.provider);

  @override
  String get node => (origin as NodeRrdDataProvider).node;
  @override
  ChartTimeframe get timeframe => (origin as NodeRrdDataProvider).timeframe;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
