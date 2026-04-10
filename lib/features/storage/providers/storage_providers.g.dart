// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storageRepositoryHash() => r'8575ceb99eb14152e264737c8ee8112f0666bf80';

/// See also [storageRepository].
@ProviderFor(storageRepository)
final storageRepositoryProvider =
    AutoDisposeFutureProvider<StorageRepository?>.internal(
      storageRepository,
      name: r'storageRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$storageRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageRepositoryRef = AutoDisposeFutureProviderRef<StorageRepository?>;
String _$storageDetailHash() => r'396e8358cbb4fc44832e166654661223930f36d7';

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

/// Status row for a single pool (detail header).
///
/// Copied from [storageDetail].
@ProviderFor(storageDetail)
const storageDetailProvider = StorageDetailFamily();

/// Status row for a single pool (detail header).
///
/// Copied from [storageDetail].
class StorageDetailFamily extends Family<AsyncValue<Storage>> {
  /// Status row for a single pool (detail header).
  ///
  /// Copied from [storageDetail].
  const StorageDetailFamily();

  /// Status row for a single pool (detail header).
  ///
  /// Copied from [storageDetail].
  StorageDetailProvider call(String node, String storageId) {
    return StorageDetailProvider(node, storageId);
  }

  @override
  StorageDetailProvider getProviderOverride(
    covariant StorageDetailProvider provider,
  ) {
    return call(provider.node, provider.storageId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storageDetailProvider';
}

/// Status row for a single pool (detail header).
///
/// Copied from [storageDetail].
class StorageDetailProvider extends AutoDisposeFutureProvider<Storage> {
  /// Status row for a single pool (detail header).
  ///
  /// Copied from [storageDetail].
  StorageDetailProvider(String node, String storageId)
    : this._internal(
        (ref) => storageDetail(ref as StorageDetailRef, node, storageId),
        from: storageDetailProvider,
        name: r'storageDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$storageDetailHash,
        dependencies: StorageDetailFamily._dependencies,
        allTransitiveDependencies:
            StorageDetailFamily._allTransitiveDependencies,
        node: node,
        storageId: storageId,
      );

  StorageDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.storageId,
  }) : super.internal();

  final String node;
  final String storageId;

  @override
  Override overrideWith(
    FutureOr<Storage> Function(StorageDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StorageDetailProvider._internal(
        (ref) => create(ref as StorageDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        storageId: storageId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Storage> createElement() {
    return _StorageDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StorageDetailProvider &&
        other.node == node &&
        other.storageId == storageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, storageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StorageDetailRef on AutoDisposeFutureProviderRef<Storage> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `storageId` of this provider.
  String get storageId;
}

class _StorageDetailProviderElement
    extends AutoDisposeFutureProviderElement<Storage>
    with StorageDetailRef {
  _StorageDetailProviderElement(super.provider);

  @override
  String get node => (origin as StorageDetailProvider).node;
  @override
  String get storageId => (origin as StorageDetailProvider).storageId;
}

String _$storageContentHash() => r'11b7a3c4540bff2761b35e7d3b4d14b4fb0540df';

/// All content entries for a pool (backups, ISOs, …).
///
/// Copied from [storageContent].
@ProviderFor(storageContent)
const storageContentProvider = StorageContentFamily();

/// All content entries for a pool (backups, ISOs, …).
///
/// Copied from [storageContent].
class StorageContentFamily extends Family<AsyncValue<List<BackupContent>>> {
  /// All content entries for a pool (backups, ISOs, …).
  ///
  /// Copied from [storageContent].
  const StorageContentFamily();

  /// All content entries for a pool (backups, ISOs, …).
  ///
  /// Copied from [storageContent].
  StorageContentProvider call(String node, String storageId) {
    return StorageContentProvider(node, storageId);
  }

  @override
  StorageContentProvider getProviderOverride(
    covariant StorageContentProvider provider,
  ) {
    return call(provider.node, provider.storageId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storageContentProvider';
}

/// All content entries for a pool (backups, ISOs, …).
///
/// Copied from [storageContent].
class StorageContentProvider
    extends AutoDisposeFutureProvider<List<BackupContent>> {
  /// All content entries for a pool (backups, ISOs, …).
  ///
  /// Copied from [storageContent].
  StorageContentProvider(String node, String storageId)
    : this._internal(
        (ref) => storageContent(ref as StorageContentRef, node, storageId),
        from: storageContentProvider,
        name: r'storageContentProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$storageContentHash,
        dependencies: StorageContentFamily._dependencies,
        allTransitiveDependencies:
            StorageContentFamily._allTransitiveDependencies,
        node: node,
        storageId: storageId,
      );

  StorageContentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.storageId,
  }) : super.internal();

  final String node;
  final String storageId;

  @override
  Override overrideWith(
    FutureOr<List<BackupContent>> Function(StorageContentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StorageContentProvider._internal(
        (ref) => create(ref as StorageContentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        storageId: storageId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BackupContent>> createElement() {
    return _StorageContentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StorageContentProvider &&
        other.node == node &&
        other.storageId == storageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, storageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StorageContentRef on AutoDisposeFutureProviderRef<List<BackupContent>> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `storageId` of this provider.
  String get storageId;
}

class _StorageContentProviderElement
    extends AutoDisposeFutureProviderElement<List<BackupContent>>
    with StorageContentRef {
  _StorageContentProviderElement(super.provider);

  @override
  String get node => (origin as StorageContentProvider).node;
  @override
  String get storageId => (origin as StorageContentProvider).storageId;
}

String _$allClusterStorageHash() => r'e3970bbb573e219cc769e7ce9fcdd01ba2585ee6';

/// All storage pools across nodes with usage from [GET …/status] per pool.
///
/// Pull-to-refresh: `ref.read(allClusterStorageProvider.notifier).refresh()`.
///
/// Copied from [AllClusterStorage].
@ProviderFor(AllClusterStorage)
final allClusterStorageProvider =
    AutoDisposeAsyncNotifierProvider<AllClusterStorage, List<Storage>>.internal(
      AllClusterStorage.new,
      name: r'allClusterStorageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allClusterStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AllClusterStorage = AutoDisposeAsyncNotifier<List<Storage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
