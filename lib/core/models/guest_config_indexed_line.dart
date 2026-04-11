import 'package:flutter/foundation.dart';

/// One Proxmox guest config entry with a fixed API key (e.g. `net0`, `scsi0`,
/// `mp1`) and its raw string value.
@immutable
class GuestConfigIndexedLine {
  const GuestConfigIndexedLine({required this.apiKey, required this.value});

  final String apiKey;
  final String value;

  @override
  bool operator ==(Object other) =>
      other is GuestConfigIndexedLine &&
      other.apiKey == apiKey &&
      other.value == value;

  @override
  int get hashCode => Object.hash(apiKey, value);
}

final RegExp _netKey = RegExp(r'^net(\d+)$');

/// Proxmox QEMU disk-like config keys (see PVE `qm` config reference).
final RegExp _qemuDiskKey = RegExp(
  r'^(ide|scsi|virtio|sata|nvme|efidisk|tpmstate)(\d+)$',
);
final RegExp _lxcMpKey = RegExp(r'^mp(\d+)$');

bool guestConfigIsNetKey(String k) => _netKey.hasMatch(k);

int? guestConfigNetSuffix(String k) {
  final m = _netKey.firstMatch(k);
  if (m == null) {
    return null;
  }
  return int.tryParse(m.group(1)!);
}

bool guestConfigIsQemuDiskKey(String k) => _qemuDiskKey.hasMatch(k);

bool guestConfigIsLxcMpKey(String k) => _lxcMpKey.hasMatch(k);

int _diskSortKey(String k) {
  final m = _qemuDiskKey.firstMatch(k);
  if (m == null) {
    return 0;
  }
  final bus = m.group(1)!;
  final idx = int.tryParse(m.group(2)!) ?? 0;
  return bus.hashCode * 1000 + idx;
}

int _mpSortKey(String k) {
  final m = _lxcMpKey.firstMatch(k);
  if (m == null) {
    return 0;
  }
  return int.tryParse(m.group(1)!) ?? 0;
}

/// Parses `net0`…`net31` from [norm] into sorted lines (by index).
List<GuestConfigIndexedLine> guestConfigParseNetLines(
  Map<String, String> norm,
) {
  final out = <GuestConfigIndexedLine>[];
  for (final e in norm.entries) {
    final n = guestConfigNetSuffix(e.key);
    if (n != null && n >= 0 && n <= 31) {
      out.add(GuestConfigIndexedLine(apiKey: e.key, value: e.value));
    }
  }
  out.sort(
    (a, b) => guestConfigNetSuffix(
      a.apiKey,
    )!.compareTo(guestConfigNetSuffix(b.apiKey)!),
  );
  return out;
}

/// Parses QEMU disk keys (`scsiN`, `virtioN`, …) from [norm].
List<GuestConfigIndexedLine> guestConfigParseQemuDiskLines(
  Map<String, String> norm,
) {
  final out = <GuestConfigIndexedLine>[];
  for (final e in norm.entries) {
    if (guestConfigIsQemuDiskKey(e.key)) {
      out.add(GuestConfigIndexedLine(apiKey: e.key, value: e.value));
    }
  }
  out.sort((a, b) => _diskSortKey(a.apiKey).compareTo(_diskSortKey(b.apiKey)));
  return out;
}

/// Parses LXC `mpN` lines from [norm].
List<GuestConfigIndexedLine> guestConfigParseLxcMpLines(
  Map<String, String> norm,
) {
  final out = <GuestConfigIndexedLine>[];
  for (final e in norm.entries) {
    if (guestConfigIsLxcMpKey(e.key)) {
      out.add(GuestConfigIndexedLine(apiKey: e.key, value: e.value));
    }
  }
  out.sort((a, b) => _mpSortKey(a.apiKey).compareTo(_mpSortKey(b.apiKey)));
  return out;
}
