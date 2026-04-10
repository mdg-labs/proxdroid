import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_data_point.freezed.dart';

/// One RRD sample for resource charts (VM, LXC, or node).
///
/// Parsed from Proxmox `rrddata` `data` entries (object maps or fixed-order
/// arrays — see API client parsing).
@freezed
sealed class ResourceDataPoint with _$ResourceDataPoint {
  const factory ResourceDataPoint({
    required DateTime timestamp,
    double? cpu,
    double? mem,
    double? netIn,
    double? netOut,
    double? diskRead,
    double? diskWrite,
  }) = _ResourceDataPoint;
}

/// UI + API timeframe for `GET …/rrddata?timeframe=…`.
///
/// `year` is intentionally omitted for MVP (see roadmap §4.1).
enum ChartTimeframe {
  hour,
  day,
  week,
  month;

  /// Query value for Proxmox `timeframe`.
  String get apiValue => switch (this) {
    ChartTimeframe.hour => 'hour',
    ChartTimeframe.day => 'day',
    ChartTimeframe.week => 'week',
    ChartTimeframe.month => 'month',
  };
}
