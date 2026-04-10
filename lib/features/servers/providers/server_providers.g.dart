// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverRepositoryHash() => r'e66ed6ac353fb03f947e5c7aa60b01956206054c';

/// See also [serverRepository].
@ProviderFor(serverRepository)
final serverRepositoryProvider = Provider<ServerRepository>.internal(
  serverRepository,
  name: r'serverRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$serverRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServerRepositoryRef = ProviderRef<ServerRepository>;
String _$serverByIdHash() => r'4b62e33978eafab04b01167a0887c82de634fe6f';

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

/// See also [serverById].
@ProviderFor(serverById)
const serverByIdProvider = ServerByIdFamily();

/// See also [serverById].
class ServerByIdFamily extends Family<AsyncValue<Server?>> {
  /// See also [serverById].
  const ServerByIdFamily();

  /// See also [serverById].
  ServerByIdProvider call(String id) {
    return ServerByIdProvider(id);
  }

  @override
  ServerByIdProvider getProviderOverride(
    covariant ServerByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serverByIdProvider';
}

/// See also [serverById].
class ServerByIdProvider extends AutoDisposeFutureProvider<Server?> {
  /// See also [serverById].
  ServerByIdProvider(String id)
    : this._internal(
        (ref) => serverById(ref as ServerByIdRef, id),
        from: serverByIdProvider,
        name: r'serverByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$serverByIdHash,
        dependencies: ServerByIdFamily._dependencies,
        allTransitiveDependencies: ServerByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ServerByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Server?> Function(ServerByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServerByIdProvider._internal(
        (ref) => create(ref as ServerByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Server?> createElement() {
    return _ServerByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServerByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServerByIdRef on AutoDisposeFutureProviderRef<Server?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ServerByIdProviderElement
    extends AutoDisposeFutureProviderElement<Server?>
    with ServerByIdRef {
  _ServerByIdProviderElement(super.provider);

  @override
  String get id => (origin as ServerByIdProvider).id;
}

String _$apiClientHash() => r'e98c443baf43c154b2f1034e8454b8f9d0f9e44d';

/// See also [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = AutoDisposeFutureProvider<ProxmoxApiClient?>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = AutoDisposeFutureProviderRef<ProxmoxApiClient?>;
String _$serverListNotifierHash() =>
    r'6aa5015ed8c460839564076fe673631693a1335b';

/// See also [ServerListNotifier].
@ProviderFor(ServerListNotifier)
final serverListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ServerListNotifier, List<Server>>.internal(
      ServerListNotifier.new,
      name: r'serverListNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$serverListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServerListNotifier = AutoDisposeAsyncNotifier<List<Server>>;
String _$selectedServerHash() => r'568ccc469d06743c8527060fb3e8fd9c7a4f03ea';

/// MVP: selection tracks the first server in the persisted list whenever the list
/// changes (same drawback as a [StateProvider] that resets on rebuild). For
/// production, persist the **selected server id** in hive_ce and resolve it in
/// [build] so the user's explicit choice survives list edits.
///
/// Copied from [SelectedServer].
@ProviderFor(SelectedServer)
final selectedServerProvider =
    NotifierProvider<SelectedServer, Server?>.internal(
      SelectedServer.new,
      name: r'selectedServerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedServerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedServer = Notifier<Server?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
