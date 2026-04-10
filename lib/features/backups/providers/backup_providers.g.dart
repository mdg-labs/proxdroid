// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupRepositoryHash() => r'c3dcbbc7842a3cd9b8a21492144fcd0ef4fb0ba2';

/// See also [backupRepository].
@ProviderFor(backupRepository)
final backupRepositoryProvider =
    AutoDisposeFutureProvider<BackupRepository?>.internal(
      backupRepository,
      name: r'backupRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backupRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackupRepositoryRef = AutoDisposeFutureProviderRef<BackupRepository?>;
String _$backupJobsHash() => r'3b0b077fd1a2f7338d560e6bdf04d0042bc110e5';

/// Cluster vzdump job definitions from [GET /cluster/backup].
///
/// Pull-to-refresh: `ref.read(backupJobsProvider.notifier).refresh()`.
///
/// Copied from [BackupJobs].
@ProviderFor(BackupJobs)
final backupJobsProvider =
    AutoDisposeAsyncNotifierProvider<BackupJobs, List<BackupJob>>.internal(
      BackupJobs.new,
      name: r'backupJobsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backupJobsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BackupJobs = AutoDisposeAsyncNotifier<List<BackupJob>>;
String _$clusterVzdumpTasksHash() =>
    r'1a2b781b4d8dfd5cee660022d23cffcbac9a7857';

/// Recent vzdump tasks across all nodes (`typefilter=vzdump` when supported).
///
/// Pull-to-refresh: `ref.read(clusterVzdumpTasksProvider.notifier).refresh()`.
///
/// Copied from [ClusterVzdumpTasks].
@ProviderFor(ClusterVzdumpTasks)
final clusterVzdumpTasksProvider = AutoDisposeAsyncNotifierProvider<
  ClusterVzdumpTasks,
  List<pve.Task>
>.internal(
  ClusterVzdumpTasks.new,
  name: r'clusterVzdumpTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clusterVzdumpTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClusterVzdumpTasks = AutoDisposeAsyncNotifier<List<pve.Task>>;
String _$clusterBackupContentHash() =>
    r'23bb65569f847b4a8c6d440f1800573f02c0ae58';

/// Backup images from every pool whose `content` list includes `backup`.
///
/// Fetches [GET …/content?content=backup] per pool. Partial node failures are
/// skipped (empty list for that pool) so one offline node does not blank the
/// whole screen.
///
/// Pull-to-refresh: `ref.read(clusterBackupContentProvider.notifier).refresh()`.
///
/// Copied from [ClusterBackupContent].
@ProviderFor(ClusterBackupContent)
final clusterBackupContentProvider = AutoDisposeAsyncNotifierProvider<
  ClusterBackupContent,
  List<BackupContentEntry>
>.internal(
  ClusterBackupContent.new,
  name: r'clusterBackupContentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clusterBackupContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClusterBackupContent =
    AutoDisposeAsyncNotifier<List<BackupContentEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
