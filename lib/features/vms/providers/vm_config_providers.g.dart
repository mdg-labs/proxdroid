// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$qemuVmConfigHash() => r'ab1e87d812a60414b89cf73a0e79c470fc5467c3';

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

/// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
///
/// Copied from [qemuVmConfig].
@ProviderFor(qemuVmConfig)
const qemuVmConfigProvider = QemuVmConfigFamily();

/// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
///
/// Copied from [qemuVmConfig].
class QemuVmConfigFamily extends Family<AsyncValue<QemuVmConfig>> {
  /// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
  ///
  /// Copied from [qemuVmConfig].
  const QemuVmConfigFamily();

  /// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
  ///
  /// Copied from [qemuVmConfig].
  QemuVmConfigProvider call(String node, int vmid) {
    return QemuVmConfigProvider(node, vmid);
  }

  @override
  QemuVmConfigProvider getProviderOverride(
    covariant QemuVmConfigProvider provider,
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
  String? get name => r'qemuVmConfigProvider';
}

/// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
///
/// Copied from [qemuVmConfig].
class QemuVmConfigProvider extends AutoDisposeFutureProvider<QemuVmConfig> {
  /// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
  ///
  /// Copied from [qemuVmConfig].
  QemuVmConfigProvider(String node, int vmid)
    : this._internal(
        (ref) => qemuVmConfig(ref as QemuVmConfigRef, node, vmid),
        from: qemuVmConfigProvider,
        name: r'qemuVmConfigProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$qemuVmConfigHash,
        dependencies: QemuVmConfigFamily._dependencies,
        allTransitiveDependencies:
            QemuVmConfigFamily._allTransitiveDependencies,
        node: node,
        vmid: vmid,
      );

  QemuVmConfigProvider._internal(
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
    FutureOr<QemuVmConfig> Function(QemuVmConfigRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QemuVmConfigProvider._internal(
        (ref) => create(ref as QemuVmConfigRef),
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
  AutoDisposeFutureProviderElement<QemuVmConfig> createElement() {
    return _QemuVmConfigProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QemuVmConfigProvider &&
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
mixin QemuVmConfigRef on AutoDisposeFutureProviderRef<QemuVmConfig> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `vmid` of this provider.
  int get vmid;
}

class _QemuVmConfigProviderElement
    extends AutoDisposeFutureProviderElement<QemuVmConfig>
    with QemuVmConfigRef {
  _QemuVmConfigProviderElement(super.provider);

  @override
  String get node => (origin as QemuVmConfigProvider).node;
  @override
  int get vmid => (origin as QemuVmConfigProvider).vmid;
}

String _$qemuVmConfigEditorHash() =>
    r'fbe7792273b48e81db7f6a93a9f4af9cd45fe656';

abstract class _$QemuVmConfigEditor
    extends BuildlessAutoDisposeAsyncNotifier<QemuVmConfigEditState> {
  late final String node;
  late final int vmid;

  FutureOr<QemuVmConfigEditState> build(String node, int vmid);
}

/// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
///
/// Copied from [QemuVmConfigEditor].
@ProviderFor(QemuVmConfigEditor)
const qemuVmConfigEditorProvider = QemuVmConfigEditorFamily();

/// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
///
/// Copied from [QemuVmConfigEditor].
class QemuVmConfigEditorFamily
    extends Family<AsyncValue<QemuVmConfigEditState>> {
  /// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
  ///
  /// Copied from [QemuVmConfigEditor].
  const QemuVmConfigEditorFamily();

  /// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
  ///
  /// Copied from [QemuVmConfigEditor].
  QemuVmConfigEditorProvider call(String node, int vmid) {
    return QemuVmConfigEditorProvider(node, vmid);
  }

  @override
  QemuVmConfigEditorProvider getProviderOverride(
    covariant QemuVmConfigEditorProvider provider,
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
  String? get name => r'qemuVmConfigEditorProvider';
}

/// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
///
/// Copied from [QemuVmConfigEditor].
class QemuVmConfigEditorProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          QemuVmConfigEditor,
          QemuVmConfigEditState
        > {
  /// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
  ///
  /// Copied from [QemuVmConfigEditor].
  QemuVmConfigEditorProvider(String node, int vmid)
    : this._internal(
        () =>
            QemuVmConfigEditor()
              ..node = node
              ..vmid = vmid,
        from: qemuVmConfigEditorProvider,
        name: r'qemuVmConfigEditorProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$qemuVmConfigEditorHash,
        dependencies: QemuVmConfigEditorFamily._dependencies,
        allTransitiveDependencies:
            QemuVmConfigEditorFamily._allTransitiveDependencies,
        node: node,
        vmid: vmid,
      );

  QemuVmConfigEditorProvider._internal(
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
  FutureOr<QemuVmConfigEditState> runNotifierBuild(
    covariant QemuVmConfigEditor notifier,
  ) {
    return notifier.build(node, vmid);
  }

  @override
  Override overrideWith(QemuVmConfigEditor Function() create) {
    return ProviderOverride(
      origin: this,
      override: QemuVmConfigEditorProvider._internal(
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
    QemuVmConfigEditor,
    QemuVmConfigEditState
  >
  createElement() {
    return _QemuVmConfigEditorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QemuVmConfigEditorProvider &&
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
mixin QemuVmConfigEditorRef
    on AutoDisposeAsyncNotifierProviderRef<QemuVmConfigEditState> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `vmid` of this provider.
  int get vmid;
}

class _QemuVmConfigEditorProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          QemuVmConfigEditor,
          QemuVmConfigEditState
        >
    with QemuVmConfigEditorRef {
  _QemuVmConfigEditorProviderElement(super.provider);

  @override
  String get node => (origin as QemuVmConfigEditorProvider).node;
  @override
  int get vmid => (origin as QemuVmConfigEditorProvider).vmid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
