import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/guest_config/pve_disk_line.dart';

void main() {
  test('parse new size', () {
    final p = tryParsePveDiskPrefix('local-lvm:32');
    expect(p, isNotNull);
    expect(p!.storage, 'local-lvm');
    expect(p.kind, PveDiskVolumeKind.newSizeGb);
    expect(p.volumeOrSize, '32');
    expect(p.isStructured, isTrue);
  });

  test('parse existing volume', () {
    final p = tryParsePveDiskPrefix('local-lvm:vm-100-disk-0');
    expect(p, isNotNull);
    expect(p!.kind, PveDiskVolumeKind.existingVolume);
    expect(p.volumeOrSize, 'vm-100-disk-0');
    expect(p.isStructured, isTrue);
  });

  test('extra options not structured', () {
    final p = tryParsePveDiskPrefix('local-lvm:32,cache=writeback');
    expect(p!.isStructured, isFalse);
  });

  test('build round-trip new', () {
    final s = buildPveDiskPrefix(
      storage: 'slow',
      kind: PveDiskVolumeKind.newSizeGb,
      volumeOrSize: '16',
    );
    expect(s, 'slow:16');
    expect(tryParsePveDiskPrefix(s)!.isStructured, isTrue);
  });
}
