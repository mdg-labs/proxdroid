import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/pill_segmented.dart';

/// Which metric(s) [ResourceLineChart] plots.
enum ResourceChartMetric { cpu, memory, network, diskIo }

/// Timeframe chips / segmented control labels use [AppLocalizations].
class ChartTimeframeSelector extends StatelessWidget {
  const ChartTimeframeSelector({
    required this.selected,
    required this.onChanged,
    required this.l10n,
    super.key,
  });

  final ChartTimeframe selected;
  final ValueChanged<ChartTimeframe> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PillSegmentedButton<ChartTimeframe>(
      padding: EdgeInsets.zero,
      segments: [
        for (final tf in ChartTimeframe.values)
          ButtonSegment<ChartTimeframe>(value: tf, label: Text(_label(tf))),
      ],
      selected: {selected},
      onSelectionChanged: (Set<ChartTimeframe> next) {
        if (next.isEmpty) return;
        onChanged(next.first);
      },
    );
  }

  String _label(ChartTimeframe tf) => switch (tf) {
    ChartTimeframe.hour => l10n.chartTimeframeHour,
    ChartTimeframe.day => l10n.chartTimeframeDay,
    ChartTimeframe.week => l10n.chartTimeframeWeek,
    ChartTimeframe.month => l10n.chartTimeframeMonth,
  };
}

/// Line chart with gradient fill, axes, touch tooltip, and optional timeframe
/// selector (hidden for e.g. dashboard sparkline-style charts).
class ResourceLineChart extends StatelessWidget {
  const ResourceLineChart({
    required this.data,
    required this.metric,
    required this.primaryColor,
    required this.timeframe,
    required this.onTimeframeChanged,
    required this.l10n,
    this.secondaryColor,
    this.compact = false,
    this.chartHeight,
    this.isLoading = false,
    this.error,
    this.errorMessage,
    this.onRetry,
    this.showTimeframeSelector = true,
    super.key,
  });

  final List<ResourceDataPoint> data;
  final ResourceChartMetric metric;
  final Color primaryColor;
  final Color? secondaryColor;
  final ChartTimeframe timeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;
  final AppLocalizations l10n;
  final bool compact;
  final double? chartHeight;
  final bool isLoading;
  final Object? error;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool showTimeframeSelector;

  double get _defaultHeight => compact ? 100 : 220;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final h = chartHeight ?? _defaultHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTimeframeSelector) ...[
          ChartTimeframeSelector(
            selected: timeframe,
            onChanged: onTimeframeChanged,
            l10n: l10n,
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(height: h, child: _buildBody(context, scheme, h)),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ColorScheme scheme, double h) {
    if (error != null) {
      final msg = errorMessage ?? l10n.chartLoadError;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.error),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
            ],
          ],
        ),
      );
    }
    if (isLoading && data.isEmpty) {
      return PulsingPlaceholder(height: h);
    }
    if (data.isEmpty) {
      return Center(
        child: Text(
          l10n.chartNoData,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }
    return _ResourceLineChartCanvas(
      data: data,
      metric: metric,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor ?? scheme.tertiary,
      timeframe: timeframe,
      l10n: l10n,
      compact: compact,
    );
  }
}

class _ResourceLineChartCanvas extends StatelessWidget {
  const _ResourceLineChartCanvas({
    required this.data,
    required this.metric,
    required this.primaryColor,
    required this.secondaryColor,
    required this.timeframe,
    required this.l10n,
    required this.compact,
  });

  final List<ResourceDataPoint> data;
  final ResourceChartMetric metric;
  final Color primaryColor;
  final Color secondaryColor;
  final ChartTimeframe timeframe;
  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lineBars = _lineBars().where((b) => b.spots.isNotEmpty).toList();
    if (lineBars.isEmpty) {
      return Center(child: Text(l10n.chartNoData));
    }

    final minMax = _minMaxY(lineBars);
    var minY = minMax.$1;
    var maxY = minMax.$2;
    if (minY == maxY) {
      maxY = minY + (metric == ResourceChartMetric.cpu ? 0.1 : 1);
    }
    final range = maxY - minY;
    final pad = range > 0 ? range * 0.08 : 0.01;
    if (metric == ResourceChartMetric.cpu) {
      minY = (minY - pad).clamp(0.0, double.infinity);
    } else {
      minY -= pad;
      if (minY < 0) {
        minY = 0;
      }
    }
    maxY += pad;

