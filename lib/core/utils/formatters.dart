// Pure display helpers for resource rows and detail screens.

import 'package:intl/intl.dart';

String formatBytes(int? bytes, {String ifNull = '—'}) {
  if (bytes == null) return ifNull;
  if (bytes < 0) return ifNull;
  const u = 1024;
  if (bytes < u) return '$bytes B';
  final kb = bytes / u;
  if (kb < u) return '${kb.toStringAsFixed(kb >= 10 ? 0 : 1)} KB';
  final mb = kb / u;
  if (mb < u) return '${mb.toStringAsFixed(mb >= 10 ? 0 : 1)} MB';
  final gb = mb / u;
  if (gb < u) return '${gb.toStringAsFixed(gb >= 10 ? 0 : 1)} GB';
  final tb = gb / u;
  return '${tb.toStringAsFixed(tb >= 10 ? 0 : 1)} TB';
}

/// Formats [fraction] in 0–1 as a percent. Values above 1 are treated as
/// already a percent (clamped).
String formatCpuPercent(double? fraction, {String ifNull = '—'}) {
  if (fraction == null) return ifNull;
  final pct = fraction <= 1.0 ? fraction * 100.0 : fraction;
  final clamped = pct.clamp(0.0, 999.0);
  if (clamped == clamped.roundToDouble()) {
    return '${clamped.round()}%';
  }
  return '${clamped.toStringAsFixed(1)}%';
}

/// Short uptime: `5d 3h`, `2h 15m`, `42s`, etc.
String formatUptimeSeconds(int? seconds, {String ifNull = '—'}) {
  if (seconds == null || seconds < 0) return ifNull;
  var s = seconds;
  final days = s ~/ 86400;
  s %= 86400;
  final hours = s ~/ 3600;
  s %= 3600;
  final minutes = s ~/ 60;
  final secs = s % 60;
  if (days > 0) {
    return '${days}d ${hours}h';
  }
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  if (minutes > 0) {
    return '${minutes}m ${secs}s';
  }
  return '${secs}s';
}

/// Memory use / max for list rows (e.g. `2.0 GB / 8 GB`).
String formatMemoryRatio(int? used, int? max, {String ifNull = '—'}) {
  final u = formatBytes(used, ifNull: '');
  final m = formatBytes(max, ifNull: '');
  if (used == null && max == null) return ifNull;
  if (max == null) return u.isEmpty ? ifNull : u;
  if (used == null) return m.isEmpty ? ifNull : m;
  if (u.isEmpty || m.isEmpty) return ifNull;
  return '$u / $m';
}

/// CPU load as fraction of [maxCpu] cores when both are present; otherwise
/// [cpu] clamped 0–1 when [maxCpu] is null.
double? nodeCpuFraction(double? cpu, int? maxCpu) {
  if (cpu == null) return null;
  if (maxCpu != null && maxCpu > 0) {
    return (cpu / maxCpu).clamp(0.0, 1.0);
  }
  return cpu.clamp(0.0, 1.0);
}

double? memoryFraction(int? mem, int? maxMem) {
  if (mem == null || maxMem == null || maxMem <= 0) return null;
  return (mem / maxMem).clamp(0.0, 1.0);
}

/// Formats a rate in bytes per second (e.g. `1.2 MB/s`).
String formatDataRate(double? bytesPerSecond, {String ifNull = '—'}) {
  if (bytesPerSecond == null || bytesPerSecond < 0) return ifNull;
  final rounded = bytesPerSecond.round();
  return '${formatBytes(rounded)}/s';
}

/// Proxmox Unix time in **seconds** (e.g. backup `ctime`) → local date/time.
String formatProxmoxUnixSeconds(int? seconds, {String ifNull = '—'}) {
  if (seconds == null || seconds <= 0) return ifNull;
  final local =
      DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000,
        isUtc: true,
      ).toLocal();
  return DateFormat.yMMMd().add_Hm().format(local);
}
