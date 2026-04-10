import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/labeled_row.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

class StorageDetailScreen extends ConsumerWidget {
  const StorageDetailScreen({
    required this.node,
    required this.storage,
    super.key,
  });

  final String node;
  final String storage;

  void _refresh(WidgetRef ref) {
    ref.invalidate(storageDetailProvider(node, storage));
    ref.invalidate(storageContentProvider(node, storage));
  }

  double? _usageFraction(int? total, int? used) {
    if (total == null || total <= 0 || used == null || used < 0) return null;
    return (used / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final detailAsync = ref.watch(storageDetailProvider(node, storage));
    final contentAsync = ref.watch(storageContentProvider(node, storage));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(leading: shellAppBarLeading(context), title: Text(storage)),
        Expanded(
          child: detailAsync.when(
            loading: () => const LoadingShimmer(itemCount: 5),
            error:
                (e, _) => ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry: () => _refresh(ref),
                ),
            data: (s) {
              final frac = _usageFraction(s.total, s.used);
              return RefreshIndicator(
                onRefresh: () async {
                  _refresh(ref);
                  await ref.read(storageDetailProvider(node, storage).future);
                  await ref.read(storageContentProvider(node, storage).future);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.id,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
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
                            const SizedBox(height: 16),
                            LabeledRow(label: l10n.entityNode, value: s.node),
                            LabeledRow(
                              label: l10n.storageTypeLabel,
                              value:
                                  s.type.isEmpty
                                      ? l10n.valueUnavailable
                                      : s.type,
                            ),
                            if (s.content.isNotEmpty)
                              LabeledRow(
                                label: l10n.storageContentTypesLabel,
                                value: s.content.join(', '),
                              ),
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
                            if (s.available != null)
                              LabeledRow(
                                label: l10n.storageLabelAvailable,
                                value: formatBytes(s.available),
                              ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.storageDetailContentTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    contentAsync.when(
                      loading:
                          () => const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: LoadingShimmer(itemCount: 3),
                            ),
                          ),
                      error:
                          (e, _) => SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ErrorView(
                                message: proxmoxExceptionMessage(e, l10n),
                                onRetry: () => _refresh(ref),
                              ),
                            ),
                          ),
                      data: (items) {
                        if (items.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 16,
                              ),
                              child: EmptyState(
                                icon: Icons.folder_open_outlined,
                                title: l10n.storageDetailContentTitle,
                                message: l10n.storageContentEmpty,
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            final c = items[i];
                            return Card(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: ListTile(
                                title: Text(
                                  c.volid,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  [
                                    if (c.vmid != null)
                                      '${l10n.labelVmid} ${c.vmid}',
                                    if (c.format.isNotEmpty)
                                      '${l10n.labelFormat}: ${c.format}',
                                    if (c.content.isNotEmpty)
                                      '${l10n.labelContentKind}: ${c.content}',
                                    if (c.ctime != null)
                                      formatProxmoxUnixSeconds(c.ctime),
                                    if (c.size != null) formatBytes(c.size),
                                  ].where((e) => e.isNotEmpty).join(' · '),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                isThreeLine: true,
                              ),
                            );
                          }, childCount: items.length),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
