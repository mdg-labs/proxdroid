import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/resource_gauge_row.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

double? _usageFraction(Storage s) {
  final t = s.total;
  final u = s.used;
  if (t == null || t <= 0 || u == null || u < 0) return null;
  return (u / t).clamp(0.0, 1.0);
}

Color _storagePoolAccentColor(Storage s, ColorScheme scheme) {
  if (!s.active) return scheme.tertiary;
  final f = _usageFraction(s);
  if (f == null) return scheme.primary;
  if (f >= 0.85) return scheme.error;
  if (f >= 0.65) return scheme.tertiary;
  return scheme.primary;
}

/// Aggregates derived only from [Storage] rows returned by the cluster provider.
class _StorageClusterRollup {
  const _StorageClusterRollup({
    required this.pairedUsedSum,
    required this.pairedTotalSum,
    required this.healthyCount,
    required this.atRiskCount,
    required this.usedByNode,
  });

  final int? pairedUsedSum;
  final int? pairedTotalSum;
  final int healthyCount;
  final int atRiskCount;
  final Map<String, int> usedByNode;

  double? get clusterUsageFraction {
    final u = pairedUsedSum;
    final t = pairedTotalSum;
    if (u == null || t == null || t <= 0) return null;
    return (u / t).clamp(0.0, 1.0);
  }
}

_StorageClusterRollup _rollupCluster(List<Storage> list) {
  var pairedUsed = 0;
  var pairedTotal = 0;
  var hasPaired = false;
  var healthy = 0;
  var atRisk = 0;
  final nodes = <String>{};
  for (final s in list) {
    nodes.add(s.node);
  }
  final usedByNode = {for (final n in nodes) n: 0};

  for (final s in list) {
    final t = s.total;
    final u = s.used;
    if (t != null && t > 0 && u != null && u >= 0) {
      pairedUsed += u;
      pairedTotal += t;
      hasPaired = true;
    }
    if (u != null && u >= 0) {
      usedByNode[s.node] = (usedByNode[s.node] ?? 0) + u;
    }

    final frac = _usageFraction(s);
    final isHealthy = s.active && (frac == null || frac < 0.65);
    if (isHealthy) {
      healthy++;
    } else {
      atRisk++;
    }
  }

  return _StorageClusterRollup(
    pairedUsedSum: hasPaired ? pairedUsed : null,
    pairedTotalSum: hasPaired ? pairedTotal : null,
    healthyCount: healthy,
    atRiskCount: atRisk,
    usedByNode: usedByNode,
  );
}

