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
