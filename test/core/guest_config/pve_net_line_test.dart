import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/guest_config/pve_net_line.dart';

void main() {
  group('tryParseQemuNetLine', () {
    test('parses simple virtio bridge', () {
      final p = tryParseQemuNetLine('virtio,bridge=vmbr0');
      expect(p, isNotNull);
      expect(p!.model, 'virtio');
      expect(p.bridge, 'vmbr0');
      expect(p.isStructured, isTrue);
    });

    test('rejects extra options as structured', () {
      final p = tryParseQemuNetLine('virtio,bridge=vmbr0,firewall=1');
      expect(p, isNotNull);
      expect(p!.isStructured, isFalse);
    });
  });

  group('buildQemuNetLine', () {
    test('round-trip simple', () {
      const s = 'virtio,bridge=vmbr1';
      final p = tryParseQemuNetLine(s)!;
      expect(buildQemuNetLine(model: p.model, bridge: p.bridge), s);
    });
  });

  group('tryParseLxcNetLine', () {
    test('parses dhcp', () {
      final p = tryParseLxcNetLine('name=eth0,bridge=vmbr0,ip=dhcp');
      expect(p, isNotNull);
      expect(p!.name, 'eth0');
      expect(p.bridge, 'vmbr0');
      expect(p.ipMode, GuestNetIpMode.dhcp);
      expect(p.isStructured, isTrue);
    });

    test('parses static', () {
      final p = tryParseLxcNetLine('name=eth0,bridge=vmbr0,ip=10.0.0.5/24');
      expect(p, isNotNull);
      expect(p!.ipMode, GuestNetIpMode.static);
      expect(p.staticIp, '10.0.0.5/24');
    });
  });

  group('buildLxcNetLine', () {
    test('dhcp', () {
      expect(
        buildLxcNetLine(
          name: 'eth0',
          bridge: 'vmbr0',
          ipMode: GuestNetIpMode.dhcp,
        ),
        'name=eth0,bridge=vmbr0,ip=dhcp',
      );
    });

    test('none omits ip', () {
      expect(
        buildLxcNetLine(
          name: 'eth1',
          bridge: 'vmbr2',
          ipMode: GuestNetIpMode.none,
        ),
        'name=eth1,bridge=vmbr2',
      );
    });
  });
}
