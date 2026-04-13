import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';

/// Memory history for an LXC container (container detail).
///
/// Series color: [ColorScheme.secondary] (Stitch periwinkle for RAM).
class ContainerMemoryChart extends ConsumerWidget {
  const ContainerMemoryChart({
    required this.node,
    required this.ctid,
    required this.timeframe,
    required this.onTimeframeChanged,
    super.key,
  });

  final String node;
  final int ctid;
  final ChartTimeframe timeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(lxcRrdDataProvider(node, ctid, timeframe));

    return ChartCard(
      title: l10n.metricMemory,
      child: async.when(
        loading:
            () => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.memory,
              primaryColor: scheme.secondary,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              isLoading: true,
              showTimeframeSelector: false,
            ),
        error:
            (e, _) => ResourceLineChart(
              data: const [],
              metric: ResourceChartMetric.memory,
              primaryColor: scheme.secondary,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              error: e,
              errorMessage: proxmoxExceptionMessage(e, l10n),
              onRetry:
                  () =>
                      ref.invalidate(lxcRrdDataProvider(node, ctid, timeframe)),
              showTimeframeSelector: false,
            ),
        data:
            (points) => ResourceLineChart(
              data: points,
              metric: ResourceChartMetric.memory,
              primaryColor: scheme.secondary,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              showTimeframeSelector: false,
            ),
      ),
    );
  }
}
