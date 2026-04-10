import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';

/// CPU history for a QEMU guest (VM detail).
class VmCpuChart extends ConsumerWidget {
  const VmCpuChart({
    required this.node,
    required this.vmid,
    required this.timeframe,
    required this.onTimeframeChanged,
    super.key,
  });

  final String node;
  final int vmid;
  final ChartTimeframe timeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(vmRrdDataProvider(node, vmid, timeframe));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.metricCpu, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        async.when(
          loading:
              () => ResourceLineChart(
                data: const [],
                metric: ResourceChartMetric.cpu,
                primaryColor: scheme.primary,
                timeframe: timeframe,
                onTimeframeChanged: onTimeframeChanged,
                l10n: l10n,
                isLoading: true,
              ),
          error:
              (e, _) => ResourceLineChart(
                data: const [],
                metric: ResourceChartMetric.cpu,
                primaryColor: scheme.primary,
                timeframe: timeframe,
                onTimeframeChanged: onTimeframeChanged,
                l10n: l10n,
                error: e,
                errorMessage: proxmoxExceptionMessage(e, l10n),
                onRetry:
                    () => ref.invalidate(
                      vmRrdDataProvider(node, vmid, timeframe),
                    ),
              ),
          data:
              (points) => ResourceLineChart(
                data: points,
                metric: ResourceChartMetric.cpu,
                primaryColor: scheme.primary,
                timeframe: timeframe,
                onTimeframeChanged: onTimeframeChanged,
                l10n: l10n,
              ),
        ),
      ],
    );
  }
}