    final timeFmt = _timeAxisFormat();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).clamp(0, 1 << 30).toDouble(),
        minY: minY,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: !compact,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / (compact ? 2 : 4),
          getDrawingHorizontalLine:
              (v) =>
                  FlLine(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
            left: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: compact ? 20 : 28,
              interval: _bottomInterval(data.length),
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= data.length) {
                  return const SizedBox.shrink();
                }
                final t = data[i].timestamp.toLocal();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    timeFmt.format(t),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: compact ? 9 : null,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: compact ? 36 : 44,
              interval: (maxY - minY) / (compact ? 2 : 4),
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxis(value),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: compact ? 9 : null,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            maxContentWidth: 240,
            getTooltipItems: (touchedSpots) {
              if (touchedSpots.isEmpty) {
                return const [];
              }
              final i = touchedSpots.first.x.round().clamp(0, data.length - 1);
              final p = data[i];
              final timeStr = DateFormat.yMMMd().add_jm().format(
                p.timestamp.toLocal(),
              );
              final body = switch (metric) {
                ResourceChartMetric.cpu =>
                  '${l10n.metricCpu}: ${formatCpuPercent(_cpuDisplayValue(p.cpu))}',
                ResourceChartMetric.memory =>
                  '${l10n.metricMemory}: ${p.mem != null ? formatBytes(p.mem!.round()) : l10n.valueUnavailable}',
                ResourceChartMetric.network =>
                  '${l10n.chartNetworkIn}: ${formatDataRate(p.netIn)}\n'
                      '${l10n.chartNetworkOut}: ${formatDataRate(p.netOut)}',
                ResourceChartMetric.diskIo =>
                  '${l10n.chartDiskRead}: ${formatDataRate(p.diskRead)}\n'
                      '${l10n.chartDiskWrite}: ${formatDataRate(p.diskWrite)}',
              };
              final item = LineTooltipItem(
                '$timeStr\n$body',
                TextStyle(
                  color: scheme.onInverseSurface,
                  fontSize: 12,
                  height: 1.25,
                ),
              );
              return [
                for (var j = 0; j < touchedSpots.length; j++)
                  j == 0 ? item : null,
              ];
            },
          ),
        ),
        lineBarsData: lineBars,
      ),
    );
  }

  double _bottomInterval(int n) {
    if (n <= 1) {
      return 1;
    }
    final target = compact ? 3 : 5;
    return (n / target).ceilToDouble().clamp(1, n.toDouble());
  }

  DateFormat _timeAxisFormat() {
    return switch (timeframe) {
      ChartTimeframe.hour => DateFormat.Hm(),
      ChartTimeframe.day => DateFormat.Md().add_Hm(),
      ChartTimeframe.week || ChartTimeframe.month => DateFormat.MMMd(),
    };
  }

  /// CPU value for display: rrddata may be 0–1 fraction or percent.
  double? _cpuDisplayValue(double? raw) {
    if (raw == null) {
      return null;
    }
    return raw > 1.5 ? raw / 100.0 : raw;
  }

  String _formatYAxis(double v) {
    switch (metric) {
      case ResourceChartMetric.cpu:
        return formatCpuPercent(_cpuDisplayValue(v));
      case ResourceChartMetric.memory:
        return formatBytes(v.round());
      case ResourceChartMetric.network:
      case ResourceChartMetric.diskIo:
        return formatDataRate(v);
    }
  }

  List<LineChartBarData> _lineBars() {
    switch (metric) {
      case ResourceChartMetric.cpu:
        return [
          _singleLine(
            color: primaryColor,
            values: data.map((e) => _cpuChartY(e.cpu)).toList(),
          ),
        ];
      case ResourceChartMetric.memory:
        return [
          _singleLine(
            color: primaryColor,
            values: data.map((e) => e.mem ?? double.nan).toList(),
          ),
        ];
      case ResourceChartMetric.network:
        return [
          _singleLine(
            color: primaryColor,
            values: data.map((e) => e.netIn ?? double.nan).toList(),
          ),
          _singleLine(
            color: secondaryColor,
            values: data.map((e) => e.netOut ?? double.nan).toList(),
            fillBelow: false,
          ),
        ];
      case ResourceChartMetric.diskIo:
        return [
          _singleLine(
            color: primaryColor,
            values: data.map((e) => e.diskRead ?? double.nan).toList(),
          ),
          _singleLine(
            color: secondaryColor,
            values: data.map((e) => e.diskWrite ?? double.nan).toList(),
            fillBelow: false,
          ),
        ];
    }
  }

  double _cpuChartY(double? raw) {
    if (raw == null) {
      return double.nan;
    }
    return raw > 1.5 ? raw / 100.0 : raw;
  }

  LineChartBarData _singleLine({
    required Color color,
    required List<double> values,
    bool fillBelow = true,
  }) {
    final spots = <FlSpot>[];
    for (var i = 0; i < values.length; i++) {
      final y = values[i];
      if (!y.isNaN) {
        spots.add(FlSpot(i.toDouble(), y));
      }
    }
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.22,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: fillBelow && spots.isNotEmpty,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  (double, double) _minMaxY(List<LineChartBarData> bars) {
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final bar in bars) {
      for (final s in bar.spots) {
        if (!s.y.isNaN) {
          if (s.y < minY) {
            minY = s.y;
          }
          if (s.y > maxY) {
            maxY = s.y;
          }
        }
      }
    }
    if (minY.isInfinite) {
      return (0, 1);
    }
    if (metric == ResourceChartMetric.cpu) {
      minY = minY.clamp(0, 1);
      maxY = maxY.clamp(0, 1.2);
    }
    return (minY, maxY);
  }
}
