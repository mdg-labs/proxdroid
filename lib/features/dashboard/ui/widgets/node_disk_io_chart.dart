import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';

/// Disk read/write history for a cluster node (node detail).
class NodeDiskIoChart extends ConsumerWidget {
  const NodeDiskIoChart({
    required this.node,
    required this.timeframe,
    required this.onTimeframeChanged,
    super.key,
  });

  final String node;
  final ChartTimeframe timeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(nodeRrdDataProvider(node, timeframe));

    return ChartCard(
      title: l10n.chartDiskIoSectionTitle,
      child: async.when(
        loading:
            () => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.diskIo,
              primaryColor: AppColors.chartDiskRead,
              secondaryColor: AppColors.chartDiskWrite,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              isLoading: true,
              showTimeframeSelector: false,
            ),
        error:
            (e, _) => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.diskIo,
              primaryColor: AppColors.chartDiskRead,
              secondaryColor: AppColors.chartDiskWrite,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              error: e,
              errorMessage: proxmoxExceptionMessage(e, l10n),
              onRetry:
                  () => ref.invalidate(nodeRrdDataProvider(node, timeframe)),
              showTimeframeSelector: false,
            ),
        data: (points) {
          final hasDiskSeries =
              points.isNotEmpty &&
              points.any((p) => p.diskRead != null || p.diskWrite != null);
          if (!hasDiskSeries) {
            return SizedBox(
              height: 220,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.chartDiskIoUnavailableOnNode,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }
          return ResourceLineChart(
            data: points,
            metric: ResourceChartMetric.diskIo,
            primaryColor: AppColors.chartDiskRead,
            secondaryColor: AppColors.chartDiskWrite,
            timeframe: timeframe,
            onTimeframeChanged: onTimeframeChanged,
            l10n: l10n,
            showTimeframeSelector: false,
          );
        },
      ),
    );
  }
}
