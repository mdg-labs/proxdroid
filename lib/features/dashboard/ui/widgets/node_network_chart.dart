import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';

/// Network I/O history for a cluster node (node detail).
class NodeNetworkChart extends ConsumerWidget {
  const NodeNetworkChart({
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
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(nodeRrdDataProvider(node, timeframe));

    return ChartCard(
      title: l10n.metricNetwork,
      child: async.when(
        loading:
            () => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.network,
              primaryColor: scheme.primary,
              secondaryColor: AppColors.chartNetworkOut,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              isLoading: true,
              showTimeframeSelector: false,
            ),
        error:
            (e, _) => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.network,
              primaryColor: scheme.primary,
              secondaryColor: AppColors.chartNetworkOut,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              error: e,
              errorMessage: proxmoxExceptionMessage(e, l10n),
              onRetry:
                  () => ref.invalidate(nodeRrdDataProvider(node, timeframe)),
              showTimeframeSelector: false,
            ),
        data:
            (points) => ResourceLineChart(
              data: points,
              metric: ResourceChartMetric.network,
              primaryColor: scheme.primary,
              secondaryColor: AppColors.chartNetworkOut,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              showTimeframeSelector: false,
            ),
      ),
    );
  }
}
