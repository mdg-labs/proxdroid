import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';

Map<String, String> _normalizedFlat(Map<String, dynamic> raw) => {
  for (final e in raw.entries) e.key: proxmoxString(e.value),
};

void main() {
  group('QemuVmConfig.fromProxmoxConfigData', () {
    test('8.x fixture preserves every key (structured + passthrough)', () {
      final raw =
          jsonDecode(
                File('test/fixtures/qemu_config_8x.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final parsed = QemuVmConfig.fromProxmoxConfigData(raw);
      expect(parsed.toFlatConfigMap(), equals(_normalizedFlat(raw)));
    });

    test('9.x fixture preserves every key (structured + passthrough)', () {
      final raw =
          jsonDecode(
                File('test/fixtures/qemu_config_9x.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final parsed = QemuVmConfig.fromProxmoxConfigData(raw);
      expect(parsed.toFlatConfigMap(), equals(_normalizedFlat(raw)));
    });
  });

  group('LxcContainerConfig.fromProxmoxConfigData', () {
    test('8.x fixture preserves every key (structured + passthrough)', () {
      final raw =
          jsonDecode(
                File('test/fixtures/lxc_config_8x.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final parsed = LxcContainerConfig.fromProxmoxConfigData(raw);
      expect(parsed.toFlatConfigMap(), equals(_normalizedFlat(raw)));
    });

    test('9.x fixture preserves every key (structured + passthrough)', () {
      final raw =
          jsonDecode(
                File('test/fixtures/lxc_config_9x.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final parsed = LxcContainerConfig.fromProxmoxConfigData(raw);
      expect(parsed.toFlatConfigMap(), equals(_normalizedFlat(raw)));
    });
  });
}
