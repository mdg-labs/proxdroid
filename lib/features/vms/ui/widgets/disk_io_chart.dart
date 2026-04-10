import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';

/// Disk read/write history for a QEMU guest (VM detail).
///
/// Series colors per §9: read = [AppColors.chartDiskRead] (amber),
/// write = [AppColors.chartDiskWrite] (blue-grey).
class VmDiskIoChart extends ConsumerWidget {
  const VmDiskIoChart({
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
    final async = ref.watch(vmRrdDataProvider(node, vmid, timeframe));

    return ChartCard(
      title: l10n.chartDiskIoSectionTitle,
      timeframeSelector: ChartTimeframeSelector(
        selected: timeframe,
        onChanged: onTimeframeChanged,
        l10n: l10n,
      ),
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
                  () =>
                      ref.invalidate(vmRrdDataProvider(node, vmid, timeframe)),
              showTimeframeSelector: false,
            ),
        data:
            (points) => ResourceLineChart(
              data: points,
              metric: ResourceChartMetric.diskIo,
              primaryColor: AppColors.chartDiskRead,
              secondaryColor: AppColors.chartDiskWrite,
              timeframe: timeframe,
              onTimeframeChanged: onTimeframeChanged,
              l10n: l10n,
              showTimeframeSelector: false,
            ),
      ),
    );
  }
}
