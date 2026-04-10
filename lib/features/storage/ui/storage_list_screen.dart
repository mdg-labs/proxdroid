import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

class StorageListScreen extends ConsumerWidget {
  const StorageListScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.read(nodeListProvider.notifier).refresh();
    ref.read(allClusterStorageProvider.notifier).refresh();
  }

  double? _usageFraction(Storage s) {
    final t = s.total;
    final u = s.used;
    if (t == null || t <= 0 || u == null || u < 0) return null;
    return (u / t).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(allClusterStorageProvider);
    final nodesAsync = ref.watch(nodeListProvider);
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> pullRefresh() async {
      _refresh(ref);
      await ref.read(allClusterStorageProvider.future);
      await ref.read(nodeListProvider.future);
    }

    if (async.hasError || nodesAsync.hasError) {
      final err = async.error ?? nodesAsync.error!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.entityStorage),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: pullRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: ErrorView(
                      message: proxmoxExceptionMessage(err, l10n),
                      onRetry: () => _refresh(ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (!async.hasValue || !nodesAsync.hasValue) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.entityStorage),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: pullRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: const LoadingShimmer(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final list = async.requireValue;
    if (list.isEmpty) {
      final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.entityStorage),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refresh(ref);
                await ref.read(allClusterStorageProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: EmptyState(
                      icon: Icons.storage_outlined,
                      title: l10n.storageEmptyTitle,
                      message: l10n.storageEmptyMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.entityStorage),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: pullRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final s = list[index];
                final frac = _usageFraction(s);
                return Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    onTap:
                        () => context.push(
                          '/storage/${Uri.encodeComponent(s.node)}/${Uri.encodeComponent(s.id)}',
                        ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.id,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              StatusBadge(
                                label:
                                    s.active
                                        ? l10n.storageActive
                                        : l10n.storageInactive,
                                variant:
                                    s.active
                                        ? StatusBadgeVariant.success
                                        : StatusBadgeVariant.neutral,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.entityNode}: ${s.node}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.storageTypeLabel}: ${s.type.isEmpty ? l10n.valueUnavailable : s.type}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          if (s.content.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.storageContentTypesLabel}: ${s.content.join(', ')}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            l10n.storageUsageSection,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          if (frac != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: frac,
                                minHeight: 8,
                              ),
                            )
                          else
                            Text(
                              l10n.valueUnavailable,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          if (frac != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              formatMemoryRatio(s.used, s.total),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                          if (s.available != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.storageAvailableSpace(
                                formatBytes(s.available),
                              ),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
