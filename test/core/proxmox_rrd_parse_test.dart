import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';

void main() {
  group('parseProxmoxRrdData', () {
    test('parses object rows with metric fields', () {
      final data = [
        {
          'time': 1700000000,
          'cpu': 0.25,
          'mem': 1e9,
          'netin': 100.0,
          'netout': 200.0,
          'diskread': 300.0,
          'diskwrite': 400.0,
        },
      ];
      final pts = parseProxmoxRrdData(data);
      expect(pts, hasLength(1));
      expect(pts.single.cpu, 0.25);
      expect(pts.single.mem, 1e9);
      expect(pts.single.netIn, 100.0);
      expect(pts.single.netOut, 200.0);
      expect(pts.single.diskRead, 300.0);
      expect(pts.single.diskWrite, 400.0);
    });

    test('parses QEMU-style array rows (time, maxcpu, cpu, mem, …)', () {
      final data = [
        [1700000000, 4, 0.5, 2e9, 8e9, 10.0, 20.0, 30.0, 40.0],
      ];
      final pts = parseProxmoxRrdData(data);
      expect(pts, hasLength(1));
      expect(pts.single.cpu, 0.5);
      expect(pts.single.mem, 2e9);
      expect(pts.single.netIn, 10.0);
      expect(pts.single.netOut, 20.0);
      expect(pts.single.diskRead, 30.0);
      expect(pts.single.diskWrite, 40.0);
    });

    test('skips time-only sparse rows', () {
      final data = [
        [1700000000, 4, 0.1, 1.0, 2.0, 0.0, 0.0, 0.0, 0.0],
        [1700000060],
        {'time': 1700000120},
      ];
      final pts = parseProxmoxRrdData(data);
      expect(pts, hasLength(1));
    });

    test('returns empty list for null data', () {
      expect(parseProxmoxRrdData(null), isEmpty);
    });
  });
}
