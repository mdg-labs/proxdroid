// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nodeRepositoryHash() => r'd6affbd13b4c576860c02ba694d8b9cd50215aad';

/// See also [nodeRepository].
@ProviderFor(nodeRepository)
final nodeRepositoryProvider =
    AutoDisposeFutureProvider<NodeRepository?>.internal(
      nodeRepository,
      name: r'nodeRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nodeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeRepositoryRef = AutoDisposeFutureProviderRef<NodeRepository?>;
String _$dashboardRepositoryHash() =>
    r'dfb222089a8c81ef2f45b78e5cf9bd8e569de926';

/// See also [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeFutureProvider<DashboardRepository?>.internal(
      dashboardRepository,
      name: r'dashboardRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dashboardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef =
    AutoDisposeFutureProviderRef<DashboardRepository?>;
String _$nodeDetailStatusHash() => r'58a11dc0c32d8fb382c5308162d9a6a45987a878';

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

/// Live fields from `GET /nodes/{node}/status` for the node detail grid.
///
/// Returns `null` when no API client is configured (should not happen on
/// `/dashboard/:node` due to router redirect).
///
/// Copied from [nodeDetailStatus].
@ProviderFor(nodeDetailStatus)
const nodeDetailStatusProvider = NodeDetailStatusFamily();

/// Live fields from `GET /nodes/{node}/status` for the node detail grid.
///
/// Returns `null` when no API client is configured (should not happen on
/// `/dashboard/:node` due to router redirect).
///
/// Copied from [nodeDetailStatus].
class NodeDetailStatusFamily extends Family<AsyncValue<Node?>> {
  /// Live fields from `GET /nodes/{node}/status` for the node detail grid.
  ///
  /// Returns `null` when no API client is configured (should not happen on
  /// `/dashboard/:node` due to router redirect).
  ///
  /// Copied from [nodeDetailStatus].
  const NodeDetailStatusFamily();

  /// Live fields from `GET /nodes/{node}/status` for the node detail grid.
  ///
  /// Returns `null` when no API client is configured (should not happen on
  /// `/dashboard/:node` due to router redirect).
  ///
  /// Copied from [nodeDetailStatus].
  NodeDetailStatusProvider call(String nodeName) {
    return NodeDetailStatusProvider(nodeName);
  }

  @override
  NodeDetailStatusProvider getProviderOverride(
    covariant NodeDetailStatusProvider provider,
  ) {
    return call(provider.nodeName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nodeDetailStatusProvider';
}

/// Live fields from `GET /nodes/{node}/status` for the node detail grid.
///
/// Returns `null` when no API client is configured (should not happen on
/// `/dashboard/:node` due to router redirect).
///
/// Copied from [nodeDetailStatus].
class NodeDetailStatusProvider extends AutoDisposeFutureProvider<Node?> {
  /// Live fields from `GET /nodes/{node}/status` for the node detail grid.
  ///
  /// Returns `null` when no API client is configured (should not happen on
  /// `/dashboard/:node` due to router redirect).
  ///
  /// Copied from [nodeDetailStatus].
  NodeDetailStatusProvider(String nodeName)
    : this._internal(
        (ref) => nodeDetailStatus(ref as NodeDetailStatusRef, nodeName),
        from: nodeDetailStatusProvider,
        name: r'nodeDetailStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$nodeDetailStatusHash,
        dependencies: NodeDetailStatusFamily._dependencies,
        allTransitiveDependencies:
            NodeDetailStatusFamily._allTransitiveDependencies,
        nodeName: nodeName,
      );

  NodeDetailStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nodeName,
  }) : super.internal();

  final String nodeName;

  @override
  Override overrideWith(
    FutureOr<Node?> Function(NodeDetailStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NodeDetailStatusProvider._internal(
        (ref) => create(ref as NodeDetailStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nodeName: nodeName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Node?> createElement() {
    return _NodeDetailStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodeDetailStatusProvider && other.nodeName == nodeName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nodeName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NodeDetailStatusRef on AutoDisposeFutureProviderRef<Node?> {
  /// The parameter `nodeName` of this provider.
  String get nodeName;
}

class _NodeDetailStatusProviderElement
    extends AutoDisposeFutureProviderElement<Node?>
    with NodeDetailStatusRef {
  _NodeDetailStatusProviderElement(super.provider);

  @override
  String get nodeName => (origin as NodeDetailStatusProvider).nodeName;
}

String _$nodeNetworkBridgesHash() =>
    r'9f742c9a508af4bbd35bd986092678a690d37839';

/// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
///
/// Copied from [nodeNetworkBridges].
@ProviderFor(nodeNetworkBridges)
const nodeNetworkBridgesProvider = NodeNetworkBridgesFamily();

/// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
///
/// Copied from [nodeNetworkBridges].
class NodeNetworkBridgesFamily
    extends Family<AsyncValue<List<NodeNetworkIface>>> {
  /// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
  ///
  /// Copied from [nodeNetworkBridges].
  const NodeNetworkBridgesFamily();

  /// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
  ///
  /// Copied from [nodeNetworkBridges].
  NodeNetworkBridgesProvider call(String node) {
    return NodeNetworkBridgesProvider(node);
  }

  @override
  NodeNetworkBridgesProvider getProviderOverride(
    covariant NodeNetworkBridgesProvider provider,
  ) {
    return call(provider.node);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nodeNetworkBridgesProvider';
}

/// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
///
/// Copied from [nodeNetworkBridges].
class NodeNetworkBridgesProvider
    extends AutoDisposeFutureProvider<List<NodeNetworkIface>> {
  /// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
  ///
  /// Copied from [nodeNetworkBridges].
  NodeNetworkBridgesProvider(String node)
    : this._internal(
        (ref) => nodeNetworkBridges(ref as NodeNetworkBridgesRef, node),
        from: nodeNetworkBridgesProvider,
        name: r'nodeNetworkBridgesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$nodeNetworkBridgesHash,
        dependencies: NodeNetworkBridgesFamily._dependencies,
        allTransitiveDependencies:
            NodeNetworkBridgesFamily._allTransitiveDependencies,
        node: node,
      );

  NodeNetworkBridgesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
  }) : super.internal();

  final String node;

  @override
  Override overrideWith(
    FutureOr<List<NodeNetworkIface>> Function(NodeNetworkBridgesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NodeNetworkBridgesProvider._internal(
        (ref) => create(ref as NodeNetworkBridgesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NodeNetworkIface>> createElement() {
    return _NodeNetworkBridgesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NodeNetworkBridgesProvider && other.node == node;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NodeNetworkBridgesRef
    on AutoDisposeFutureProviderRef<List<NodeNetworkIface>> {
  /// The parameter `node` of this provider.
  String get node;
}

class _NodeNetworkBridgesProviderElement
    extends AutoDisposeFutureProviderElement<List<NodeNetworkIface>>
    with NodeNetworkBridgesRef {
  _NodeNetworkBridgesProviderElement(super.provider);

  @override
  String get node => (origin as NodeNetworkBridgesProvider).node;
}

String _$nodeListHash() => r'b1c4e0dee31c90b945eda8d16422ff02f1dd84e2';

/// Cluster node list (`nodeListProvider`). Pull-to-refresh:
/// `ref.read(nodeListProvider.notifier).refresh()`.
///
/// Copied from [NodeList].
@ProviderFor(NodeList)
final nodeListProvider =
    AutoDisposeAsyncNotifierProvider<NodeList, List<Node>>.internal(
      NodeList.new,
      name: r'nodeListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$nodeListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NodeList = AutoDisposeAsyncNotifier<List<Node>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