class StorageListScreen extends ConsumerWidget {
  const StorageListScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.read(nodeListProvider.notifier).refresh();
    ref.read(allClusterStorageProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final async = ref.watch(allClusterStorageProvider);
    final nodesAsync = ref.watch(nodeListProvider);
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> pullRefresh() async {
      _refresh(ref);
      await ref.read(allClusterStorageProvider.future);
      await ref.read(nodeListProvider.future);
    }

    final Widget body;

    if (async.hasError || nodesAsync.hasError) {
      final err = async.error ?? nodesAsync.error!;
      body = RefreshIndicator(
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
      );
    } else if (!async.hasValue || !nodesAsync.hasValue) {
      body = RefreshIndicator(
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
      );
    } else {
      final list = async.requireValue;
      if (list.isEmpty) {
        body = RefreshIndicator(
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
        );
      } else {
        final rollup = _rollupCluster(list);
        final nodeEntries =
            rollup.usedByNode.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));
        final totalUsedOnNodes = rollup.usedByNode.values.fold<int>(
          0,
          (a, b) => a + b,
        );
        final distinctNodes = rollup.usedByNode.length;
        final showNodeDistribution = distinctNodes >= 2 && totalUsedOnNodes > 0;

        body = RefreshIndicator(
          onRefresh: pullRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.lg,
                            AppSpacing.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.storageClusterHeroTitle,
                                style: tt.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.storageClusterHeroSubtitle,
                                style: tt.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              ResourceGaugeRow(
                                label: l10n.storageUsageSection,
                                value: rollup.clusterUsageFraction,
                                valueSuffix:
                                    rollup.clusterUsageFraction != null
                                        ? formatMemoryRatio(
                                          rollup.pairedUsedSum,
                                          rollup.pairedTotalSum,
                                        )
                                        : l10n.valueUnavailable,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _StorageHealthTile(
                              value: '${rollup.healthyCount}',
                              label: l10n.storagePoolHealthHealthyLabel,
                              icon: Icons.verified_outlined,
                              iconBackground: scheme.primary.withValues(
                                alpha: 0.10,
                              ),
                              iconColor: scheme.primary,
                              scheme: scheme,
                              tt: tt,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _StorageHealthTile(
                              value: '${rollup.atRiskCount}',
                              label: l10n.storagePoolHealthAtRiskLabel,
                              icon: Icons.warning_amber_rounded,
                              iconBackground: scheme.tertiary.withValues(
                                alpha: 0.12,
                              ),
                              iconColor: scheme.tertiary,
                              scheme: scheme,
                              tt: tt,
                            ),
                          ),
                        ],
                      ),
                      if (showNodeDistribution) ...[
                        const SizedBox(height: AppSpacing.md),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.md,
                              AppSpacing.lg,
                              AppSpacing.md,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.storageNodeDistributionTitle,
                                  style: tt.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                ...nodeEntries.map((e) {
                                  final frac =
                                      totalUsedOnNodes > 0
                                          ? e.value / totalUsedOnNodes
                                          : 0.0;
                                  final isDark =
                                      Theme.of(context).brightness ==
                                      Brightness.dark;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 88,
                                          child: Text(
                                            e.key,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: tt.labelSmall?.copyWith(
                                              color: scheme.onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: SizedBox(
                                              height: 8,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  ColoredBox(
                                                    color:
                                                        scheme.surfaceContainer,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: FractionallySizedBox(
                                                      widthFactor: frac.clamp(
                                                        0.0,
                                                        1.0,
                                                      ),
                                                      child: DecoratedBox(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              scheme.primary,
                                                              scheme
                                                                  .primaryContainer
                                                                  .withValues(
                                                                    alpha:
                                                                        isDark
                                                                            ? 0.55
                                                                            : 0.85,
                                                                  ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          formatBytes(e.value),
                                          style: tt.labelSmall?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: l10n.storagePoolsSectionTitle,
                  variant: SectionHeaderVariant.muted,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                sliver: SliverList.separated(
                  itemCount: list.length,
                  separatorBuilder:
                      (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final s = list[index];
                    final frac = _usageFraction(s);
                    final accent = _storagePoolAccentColor(s, scheme);
                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap:
                            () => context.push(
                              '/storage/${Uri.encodeComponent(s.node)}/${Uri.encodeComponent(s.id)}',
                            ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color:
                                                    scheme
                                                        .surfaceContainerHighest,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  Icons.storage_rounded,
                                                  size: 22,
                                                  color:
                                                      s.active
                                                          ? scheme.primary
                                                          : scheme
                                                              .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.sm,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    s.id,
                                                    style: tt.titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    [
                                                      if (s.type.isNotEmpty)
                                                        s.type
                                                      else
                                                        l10n.valueUnavailable,
                                                      s.node,
                                                    ].join(' · '),
                                                    style: tt.bodySmall?.copyWith(
                                                      color:
                                                          scheme
                                                              .onSurfaceVariant,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            StatusBadge(
                                              label:
                                                  s.active
                                                      ? l10n.storageActive
                                                      : l10n.storageInactive,
                                              variant:
                                                  s.active
                                                      ? StatusBadgeVariant
                                                          .success
                                                      : StatusBadgeVariant
                                                          .neutral,
                                            ),
                                          ],
                                        ),
                                        if (s.content.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            '${l10n.storageContentTypesLabel}: ${s.content.join(', ')}',
                                            style: tt.labelSmall?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: AppSpacing.sm),
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
                                        if (s.available != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.storageAvailableSpace(
                                              formatBytes(s.available),
                                            ),
                                            style: tt.bodySmall?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    }

    return ShellSectionBody(title: Text(l10n.entityStorage), body: body);
  }
}

class _StorageHealthTile extends StatelessWidget {
  const _StorageHealthTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.scheme,
    required this.tt,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final ColorScheme scheme;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: tt.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            DecoratedBox(
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(icon, size: 20, color: iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
