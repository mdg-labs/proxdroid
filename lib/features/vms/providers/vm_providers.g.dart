// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vmRepositoryHash() => r'8b2c115f8286c7112c40386afa29288c796f4133';

/// See also [vmRepository].
@ProviderFor(vmRepository)
final vmRepositoryProvider = AutoDisposeFutureProvider<VmRepository?>.internal(
  vmRepository,
  name: r'vmRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vmRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VmRepositoryRef = AutoDisposeFutureProviderRef<VmRepository?>;
String _$allVmsHash() => r'2e429f7cac1c35a47c9690d5e1a8d2508788ea17';

/// All cluster VMs (`allVmsProvider`). Pull-to-refresh:
/// `ref.read(allVmsProvider.notifier).refresh()`.
///
/// Copied from [AllVms].
@ProviderFor(AllVms)
final allVmsProvider =
    AutoDisposeAsyncNotifierProvider<AllVms, List<Vm>>.internal(
      AllVms.new,
      name: r'allVmsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$allVmsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AllVms = AutoDisposeAsyncNotifier<List<Vm>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
