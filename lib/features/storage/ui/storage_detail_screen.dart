import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/icon_badge_avatar.dart';
import 'package:proxdroid/shared/widgets/labeled_row.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/resource_gauge_row.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

Color _storageDetailAccent(Storage s, ColorScheme scheme) {
  if (!s.active) return scheme.tertiary;
  final t = s.total;
  final u = s.used;
  if (t == null || t <= 0 || u == null || u < 0) return scheme.primary;
  final f = (u / t).clamp(0.0, 1.0);
  if (f >= 0.85) return scheme.error;
  if (f >= 0.65) return scheme.tertiary;
  return scheme.primary;
}

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
    final tt = Theme.of(context).textTheme;
    final detailAsync = ref.watch(storageDetailProvider(node, storage));
    final contentAsync = ref.watch(storageContentProvider(node, storage));
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> pullRefresh() async {
      _refresh(ref);
      await ref.read(storageDetailProvider(node, storage).future);
      await ref.read(storageContentProvider(node, storage).future);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(leading: shellAppBarLeading(context), title: Text(storage)),
        Expanded(
          child: detailAsync.when(
            loading:
                () => RefreshIndicator(
                  onRefresh: pullRefresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: minPullHeight,
                        child: LoadingShimmer(
                          itemCount: 5,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
            error:
                (e, _) => RefreshIndicator(
                  onRefresh: pullRefresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: minPullHeight,
                        child: ErrorView(
                          message: proxmoxExceptionMessage(e, l10n),
                          onRetry: () => _refresh(ref),
                        ),
                      ),
                    ],
                  ),
                ),
            data: (s) {
              final frac = _usageFraction(s.total, s.used);
              final accent = _storageDetailAccent(s, scheme);
              return RefreshIndicator(
                onRefresh: pullRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(width: 4, color: accent),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          AppSpacing.md,
                                          AppSpacing.md,
                                          AppSpacing.md,
                                          AppSpacing.md,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IconBadgeAvatar(
                                                  icon: Icons.storage_rounded,
                                                  size: 56,
                                                  iconSize: 28,
                                                  borderRadius: 14,
                                                ),
                                                const SizedBox(
                                                  width: AppSpacing.sm,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              s.id,
                                                              style: tt
                                                                  .titleLarge
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                          StatusBadge(
                                                            label:
                                                                s.active
                                                                    ? l10n
                                                                        .storageActive
                                                                    : l10n
                                                                        .storageInactive,
                                                            variant:
                                                                s.active
                                                                    ? StatusBadgeVariant
                                                                        .success
                                                                    : StatusBadgeVariant
                                                                        .neutral,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        s.node,
                                                        style: tt.bodySmall
                                                            ?.copyWith(
                                                              color:
                                                                  scheme
                                                                      .onSurfaceVariant,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.md,
                                            ),
                                            ResourceGaugeRow(
                                              label: l10n.storageUsageSection,
                                              value: frac,
                                              valueSuffix:
                                                  frac != null
                                                      ? formatMemoryRatio(
                                                        s.used,
                                                        s.total,
                                                      )
                                                      : l10n.valueUnavailable,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.lg,
                                  AppSpacing.md,
                                  AppSpacing.lg,
                                  AppSpacing.sm,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    LabeledRow(
                                      label: l10n.entityNode,
                                      value: s.node,
                                    ),
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
                                    if (s.available != null)
                                      LabeledRow(
                                        label: l10n.storageLabelAvailable,
                                        value: formatBytes(s.available),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.storageDetailContentTitle,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    contentAsync.when(
                      loading:
                          () => const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: LoadingShimmer(itemCount: 3),
                            ),
                          ),
                      error:
                          (e, _) => SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
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
                                vertical: AppSpacing.xl,
                                horizontal: AppSpacing.lg,
                              ),
                              child: EmptyState(
                                icon: Icons.folder_open_outlined,
                                title: l10n.storageDetailContentTitle,
                                message: l10n.storageContentEmpty,
                              ),
                            ),
                          );
                        }
                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            0,
                          ),
                          sliver: SliverList.separated(
                            itemCount: items.length,
                            separatorBuilder:
                                (_, _) => const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, i) {
                              final c = items[i];
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.volid,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: tt.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        [
                                          if (c.vmid != null)
                                            '${l10n.labelVmid} ${c.vmid}',
                                          if (c.format.isNotEmpty)
                                            '${l10n.labelFormat}: ${c.format}',
                                          if (c.content.isNotEmpty)
                                            '${l10n.labelContentKind}: ${c.content}',
                                          if (c.ctime != null)
                                            formatProxmoxUnixSeconds(c.ctime),
                                          if (c.size != null)
                                            formatBytes(c.size),
                                        ].where((e) => e.isNotEmpty).join(' · '),
                                        style: tt.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xl),
                    ),
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
