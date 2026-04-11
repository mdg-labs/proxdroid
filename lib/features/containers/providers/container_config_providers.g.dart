// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lxcContainerConfigHash() =>
    r'f7b1444457e709e1712246d38823130e19fa8922';

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

/// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
///
/// Copied from [lxcContainerConfig].
@ProviderFor(lxcContainerConfig)
const lxcContainerConfigProvider = LxcContainerConfigFamily();

/// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
///
/// Copied from [lxcContainerConfig].
class LxcContainerConfigFamily extends Family<AsyncValue<LxcContainerConfig>> {
  /// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
  ///
  /// Copied from [lxcContainerConfig].
  const LxcContainerConfigFamily();

  /// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
  ///
  /// Copied from [lxcContainerConfig].
  LxcContainerConfigProvider call(String node, int vmid) {
    return LxcContainerConfigProvider(node, vmid);
  }

  @override
  LxcContainerConfigProvider getProviderOverride(
    covariant LxcContainerConfigProvider provider,
  ) {
    return call(provider.node, provider.vmid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lxcContainerConfigProvider';
}

/// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
///
/// Copied from [lxcContainerConfig].
class LxcContainerConfigProvider
    extends AutoDisposeFutureProvider<LxcContainerConfig> {
  /// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
  ///
  /// Copied from [lxcContainerConfig].
  LxcContainerConfigProvider(String node, int vmid)
    : this._internal(
        (ref) => lxcContainerConfig(ref as LxcContainerConfigRef, node, vmid),
        from: lxcContainerConfigProvider,
        name: r'lxcContainerConfigProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lxcContainerConfigHash,
        dependencies: LxcContainerConfigFamily._dependencies,
        allTransitiveDependencies:
            LxcContainerConfigFamily._allTransitiveDependencies,
        node: node,
        vmid: vmid,
      );

  LxcContainerConfigProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.vmid,
  }) : super.internal();

  final String node;
  final int vmid;

  @override
  Override overrideWith(
    FutureOr<LxcContainerConfig> Function(LxcContainerConfigRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LxcContainerConfigProvider._internal(
        (ref) => create(ref as LxcContainerConfigRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        vmid: vmid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LxcContainerConfig> createElement() {
    return _LxcContainerConfigProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LxcContainerConfigProvider &&
        other.node == node &&
        other.vmid == vmid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, vmid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LxcContainerConfigRef
    on AutoDisposeFutureProviderRef<LxcContainerConfig> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `vmid` of this provider.
  int get vmid;
}

class _LxcContainerConfigProviderElement
    extends AutoDisposeFutureProviderElement<LxcContainerConfig>
    with LxcContainerConfigRef {
  _LxcContainerConfigProviderElement(super.provider);

  @override
  String get node => (origin as LxcContainerConfigProvider).node;
  @override
  int get vmid => (origin as LxcContainerConfigProvider).vmid;
}

String _$lxcContainerConfigEditorHash() =>
    r'0951319ccd4d6b7cbddf333694c71c1fce27ac11';

abstract class _$LxcContainerConfigEditor
    extends BuildlessAutoDisposeAsyncNotifier<LxcContainerConfigEditState> {
  late final String node;
  late final int vmid;

  FutureOr<LxcContainerConfigEditState> build(String node, int vmid);
}

/// See also [LxcContainerConfigEditor].
@ProviderFor(LxcContainerConfigEditor)
const lxcContainerConfigEditorProvider = LxcContainerConfigEditorFamily();

/// See also [LxcContainerConfigEditor].
class LxcContainerConfigEditorFamily
    extends Family<AsyncValue<LxcContainerConfigEditState>> {
  /// See also [LxcContainerConfigEditor].
  const LxcContainerConfigEditorFamily();

  /// See also [LxcContainerConfigEditor].
  LxcContainerConfigEditorProvider call(String node, int vmid) {
    return LxcContainerConfigEditorProvider(node, vmid);
  }

  @override
  LxcContainerConfigEditorProvider getProviderOverride(
    covariant LxcContainerConfigEditorProvider provider,
  ) {
    return call(provider.node, provider.vmid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lxcContainerConfigEditorProvider';
}

/// See also [LxcContainerConfigEditor].
class LxcContainerConfigEditorProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LxcContainerConfigEditor,
          LxcContainerConfigEditState
        > {
  /// See also [LxcContainerConfigEditor].
  LxcContainerConfigEditorProvider(String node, int vmid)
    : this._internal(
        () =>
            LxcContainerConfigEditor()
              ..node = node
              ..vmid = vmid,
        from: lxcContainerConfigEditorProvider,
        name: r'lxcContainerConfigEditorProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lxcContainerConfigEditorHash,
        dependencies: LxcContainerConfigEditorFamily._dependencies,
        allTransitiveDependencies:
            LxcContainerConfigEditorFamily._allTransitiveDependencies,
        node: node,
        vmid: vmid,
      );

  LxcContainerConfigEditorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.vmid,
  }) : super.internal();

  final String node;
  final int vmid;

  @override
  FutureOr<LxcContainerConfigEditState> runNotifierBuild(
    covariant LxcContainerConfigEditor notifier,
  ) {
    return notifier.build(node, vmid);
  }

  @override
  Override overrideWith(LxcContainerConfigEditor Function() create) {
    return ProviderOverride(
      origin: this,
      override: LxcContainerConfigEditorProvider._internal(
        () =>
            create()
              ..node = node
              ..vmid = vmid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        vmid: vmid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    LxcContainerConfigEditor,
    LxcContainerConfigEditState
  >
  createElement() {
    return _LxcContainerConfigEditorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LxcContainerConfigEditorProvider &&
        other.node == node &&
        other.vmid == vmid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, vmid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LxcContainerConfigEditorRef
    on AutoDisposeAsyncNotifierProviderRef<LxcContainerConfigEditState> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `vmid` of this provider.
  int get vmid;
}

class _LxcContainerConfigEditorProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LxcContainerConfigEditor,
          LxcContainerConfigEditState
        >
    with LxcContainerConfigEditorRef {
  _LxcContainerConfigEditorProviderElement(super.provider);

  @override
  String get node => (origin as LxcContainerConfigEditorProvider).node;
  @override
  int get vmid => (origin as LxcContainerConfigEditorProvider).vmid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
