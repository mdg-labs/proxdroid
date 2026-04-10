// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$containerRepositoryHash() =>
    r'8a3c02a06445c3284a2ff520d7d25fbc404b507e';

/// See also [containerRepository].
@ProviderFor(containerRepository)
final containerRepositoryProvider =
    AutoDisposeFutureProvider<ContainerRepository?>.internal(
      containerRepository,
      name: r'containerRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$containerRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContainerRepositoryRef =
    AutoDisposeFutureProviderRef<ContainerRepository?>;
String _$allContainersHash() => r'a0e7cf608d4589c0241bc0a0100e49d7222fad12';

/// All cluster LXCs (`allContainersProvider`). Pull-to-refresh:
/// `ref.read(allContainersProvider.notifier).refresh()`.
///
/// Copied from [AllContainers].
@ProviderFor(AllContainers)
final allContainersProvider =
    AutoDisposeAsyncNotifierProvider<AllContainers, List<Container>>.internal(
      AllContainers.new,
      name: r'allContainersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allContainersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AllContainers = AutoDisposeAsyncNotifier<List<Container>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
