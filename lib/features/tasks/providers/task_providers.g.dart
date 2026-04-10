// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'd38594890f72c6002b78c47862d5d5e037c339c6';

/// See also [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider =
    AutoDisposeFutureProvider<TaskRepository?>.internal(
      taskRepository,
      name: r'taskRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taskRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeFutureProviderRef<TaskRepository?>;
String _$taskStatusHash() => r'c3fd122c6e6ca50f6da2423ccbd45bf8ccffe961';

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

/// Live task status for a single UPID, for **power-action follow-up** after
/// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
/// stops polling once the task reaches a terminal status.
///
/// Copied from [taskStatus].
@ProviderFor(taskStatus)
const taskStatusProvider = TaskStatusFamily();

/// Live task status for a single UPID, for **power-action follow-up** after
/// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
/// stops polling once the task reaches a terminal status.
///
/// Copied from [taskStatus].
class TaskStatusFamily extends Family<AsyncValue<pve.TaskStatus>> {
  /// Live task status for a single UPID, for **power-action follow-up** after
  /// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
  /// stops polling once the task reaches a terminal status.
  ///
  /// Copied from [taskStatus].
  const TaskStatusFamily();

  /// Live task status for a single UPID, for **power-action follow-up** after
  /// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
  /// stops polling once the task reaches a terminal status.
  ///
  /// Copied from [taskStatus].
  TaskStatusProvider call(String node, String upid) {
    return TaskStatusProvider(node, upid);
  }

  @override
  TaskStatusProvider getProviderOverride(
    covariant TaskStatusProvider provider,
  ) {
    return call(provider.node, provider.upid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskStatusProvider';
}

/// Live task status for a single UPID, for **power-action follow-up** after
/// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
/// stops polling once the task reaches a terminal status.
///
/// Copied from [taskStatus].
class TaskStatusProvider extends FutureProvider<pve.TaskStatus> {
  /// Live task status for a single UPID, for **power-action follow-up** after
  /// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
  /// stops polling once the task reaches a terminal status.
  ///
  /// Copied from [taskStatus].
  TaskStatusProvider(String node, String upid)
    : this._internal(
        (ref) => taskStatus(ref as TaskStatusRef, node, upid),
        from: taskStatusProvider,
        name: r'taskStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$taskStatusHash,
        dependencies: TaskStatusFamily._dependencies,
        allTransitiveDependencies: TaskStatusFamily._allTransitiveDependencies,
        node: node,
        upid: upid,
      );

  TaskStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.upid,
  }) : super.internal();

  final String node;
  final String upid;

  @override
  Override overrideWith(
    FutureOr<pve.TaskStatus> Function(TaskStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskStatusProvider._internal(
        (ref) => create(ref as TaskStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        upid: upid,
      ),
    );
  }

  @override
  FutureProviderElement<pve.TaskStatus> createElement() {
    return _TaskStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStatusProvider &&
        other.node == node &&
        other.upid == upid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, upid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskStatusRef on FutureProviderRef<pve.TaskStatus> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `upid` of this provider.
  String get upid;
}

class _TaskStatusProviderElement extends FutureProviderElement<pve.TaskStatus>
    with TaskStatusRef {
  _TaskStatusProviderElement(super.provider);

  @override
  String get node => (origin as TaskStatusProvider).node;
  @override
  String get upid => (origin as TaskStatusProvider).upid;
}

String _$taskLogHash() => r'bac7f221b6ace6442718024e0b2a154734fc213b';

/// Task log lines for [taskDetailScreen] (first page).
///
/// Copied from [taskLog].
@ProviderFor(taskLog)
const taskLogProvider = TaskLogFamily();

/// Task log lines for [taskDetailScreen] (first page).
///
/// Copied from [taskLog].
class TaskLogFamily extends Family<AsyncValue<List<String>>> {
  /// Task log lines for [taskDetailScreen] (first page).
  ///
  /// Copied from [taskLog].
  const TaskLogFamily();

  /// Task log lines for [taskDetailScreen] (first page).
  ///
  /// Copied from [taskLog].
  TaskLogProvider call(String node, String upid) {
    return TaskLogProvider(node, upid);
  }

  @override
  TaskLogProvider getProviderOverride(covariant TaskLogProvider provider) {
    return call(provider.node, provider.upid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskLogProvider';
}

/// Task log lines for [taskDetailScreen] (first page).
///
/// Copied from [taskLog].
class TaskLogProvider extends AutoDisposeFutureProvider<List<String>> {
  /// Task log lines for [taskDetailScreen] (first page).
  ///
  /// Copied from [taskLog].
  TaskLogProvider(String node, String upid)
    : this._internal(
        (ref) => taskLog(ref as TaskLogRef, node, upid),
        from: taskLogProvider,
        name: r'taskLogProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$taskLogHash,
        dependencies: TaskLogFamily._dependencies,
        allTransitiveDependencies: TaskLogFamily._allTransitiveDependencies,
        node: node,
        upid: upid,
      );

  TaskLogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.node,
    required this.upid,
  }) : super.internal();

  final String node;
  final String upid;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(TaskLogRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskLogProvider._internal(
        (ref) => create(ref as TaskLogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        node: node,
        upid: upid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _TaskLogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskLogProvider && other.node == node && other.upid == upid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, node.hashCode);
    hash = _SystemHash.combine(hash, upid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskLogRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `node` of this provider.
  String get node;

  /// The parameter `upid` of this provider.
  String get upid;
}

class _TaskLogProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with TaskLogRef {
  _TaskLogProviderElement(super.provider);

  @override
  String get node => (origin as TaskLogProvider).node;
  @override
  String get upid => (origin as TaskLogProvider).upid;
}

String _$taskListHash() => r'654f2b96d79490ff99383e75aeb46522d0ea8369';

/// Merged cluster task list: per-node tasks (first page), sorted by
/// [pve.Task.startTime] descending (nulls last). Pull-to-refresh:
/// `ref.read(taskListProvider.notifier).refresh()`.
///
/// Copied from [TaskList].
@ProviderFor(TaskList)
final taskListProvider =
    AutoDisposeAsyncNotifierProvider<TaskList, List<pve.Task>>.internal(
      TaskList.new,
      name: r'taskListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$taskListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskList = AutoDisposeAsyncNotifier<List<pve.Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
