// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxmox_tag_colors_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$proxmoxTagColorsHash() => r'e8e393e841ec1715bca40767510f474ed9530ce4';

/// Cluster datacenter tag → background hex (`GET /version` → `tag-colors`).
///
/// Empty when no server is selected. Invalidates when [apiClientProvider] changes.
///
/// Copied from [proxmoxTagColors].
@ProviderFor(proxmoxTagColors)
final proxmoxTagColorsProvider = FutureProvider<Map<String, String>>.internal(
  proxmoxTagColors,
  name: r'proxmoxTagColorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$proxmoxTagColorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProxmoxTagColorsRef = FutureProviderRef<Map<String, String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
