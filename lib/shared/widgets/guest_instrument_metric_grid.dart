import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OrdinalSortKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Stitch-style **2×2** guest detail metric tiles: headline from live guest
/// snapshot + mini activity bars from [vmRrdDataProvider] / [lxcRrdDataProvider].
///
/// Phase E (Stitch plan §4.4): single implementation shared by VM + LXC detail.
class GuestInstrumentMetricGrid extends ConsumerWidget {
  const GuestInstrumentMetricGrid({
    required this.node,
    required this.guestId,
    required this.timeframe,
    required this.isLxc,
    required this.cpuHeadline,
    required this.memoryHeadline,
    required this.diskAllocationHeadline,
    required this.l10n,
    super.key,
  });

  final String node;
  final int guestId;
  final ChartTimeframe timeframe;
  final bool isLxc;

  /// Current CPU (e.g. [formatCpuPercent]).
  final String cpuHeadline;

  /// Memory use / max (e.g. [formatMemoryRatio]).
  final String memoryHeadline;

  /// Disk allocation use / max (e.g. [formatMemoryRatio] for `disk`/`maxDisk`).
  final String diskAllocationHeadline;

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final async =
        isLxc
            ? ref.watch(lxcRrdDataProvider(node, guestId, timeframe))
            : ref.watch(vmRrdDataProvider(node, guestId, timeframe));

    return async.when(
      loading:
          () => _GridBody(
            scheme: scheme,
            l10n: l10n,
            cpuHeadline: cpuHeadline,
            memoryHeadline: memoryHeadline,
            diskHeadline: diskAllocationHeadline,
            networkHeadline: l10n.valueUnavailable,
            points: const [],
          ),
      error:
          (_, _) => _GridBody(
            scheme: scheme,
            l10n: l10n,
            cpuHeadline: cpuHeadline,
            memoryHeadline: memoryHeadline,
            diskHeadline: diskAllocationHeadline,
            networkHeadline: l10n.valueUnavailable,
            points: const [],
          ),
      data:
          (points) => _GridBody(
            scheme: scheme,
            l10n: l10n,
            cpuHeadline: cpuHeadline,
            memoryHeadline: memoryHeadline,
            diskHeadline: diskAllocationHeadline,
            networkHeadline: _networkHeadlineFromPoints(points, l10n),
            points: points,
          ),
    );
  }
}

String _networkHeadlineFromPoints(
  List<ResourceDataPoint> points,
  AppLocalizations l10n,
) {
  for (var i = points.length - 1; i >= 0; i--) {
    final p = points[i];
    final a = p.netIn;
    final b = p.netOut;
    if (a != null || b != null) {
      final sum = (a ?? 0) + (b ?? 0);
      return formatDataRate(sum);
    }
  }
  return l10n.valueUnavailable;
}

double? _cpuNorm(double? raw) {
  if (raw == null) {
    return null;
  }
  return raw > 1.5 ? raw / 100.0 : raw;
}

class _GridBody extends StatelessWidget {
  const _GridBody({
    required this.scheme,
    required this.l10n,
    required this.cpuHeadline,
    required this.memoryHeadline,
    required this.diskHeadline,
    required this.networkHeadline,
    required this.points,
  });

  final ColorScheme scheme;
  final AppLocalizations l10n;
  final String cpuHeadline;
  final String memoryHeadline;
  final String diskHeadline;
  final String networkHeadline;
  final List<ResourceDataPoint> points;

  @override
  Widget build(BuildContext context) {
    final cpuVals =
        points.map((e) => _cpuNorm(e.cpu)).whereType<double>().toList();
    final memVals = points.map((e) => e.mem).whereType<double>().toList();
    final netVals =
        points
            .map((e) {
              final a = e.netIn;
              final b = e.netOut;
              if (a == null && b == null) {
                return null;
              }
              return (a ?? 0) + (b ?? 0);
            })
            .whereType<double>()
            .toList();
    final diskVals =
        points
            .map((e) {
              final a = e.diskRead;
              final b = e.diskWrite;
              if (a == null && b == null) {
                return null;
              }
              return math.max(a ?? 0, b ?? 0);
            })
            .whereType<double>()
            .toList();

    return Semantics(
      container: true,
      label: l10n.guestDetailMetricGridSemantics,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final spacing = AppSpacing.sm;
          final tileW = (w - spacing) / 2;

          Widget row(Widget a, Widget b) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: tileW, child: a),
                SizedBox(width: spacing),
                SizedBox(width: tileW, child: b),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(
                _InstrumentTile(
                  traversalOrder: 0,
                  label: l10n.metricCpu,
                  headline: cpuHeadline,
                  sparkColor: scheme.primary,
                  normalizedSamples: cpuVals,
                  scheme: scheme,
                ),
                _InstrumentTile(
                  traversalOrder: 1,
                  label: l10n.metricMemory,
                  headline: memoryHeadline,
                  sparkColor: scheme.secondary,
                  normalizedSamples: memVals,
                  scheme: scheme,
                ),
              ),
              SizedBox(height: spacing),
              row(
                _InstrumentTile(
                  traversalOrder: 2,
                  label: l10n.metricNetwork,
                  headline: networkHeadline,
                  sparkColor: scheme.primary,
                  normalizedSamples: netVals,
                  scheme: scheme,
                ),
                _InstrumentTile(
                  traversalOrder: 3,
                  label: l10n.metricDisk,
                  headline: diskHeadline,
                  sparkColor: AppColors.chartDiskRead,
                  normalizedSamples: diskVals,
                  scheme: scheme,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InstrumentTile extends StatelessWidget {
  const _InstrumentTile({
    required this.traversalOrder,
    required this.label,
    required this.headline,
    required this.sparkColor,
    required this.normalizedSamples,
    required this.scheme,
  });

  /// Left→right, top→bottom (Stitch plan §6).
  final int traversalOrder;
  final String label;
  final String headline;
  final Color sparkColor;
  final ColorScheme scheme;
  final List<double> normalizedSamples;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Semantics(
      sortKey: OrdinalSortKey(traversalOrder.toDouble()),
      label: '$label, $headline',
      child: Material(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 10,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Scale down long metrics at elevated text scale (e.g. 1.3×) so
              // 2×2 cells stay within tile width without clipping.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  headline,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: tt.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.05,
                    color: scheme.onSurface,
                    fontSize: 26,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 28,
                child: _MiniSparkBars(
                  samples: normalizedSamples,
                  color: sparkColor,
                  track: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<double> _normalizeForBars(List<double> raw) {
  if (raw.isEmpty) {
    return const [];
  }
  var lo = raw.first;
  var hi = raw.first;
  for (final v in raw) {
    lo = math.min(lo, v);
    hi = math.max(hi, v);
  }
  final span = (hi - lo).abs() < 1e-12 ? 1.0 : (hi - lo);
  return raw.map((v) => ((v - lo) / span).clamp(0.08, 1.0)).toList();
}

class _MiniSparkBars extends StatelessWidget {
  const _MiniSparkBars({
    required this.samples,
    required this.color,
    required this.track,
  });

  final List<double> samples;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }
    final n = math.min(samples.length, 32);
    final slice = samples.sublist(math.max(0, samples.length - n));
    final norm = _normalizeForBars(slice);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < norm.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: track,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: norm[i],
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
