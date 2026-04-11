// Parse simple `STORAGE:volume` / `STORAGE:size` prefixes for disk / rootfs
// lines (first comma-separated segment only).

enum PveDiskVolumeKind { existingVolume, newSizeGb }

class ParsedPveDiskPrefix {
  const ParsedPveDiskPrefix({
    required this.storage,
    required this.kind,
    required this.volumeOrSize,
    this.extraOptions = '',
  });

  final String storage;
  final PveDiskVolumeKind kind;

  /// Volume id (e.g. `vm-100-disk-0`) or decimal size in GiB as string.
  final String volumeOrSize;

  /// Comma-separated options after the first segment (e.g. `size=32G`).
  final String extraOptions;

  bool get isStructured =>
      storage.isNotEmpty && volumeOrSize.isNotEmpty && extraOptions.isEmpty;
}

/// First segment before comma: `local-lvm:vm-100-disk-0` or `local-lvm:32`.
ParsedPveDiskPrefix? tryParsePveDiskPrefix(String raw) {
  final s = raw.trim();
  if (s.isEmpty) {
    return null;
  }
  final comma = s.indexOf(',');
  final first = comma < 0 ? s : s.substring(0, comma).trim();
  final extra = comma < 0 ? '' : s.substring(comma + 1).trim();
  final colon = first.indexOf(':');
  if (colon <= 0 || colon >= first.length - 1) {
    return null;
  }
  final storage = first.substring(0, colon).trim();
  final rest = first.substring(colon + 1).trim();
  if (storage.isEmpty || rest.isEmpty) {
    return null;
  }
  final allDigits = RegExp(r'^\d+$').hasMatch(rest);
  if (allDigits) {
    if (extra.isNotEmpty) {
      return ParsedPveDiskPrefix(
        storage: storage,
        kind: PveDiskVolumeKind.newSizeGb,
        volumeOrSize: rest,
        extraOptions: extra,
      );
    }
    return ParsedPveDiskPrefix(
      storage: storage,
      kind: PveDiskVolumeKind.newSizeGb,
      volumeOrSize: rest,
    );
  }
  if (extra.isNotEmpty) {
    return ParsedPveDiskPrefix(
      storage: storage,
      kind: PveDiskVolumeKind.existingVolume,
      volumeOrSize: rest,
      extraOptions: extra,
    );
  }
  return ParsedPveDiskPrefix(
    storage: storage,
    kind: PveDiskVolumeKind.existingVolume,
    volumeOrSize: rest,
  );
}

String buildPveDiskPrefix({
  required String storage,
  required PveDiskVolumeKind kind,
  required String volumeOrSize,
  String extraOptions = '',
}) {
  final st = storage.trim();
  final v = volumeOrSize.trim();
  final first = '$st:$v';
  final x = extraOptions.trim();
  if (x.isEmpty) {
    return first;
  }
  return '$first,$x';
}
