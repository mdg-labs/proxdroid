// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityHash() => r'13bdc4f463c36e0be95867631ff1441fbf861eaa';

/// Current and changing radio connectivity from [connectivity_plus].
///
/// Emits the result of [Connectivity.checkConnectivity] first, then every event
/// from [Connectivity.onConnectivityChanged]. Values are **never empty** (see
/// plugin docs); offline is `[ConnectivityResult.none]`.
///
/// Phase 6 will use this for the persistent offline banner
/// ([ProxDroid_Roadmap.md] §6.1).
///
/// Copied from [connectivity].
@ProviderFor(connectivity)
final connectivityProvider =
    AutoDisposeStreamProvider<List<ConnectivityResult>>.internal(
      connectivity,
      name: r'connectivityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$connectivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityRef =
    AutoDisposeStreamProviderRef<List<ConnectivityResult>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
